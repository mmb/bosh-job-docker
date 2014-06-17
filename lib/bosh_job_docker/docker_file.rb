# encoding: UTF-8

require 'stringio'

module BoshDockerJob
  # Builds a Dockerfile.
  class DockerFile
    def initialize
      @buffer = StringIO.new
    end

    def apt_get(packages)
      packages.sort.each do |package|
        run("apt-get install -y #{package}")
      end
      blank_line
    end

    def add(src, dest)
      line("ADD #{src} #{dest}")
    end

    def env(name, value)
      line("ENV #{name} #{value}")
    end

    def from(image)
      line("FROM #{image}")
      blank_line
    end

    def run(command)
      line("RUN #{command}")
    end

    def blank_line
      buffer << "\n"
    end

    def comment(text)
      line("# #{text}")
    end

    def write(path)
      open(path, 'w') { |f| f.write(buffer.string) }
    end

    private

    def line(line)
      buffer << line
      buffer << "\n"
    end

    attr_reader :buffer
  end
end
