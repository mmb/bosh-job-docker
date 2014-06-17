# encoding: UTF-8

module BoshJobDocker
  # BOSH package dependency resolver.
  class PackageDepResolver
    def initialize(release_manifest)
      @release_manifest = release_manifest
    end

    def package_deps(package_name)
      package = lookup_package(package_name)
      deps = package['dependencies'].map { |p| package_deps(p) }.flatten
      deps << package_name
    end

    private

    def lookup_package(package_name)
      release_manifest['packages'].find { |p| p['name'] == package_name }
    end

    attr_reader :release_manifest
  end
end
