# encoding: UTF-8

require 'tempfile'

require 'bosh_job_docker/bosh_job_docker_file'

describe BoshJobDocker::BoshJobDockerFile do
  subject(:bosh_job_docker_file) { described_class.new }

  describe '#add_package' do
    it 'adds the docker commands to compile a package' do
      bosh_job_docker_file.add_package('test')
      output = Tempfile.new('docker_file')
      bosh_job_docker_file.write(output.path)
      expect(File.read(output.path)).to eq <<-EOS
FROM ubuntu

RUN apt-get update
RUN apt-get install -y build-essential
RUN apt-get install -y cmake
RUN apt-get install -y gettext
RUN apt-get install -y libbz2-dev
RUN apt-get install -y libcap-dev
RUN apt-get install -y libreadline-dev
RUN apt-get install -y libssl-dev
RUN apt-get install -y libxml2-dev
RUN apt-get install -y libxslt1-dev
RUN apt-get install -y unzip
RUN apt-get install -y zlib1g-dev

ADD build /build
RUN mkdir -p /var/vcap/packages

# test
ENV BOSH_INSTALL_TARGET /var/vcap/packages/test
RUN mkdir $BOSH_INSTALL_TARGET
RUN cd /build/test && bash packaging

EOS
    end
  end

  describe '#write' do
    it 'writes the Dockerfile' do
      bosh_job_docker_file.add_package('test')
      output = Tempfile.new('docker_file')
      bosh_job_docker_file.write(output.path)
      expect(File.read(output.path)).to eq <<-EOS
FROM ubuntu

RUN apt-get update
RUN apt-get install -y build-essential
RUN apt-get install -y cmake
RUN apt-get install -y gettext
RUN apt-get install -y libbz2-dev
RUN apt-get install -y libcap-dev
RUN apt-get install -y libreadline-dev
RUN apt-get install -y libssl-dev
RUN apt-get install -y libxml2-dev
RUN apt-get install -y libxslt1-dev
RUN apt-get install -y unzip
RUN apt-get install -y zlib1g-dev

ADD build /build
RUN mkdir -p /var/vcap/packages

# test
ENV BOSH_INSTALL_TARGET /var/vcap/packages/test
RUN mkdir $BOSH_INSTALL_TARGET
RUN cd /build/test && bash packaging

EOS
    end
  end
end
