require_relative '../../rails_helper'

RSpec.describe 'sweep' do
  include_context 'rake'

  let(:fixture_sweeper_instance) { double('fixture_sweeper_instance') }

  before(:each) do
    allow(FixtureSweeper).to receive(:new) { fixture_sweeper_instance }

    allow(fixture_sweeper_instance).to receive(:sweep)
  end

  context 'with --simulate argument passed' do
    before(:each) do
      stub_const('::ARGV', %w(sweep --simulate))
    end

    it 'sweeps with simulate argument passed in as true' do
      subject.invoke

      expect(fixture_sweeper_instance).to have_received(:sweep).with(simulate: true)
    end
  end

  context 'without --simulate argument passed' do
    before(:each) do
      stub_const('::ARGV', %w(sweep))
    end

    it 'sweeps with simulate argument passed in as false' do
      subject.invoke

      expect(fixture_sweeper_instance).to have_received(:sweep).with(simulate: false)
    end
  end
end