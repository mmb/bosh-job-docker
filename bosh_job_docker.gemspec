# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = 'bosh_job_docker'
  s.version = '0.0.1'
  s.summary = 'Build a Docker container with all packages from a BOSH job'
  s.description = s.summary
  s.homepage = 'https://github.com/mmb/bosh_job_docker'
  s.authors = ['Matthew M. Boedicker']
  s.email = %w(matthewm@boedicker.org)
  s.license = 'MIT'

  s.files = `git ls-files`.split("\n")
  s.executables = %w(bosh_job_docker)

  s.add_development_dependency 'rake', '~> 10.3'
  s.add_development_dependency 'rubocop', '~> 0.23'
  s.add_development_dependency 'rspec', '~> 3.0'
end
