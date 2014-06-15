#!/usr/bin/env ruby

require 'English'

require 'bosh_job_docker'

class BoshJobDocker::TarExtracter
  def extract(tarball, dir)
    pid = spawn('tar', '-C', dir, '-xzf', tarball)
    Process.wait(pid)
    raise 'tar command failed' unless $CHILD_STATUS.success?
  end
end
