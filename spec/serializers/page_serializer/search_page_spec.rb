require_relative '../../rails_helper'

describe PageSerializer::SearchPage do
  let(:results) { double('results', totalResults: 658) }
  let(:subject) { described_class.new(query: 'banana', results: results) }

  context 'raising errors' do
    it '#title' do
      expect{ subject.send(:title) }.to raise_error StandardError, 'You must implement #title'
    end

    it '#content' do
      expect{ subject.send(:content) }.to raise_error StandardError, 'You must implement #content'
    end
  end

  it '#section_primary_components' do
    allow(ComponentSerializer::HeadingComponentSerializer).to receive(:new)
    allow(ComponentSerializer::SearchFormComponentSerializer).to receive(:new)

    subject.send(:section_primary_components, 'results_heading')

    expect(ComponentSerializer::HeadingComponentSerializer).to have_received(:new).with(content: ['results_heading'], size: 1)
    expect(ComponentSerializer::SearchFormComponentSerializer).to have_received(:new).with('banana', [ComponentSerializer::SearchIconComponentSerializer.new.to_h])
  end

  it '#total_results' do
    expect(subject.send(:total_results)).to eq 658
  end
end
