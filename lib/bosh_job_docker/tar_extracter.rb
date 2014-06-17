#!/usr/bin/env ruby
# encoding: UTF-8

require 'English'

module BoshJobDocker
  # Extract a tarball into a directory.
  class TarExtracter
    def extract(tarball, dir)
      pid = spawn('tar', '-C', dir, '-xzf', tarball)
      Process.wait(pid)
      fail 'tar command failed' unless $CHILD_STATUS.success?
    end
  end
end
