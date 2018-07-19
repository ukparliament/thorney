require_relative '../rails_helper'

RSpec.describe PathManager do
  let(:root) { __dir__.chomp('spec/services') }

  it '#fixture_parent_folder' do
    path_hash = { fixture_path: 'spec/fixtures/serializers/component_serializer/list_component_serializer/generic.yml' }

    expect(subject.fixture_parent_folder(path_hash)).to eq "#{root}spec/fixtures/serializers/component_serializer/list_component_serializer/"
  end

  context '#spec_and_fixture' do
    it 'if it is a controller fixture' do
      path = 'spec/fixtures/controllers/search_controller/index/empty_query.yml'

      expected = {
          controller_method: 'index',
          spec: "#{root}spec/integration/controllers/search_controller_spec.rb",
          fixture_name: 'empty_query.yml',
          fixture_path: 'spec/fixtures/controllers/search_controller/index/empty_query.yml'
      }

      expect(subject.spec_and_fixture(path)).to eq expected
    end

    it 'if it is a generic fixture' do
      path = 'spec/fixtures/serializers/component_serializer/list_component_serializer/generic.yml'

      expected = {
          spec: "#{root}spec/serializers/component_serializer/list_component_serializer_spec.rb",
          fixture_name: 'generic.yml',
          fixture_path: 'spec/fixtures/serializers/component_serializer/list_component_serializer/generic.yml'
      }

      expect(subject.spec_and_fixture(path)).to eq expected
    end
  end

  it '#full_path' do
    expect(subject.full_path('hello')).to eq "#{root}hello"
  end

  it '#list_paths' do
    stdout_double = double('stdout_double', puts: '')

    subject.list_paths([1], stdout: stdout_double)

    expect(stdout_double).to have_received(:puts).with 1
  end
end