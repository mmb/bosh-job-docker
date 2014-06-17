# encoding: UTF-8

require 'bosh_job_docker/package_dep_resolver'

describe BoshJobDocker::PackageDepResolver do
  subject(:package_dep_resolver) { described_class.new(release_manifest) }

  describe '#package_deps' do
    context 'no deps' do
      let(:release_manifest) do
        {
          'packages' => [
            { 'name' => 'package1', 'dependencies' => [] }
          ]
        }
      end

      it 'returns a single package' do
        expect(package_dep_resolver.package_deps('package1')).to eq(
          %w(package1))
      end
    end

    context 'simple dependency' do
      let(:release_manifest) do
        {
          'packages' => [
            { 'name' => 'package1', 'dependencies' => %w(package2) },
            { 'name' => 'package2', 'dependencies' => [] }
          ]
        }
      end

      it 'foo' do
        expect(package_dep_resolver.package_deps('package1')).to eq(
          %w(package2 package1))
      end
    end

    context 'complicated dependency tree' do
      let(:release_manifest) do
        {
          'packages' => [
            { 'name' => 'package1', 'dependencies' => %w(package2 package4) },
            { 'name' => 'package2', 'dependencies' => %w(package3) },
            { 'name' => 'package3', 'dependencies' => %w(package4) },
            { 'name' => 'package4', 'dependencies' => [] }
          ]
        }
      end

      it 'foo' do
        expect(package_dep_resolver.package_deps('package1')).to eq(
          %w(package4 package3 package2 package4 package1))
      end
    end
  end
end
