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

  context '#controller_spec_path' do
    let(:root) { __dir__.chomp('services') }

    context 'when the controller is in app/controllers' do
      it 'returns the correct path' do
        path = 'spec/fixtures/controllers/groups_controller/index/fixture.yml'

        expected = root + 'integration/controllers/groups_controller_spec.rb'

        expect(subject.send(:controller_spec_path, path)).to eq expected
      end
    end

    context 'when the controller is nested in a directory within app/controllers' do
      it 'returns the correct path' do
        path = 'spec/fixtures/controllers/groups/layings_controller/index/fixture.yml'

        expected = root + 'integration/controllers/groups/layings_controller_spec.rb'

        expect(subject.send(:controller_spec_path, path)).to eq expected
      end

      it 'returns the correct path when it is really nested' do
        path = 'spec/fixtures/controllers/groups/questions/written/answered_controller/index/fixture.yml'

        expected = root + 'integration/controllers/groups/questions/written/answered_controller_spec.rb'

        expect(subject.send(:controller_spec_path, path)).to eq expected
      end
    end

    context 'when it is in app/controllers/concerns' do
      it 'returns the correct path' do
        path = 'spec/fixtures/controllers/concerns/pagination_helper/create_number_cards.yml'

        expected = root + 'controllers/concerns/pagination_helper_spec.rb'

        expect(subject.send(:controller_spec_path, path)).to eq expected
      end

      it 'returns the correct path if it is really nested' do
        path = 'spec/fixtures/controllers/concerns/pagination_helper/another_one/some_other_helper/some_fixture.yml'

        expected = root + 'controllers/concerns/pagination_helper/another_one/some_other_helper_spec.rb'

        expect(subject.send(:controller_spec_path, path)).to eq expected
      end
    end
  end

  context '#controller_method' do
    context 'when the controller is in app/controllers' do
      it 'returns the correct controller method' do
        path = 'spec/fixtures/controllers/groups_controller/index/fixture.yml'

        expect(subject.send(:controller_method, path)).to eq 'index'
      end
    end

    context 'when the controller is nested in a directory within app/controllers' do
      it 'returns the correct controller method' do
        path = 'spec/fixtures/controllers/groups/layings_controller/index/fixture.yml'

        expect(subject.send(:controller_method, path)).to eq 'index'
      end

      it 'returns the correct controller method when it is really nested' do
        path = 'spec/fixtures/controllers/groups/questions/written/answered_controller/index/fixture.yml'

        expect(subject.send(:controller_method, path)).to eq 'index'
      end
    end
  end
end
