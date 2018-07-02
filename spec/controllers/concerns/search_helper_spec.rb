require_relative '../../rails_helper'

RSpec.describe SearchHelper, type: :helper do
  describe '#sanitize_query' do
    it 'sanitizes correctly' do
      allow(Sanitize).to receive(:fragment)

      SearchHelper.sanitize_query('hello')

      expect(Sanitize).to have_received(:fragment).with('hello', Sanitize::Config::RELAXED)
    end
  end
end