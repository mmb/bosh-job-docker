#!/usr/bin/env ruby

require 'English'

module BoshJobDocker
  class TarExtracter
    def extract(tarball, dir)
      pid = spawn('tar', '-C', dir, '-xzf', tarball)
      Process.wait(pid)
      fail 'tar command failed' unless $CHILD_STATUS.success?
    end
  end
end
