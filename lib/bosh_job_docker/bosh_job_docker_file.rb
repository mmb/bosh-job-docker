# encoding: UTF-8

require 'bosh_job_docker/docker_file'

module BoshJobDocker
  # Builds a Dockerfile for a BOSH job.
  class BoshJobDockerFile
    def initialize
      @docker_file = DockerFile.new
      add_preamble
    end

    def add_package(package)
      docker_file.comment(package)
      docker_file.env('BOSH_INSTALL_TARGET', "/var/vcap/packages/#{package}")
      docker_file.run('mkdir $BOSH_INSTALL_TARGET')
      docker_file.run("cd /build/#{package} && bash packaging")
      docker_file.blank_line
    end

    def write(path)
      @docker_file.write(path)
    end

    private

    def add_preamble
      docker_file.from('ubuntu')
      docker_file.run('apt-get update')
      add_apt_gets
      docker_file.add('build', '/build')
      docker_file.run('mkdir -p /var/vcap/packages')
      docker_file.blank_line
    end

    def add_apt_gets # rubocop:disable MethodLength
      docker_file.apt_get(%w(
        build-essential
        cmake
        gettext
        libbz2-dev
        libcap-dev
        libreadline-dev
        libssl-dev
        libxml2-dev
        libxslt1-dev
        zlib1g-dev
        unzip
      ))
    end

    attr_reader :docker_file
  end
end
