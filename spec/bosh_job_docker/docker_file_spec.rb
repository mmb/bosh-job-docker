# encoding: UTF-8

require 'stringio'
require 'tempfile'

require 'bosh_job_docker/docker_file'

describe BoshJobDocker::DockerFile do
  subject(:dockerfile) { described_class.new }

  describe '#apt_get' do
    it 'adds RUN lines for installing packages' do
      dockerfile.apt_get(%w(a b c))
      output = Tempfile.new('docker_file')
      dockerfile.write(output.path)
      expect(File.read(output.path)).to eq <<-EOS
RUN apt-get install -y a
RUN apt-get install -y b
RUN apt-get install -y c

EOS
    end
  end

  describe '#add' do
    it 'adds ADD lines' do
      dockerfile.add('src', 'dest')
      output = Tempfile.new('docker_file')
      dockerfile.write(output.path)
      expect(File.read(output.path)).to eq("ADD src dest\n")
    end
  end

  describe '#env' do
    it 'adds ENV lines' do
      dockerfile.env('name', 'value')
      output = Tempfile.new('docker_file')
      dockerfile.write(output.path)
      expect(File.read(output.path)).to eq("ENV name value\n")
    end
  end

  describe '#from' do
    it 'adds FROM lines' do
      dockerfile.from('image')
      output = Tempfile.new('docker_file')
      dockerfile.write(output.path)
      expect(File.read(output.path)).to eq("FROM image\n\n")
    end
  end

  describe '#run' do
    it 'adds RUN lines' do
      dockerfile.run('command arg')
      output = Tempfile.new('docker_file')
      dockerfile.write(output.path)
      expect(File.read(output.path)).to eq("RUN command arg\n")
    end
  end

  describe '#blank_line' do
    it 'adds blank lines' do
      dockerfile.blank_line
      output = Tempfile.new('docker_file')
      dockerfile.write(output.path)
      expect(File.read(output.path)).to eq("\n")
    end
  end

  describe '#comment' do
    it 'adds comment lines' do
      dockerfile.comment('comment')
      output = Tempfile.new('docker_file')
      dockerfile.write(output.path)
      expect(File.read(output.path)).to eq("# comment\n")
    end
  end

  describe '#write' do
    it 'writes a Dockerfile' do
      dockerfile.from('image')
      dockerfile.comment('boom')
      dockerfile.run('%0|%0')
      output = Tempfile.new('docker_file')
      dockerfile.write(output.path)
      expect(File.read(output.path)).to eq <<-EOS
FROM image

# boom
RUN %0|%0
EOS
    end
  end
end
