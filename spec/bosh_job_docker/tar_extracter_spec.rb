# encoding: UTF-8
#
require 'tempfile'

require 'bosh_job_docker/tar_extracter'

describe BoshJobDocker::TarExtracter do
  subject(:tar_extracter) { described_class.new }

  describe '#extract' do
    it 'extracts a tar file to a directory' do
      test_tar = File.join(
        File.dirname(__FILE__), '..', 'support', 'test.tar.gz')
      Dir.mktmpdir do |tempdir|
        tar_extracter.extract(test_tar, tempdir)
        expect(File.read(File.join(tempdir, 'test', 'a'))).to eq("a\n")
        expect(File.read(File.join(tempdir, 'test', 'b'))).to eq("b\n")
        expect(Dir["#{tempdir}/**/*"].size).to eq(3)
      end
    end
  end

end
