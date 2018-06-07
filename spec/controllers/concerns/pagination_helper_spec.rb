require_relative '../../rails_helper'

RSpec.describe PaginationHelper, type: :helper do
  include SerializerFixtureHelper

  let(:pagination_hash) { { start_index: 10, count: 123, results_total: 321, search_url: 'some_url', query: 'hello' } }
  let(:pagination_helper) { described_class.new(pagination_hash) }

  describe 'pagination helpers' do
    it '#current_page' do
      expect(pagination_helper.current_page).to eq 1
    end

    context '#first_page' do
      it 'if current_page is less than or equal to 6' do
        allow(pagination_helper).to receive(:current_page) { 5 }

        expect(pagination_helper.first_page).to eq 1
      end

      it '(current_page > last_page - (10 - 6) && last_page > 10)' do
        allow(pagination_helper).to receive(:current_page) { 15 }
        allow(pagination_helper).to receive(:last_page) { 11 }

        expect(pagination_helper.first_page).to eq 2
      end

      it 'current_page minus 5' do
        allow(pagination_helper).to receive(:current_page) { 15 }
        allow(pagination_helper).to receive(:last_page) { 9 }

        expect(pagination_helper.first_page).to eq 10
      end
    end

    context '#active_tile' do
      it '(current_page > (@count / 2) && current_page < @count - (@count / 2 - 1)' do
        allow(pagination_helper).to receive(:current_page) { 62 }

        expect(pagination_helper.active_tile).to eq 6
      end
    end
  end

  describe '#navigation_section_components' do
    it 'creates the correct hash' do
      expected = get_fixture('create_number_cards')

      expect(pagination_helper.navigation_section_components.to_yaml).to eq expected
    end
  end
end