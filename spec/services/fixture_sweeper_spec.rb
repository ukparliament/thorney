require_relative '../rails_helper'

RSpec.describe FixtureSweeper do
  let(:stdout_double) { double('stdout_double') }
  let(:path_manager_instance) { double('path_manager_instance', spec_and_fixture: {}, fixture_parent_folder: '', list_paths: true, full_path: 'some_full_path') }
  let(:path_manager_double) { double('path_manager_double', new: path_manager_instance) }
  let(:subject) { described_class.new(path_manager_double) }

  context '#sweep' do
    before(:each) do
      allow(subject).to receive(:exit)

      allow(stdout_double).to receive(:puts)
    end

    context 'there are no unused fixtures' do
      it 'prints the message to stdout' do
        allow(subject).to receive(:unused_fixtures) { [] }

        subject.sweep(stdout_double)

        expect(stdout_double).to have_received(:puts).with 'No unused fixtures were found'
      end
    end

    context 'there are unused fixtures' do
      it 'it is a simulation' do
        subject.sweep(stdout_double, simulate: true)

        expect(stdout_double).to have_received(:puts ).with 'Checking for unused fixtures...'
        expect(stdout_double).to have_received(:puts ).with 'The following unused fixtures were found:'
        expect(path_manager_instance).to have_received(:list_paths )
        expect(stdout_double).to have_received(:puts ).with no_args
        expect(stdout_double).to have_received(:puts ).with 'Run "bundle exec rake sweep" to delete unused fixtures'
      end

      it 'it is for real this time' do
        allow(subject).to receive(:delete_fixtures)

        subject.sweep(stdout_double)

        expect(subject).to have_received(:delete_fixtures)
        expect(stdout_double).to have_received(:puts).with 'The unused fixtures were deleted'
      end
    end

    it '#delete_fixtures' do
      file_utils_double = double('file_utils_double')
      allow(file_utils_double).to receive(:remove_dir)

      subject.send(:delete_fixtures, file_utils_double)

      expect(file_utils_double).to have_received(:remove_dir).with('', true).at_least(36).times
    end

    it '#check_file' do
      path_hash = { fixture_name: 'hello.yml', spec: 'some_spec', fixture_path: 'fixture_path' }
      file_double = double('file_double', open: 'some_file')

      expect(subject.send(:check_file, path_hash, file_double)).to eq 'some_full_path'
    end

    context '#name_check' do
      it 'generic fixture' do
        path_hash = { fixture_name: 'hello.yml' }

        expect(subject.send(:name_check, path_hash)).to eq 'get_fixture(\'hello\')'
      end

      it 'controller fixture' do
        path_hash = { fixture_name: 'hello.yml', controller_method: 'some_controller_method' }

        expect(subject.send(:name_check, path_hash)).to eq 'get_fixture(\'some_controller_method\', \'hello\')'
      end
    end
  end
end