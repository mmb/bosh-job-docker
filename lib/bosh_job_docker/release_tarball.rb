# encoding: UTF-8

require 'fileutils'
require 'tempfile'
require 'yaml'

require 'bosh_job_docker/package_dep_resolver'
require 'bosh_job_docker/tar_extracter'

module BoshJobDocker
  # A BOSH release tarball.
  class ReleaseTarball
    def initialize(path)
      @work_dir = Dir.mktmpdir
      @extracter = TarExtracter.new

      extracter.extract(path, work_dir)
      @resolver = PackageDepResolver.new(release_manifest)
    end

    def release_manifest
      YAML.load_file(File.join(work_dir, 'release.MF'))
    end

    def extract_package(package, dest)
      FileUtils.mkdir_p(dest)
      extracter.extract(package_tarball_path(package), dest)
    end

    def build_order(job)
      job_packages(job).reduce([]) do |order, p|
        order + resolver.package_deps(p)
      end.uniq
    end

    private

    def job_tarball_path(job)
      File.join(work_dir, 'jobs', "#{job}.tgz")
    end

    def job_spec(job)
      job_work_dir = Dir.mktmpdir
      extracter.extract(job_tarball_path(job), job_work_dir)
      YAML.load_file(File.join(job_work_dir, 'job.MF'))
    end

    def job_packages(job)
      job_spec(job)['packages']
    end

    def package_tarball_path(package)
      File.join(work_dir, 'packages', "#{package}.tgz")
    end

    attr_reader :extracter
    attr_reader :resolver
    attr_reader :work_dir
  end
end
