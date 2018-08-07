require_relative '../../rails_helper'

RSpec.describe PaginationHelper, type: :helper do
  include SerializerFixtureHelper

  let(:pagination_hash) { { start_index: 10, count: 123, results_total: 321, search_path: 'some_url', query: 'hello' } }
  let(:pagination_helper) { described_class.new(pagination_hash) }

  describe 'pagination helpers' do
    it '#current_page' do
      expect(pagination_helper.send(:current_page)).to eq 1
    end

    context '#page_range' do
      context 'when there are 100 pages in total' do
        before(:each) do
          allow(pagination_helper).to receive(:total_pages) { 100 }
        end

        it 'current page is 51' do
          allow(pagination_helper).to receive(:current_page) { 51 }

          expect(pagination_helper.send(:page_range)).to eq [46, 47, 48, 49, 50, 51, 52, 53, 54, 55]
        end

        it 'current page is 2' do
          allow(pagination_helper).to receive(:current_page) { 2 }

          expect(pagination_helper.send(:page_range)).to eq [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
        end

        it 'current page is 4' do
          allow(pagination_helper).to receive(:current_page) { 4 }

          expect(pagination_helper.send(:page_range)).to eq [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
        end

        it 'current page is 97' do
          allow(pagination_helper).to receive(:current_page) { 97 }

          expect(pagination_helper.send(:page_range)).to eq [91, 92, 93, 94, 95, 96, 97, 98, 99, 100]
        end

        it 'current page is 99' do
          allow(pagination_helper).to receive(:current_page) { 99 }

          expect(pagination_helper.send(:page_range)).to eq [91, 92, 93, 94, 95, 96, 97, 98, 99, 100]
        end

        context 'when the current page is greater than the total number of pages' do
          it 'current page is 150' do
            allow(pagination_helper).to receive(:current_page) { 150 }

            expect(pagination_helper.send(:page_range)).to eq [141, 142, 143, 144, 145, 146, 147, 148, 149, 150]
          end
        end
      end

      context 'when there are 8 pages in total' do
        before(:each) do
          allow(pagination_helper).to receive(:total_pages) { 8 }
        end

        it 'current page is 6' do
          allow(pagination_helper).to receive(:current_page) { 6 }

          expect(pagination_helper.send(:page_range)).to eq [1, 2, 3, 4, 5, 6, 7, 8]
        end

        it 'current page is 1' do
          allow(pagination_helper).to receive(:current_page) { 1 }

          expect(pagination_helper.send(:page_range)).to eq [1, 2, 3, 4, 5, 6, 7, 8]
        end

        it 'current page is 8' do
          allow(pagination_helper).to receive(:current_page) { 8 }

          expect(pagination_helper.send(:page_range)).to eq [1, 2, 3, 4, 5, 6, 7, 8]
        end
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