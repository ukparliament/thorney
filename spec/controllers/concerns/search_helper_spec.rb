require_relative '../../rails_helper'

RSpec.describe SearchHelper, type: :helper do
  describe '#sanitize_query' do
    it 'sanitizes correctly' do
      allow(Sanitize).to receive(:fragment)

      SearchHelper.sanitize_query('hello')

      expect(Sanitize).to have_received(:fragment).with('hello', Sanitize::Config::RELAXED)
    end

    context 'sanitizes as expected' do
      it 'removes all content for script tags' do
        sanitized = SearchHelper.sanitize_query('<script>alert(document.cookie)</script>')

        expect(sanitized).to eq('')
      end
    end
  end
end