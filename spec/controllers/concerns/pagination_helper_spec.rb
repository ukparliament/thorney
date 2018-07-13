require_relative '../../rails_helper'

RSpec.describe PaginationHelper, type: :helper do
  include SerializerFixtureHelper

  let(:pagination_hash) { { start_index: 10, count: 123, results_total: 321, search_url: 'some_url', query: 'hello' } }
  let(:pagination_helper) { described_class.new(pagination_hash) }

  describe 'pagination helpers' do
    it '#current_page' do
      expect(pagination_helper.send(:current_page)).to eq 1
    end

    context 'page methods' do
      context 'when there are 100 pages in total' do
        before(:each) do
          allow(pagination_helper).to receive(:total_pages) { 100 }
        end

        context 'current page is 51' do
          before(:each) do
            allow(pagination_helper).to receive(:current_page) { 51 }
          end

          it 'first page is 46' do
            expect(pagination_helper.send(:first_page)).to eq 46
          end

          it 'last page is 55' do
            expect(pagination_helper.send(:last_page)).to eq 55
          end

          it 'active tile is 51' do
            expect(pagination_helper.send(:current_page)).to eq 51
          end
        end

        context 'current page is less than or equal to 6' do
          before(:each) do
            allow(pagination_helper).to receive(:current_page) { 2 }
          end

          it 'first page is 1' do
            expect(pagination_helper.send(:first_page)).to eq 1
          end

          it 'first page is 1 when current page is 4' do
            allow(pagination_helper).to receive(:current_page) { 4 }

            expect(pagination_helper.send(:first_page)).to eq 1
          end

          it 'last page is 10' do
            expect(pagination_helper.send(:last_page)).to eq 10
          end

          it 'last page is 10 when current page is 4' do
            allow(pagination_helper).to receive(:current_page) { 4 }

            expect(pagination_helper.send(:last_page)).to eq 10
          end

          it 'active tile is 2' do
            expect(pagination_helper.send(:current_page)).to eq 2
          end
        end

        context 'current page is more than or equal to 97' do
          before(:each) do
            allow(pagination_helper).to receive(:current_page) { 97 }
          end

          it 'first page is 91' do
            expect(pagination_helper.send(:first_page)).to eq 91
          end

          it 'first page is 91 when current page is 99' do
            allow(pagination_helper).to receive(:current_page) { 99 }

            expect(pagination_helper.send(:first_page)).to eq 91
          end

          it 'last page is 100' do
            expect(pagination_helper.send(:last_page)).to eq 100
          end

          it 'last page is 100 when current page is 97' do
            allow(pagination_helper).to receive(:current_page) { 97 }

            expect(pagination_helper.send(:last_page)).to eq 100
          end

          it 'active tile is 97' do
            expect(pagination_helper.send(:current_page)).to eq 97
          end
        end
      end

      context 'when there are less than or equal to 10 pages in total' do
        before(:each) do
          allow(pagination_helper).to receive(:total_pages) { 8 }
        end

        it 'first page is 1 when current page is 3' do
          allow(pagination_helper).to receive(:current_page) { 3 }

          expect(pagination_helper.send(:first_page)).to eq 1
        end

        it 'first page is 1 when current page is 7' do
          allow(pagination_helper).to receive(:current_page) { 7 }

          expect(pagination_helper.send(:first_page)).to eq 1
        end

        it 'last page is 8 when current page is 2' do
          allow(pagination_helper).to receive(:current_page) { 2 }

          expect(pagination_helper.send(:last_page)).to eq 8
        end
        it 'last page is 8 when current page is 3' do
          allow(pagination_helper).to receive(:current_page) { 7 }

          expect(pagination_helper.send(:last_page)).to eq 8
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