require_relative '../../rails_helper'

RSpec.describe PageSerializer::SearchPage do
  include_context "sample request", :include_shared => true

  let(:results) { double('results', totalResults: 658) }

  subject { described_class.new(request: request, query: 'banana', results: results) }

  context 'raising errors' do
    it '#content' do
      expect{ subject.send(:content) }.to raise_error StandardError, 'You must implement #content'
    end
  end

  it '#section_primary_components' do
    allow(ComponentSerializer::Heading1ComponentSerializer).to receive(:new)
    allow(ComponentSerializer::SearchFormComponentSerializer).to receive(:new)

    subject.send(:section_primary_components, 'results_heading', 'banana', true)

    expect(ComponentSerializer::Heading1ComponentSerializer).to have_received(:new).with(heading_content: 'results_heading', context_content: 'banana', context_hidden: true)
    expect(ComponentSerializer::SearchFormComponentSerializer).to have_received(:new).with(query: 'banana', components: [ComponentSerializer::SearchIconComponentSerializer.new.to_h])
  end

  it '#total_results' do
    expect(subject.send(:total_results)).to eq 658
  end
end
