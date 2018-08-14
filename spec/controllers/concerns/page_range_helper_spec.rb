require_relative '../../rails_helper'

RSpec.describe PageRangeHelper, type: :helper do
  let(:pagination_helper) { double('pagination_helper') }
  let(:page_range_helper) { described_class.new(pagination_helper) }

  context '#page_range' do
    context 'the 5 possible cases for deciding where in the array the current page lies' do
      context '1. there are 8 or less pages in total, for example: 6' do
        context 'the position of the current page in the array is one less than itself due to zero-index' do
          before(:each) do
            allow(pagination_helper).to receive(:total_pages) { 6 }
          end

          it 'when the current page is 6, the array is [1, 2, 3, 4, 5, 6]' do
            allow(pagination_helper).to receive(:previous_page) { 5 }
            allow(pagination_helper).to receive(:current_page) { 6 }

            expect(page_range_helper.page_range).to eq [1, 2, 3, 4, 5, 6]
          end

          it 'when the current page is 1, the array is [1, 2, 3, 4, 5, 6]' do
            allow(pagination_helper).to receive(:previous_page) { 0 }
            allow(pagination_helper).to receive(:current_page) { 1 }

            expect(page_range_helper.page_range).to eq [1, 2, 3, 4, 5, 6]
          end

          it 'when the current page is 3, the array is [1, 2, 3, 4, 5, 6]' do
            allow(pagination_helper).to receive(:previous_page) { 2 }
            allow(pagination_helper).to receive(:current_page) { 3 }

            expect(page_range_helper.page_range).to eq [1, 2, 3, 4, 5, 6]
          end
        end
      end

      context 'there are 100 pages in total' do
        before(:each) do
          allow(pagination_helper).to receive(:total_pages) { 100 }
        end

        context '2. the current page is at most 4 pages from the FIRST page' do
          context 'the position of the current page in the array is one less than itself due to zero-index' do
            it 'when the current page is 2, the array is [1, 2, 3, 4, 5, 6, 7, 8]' do
              allow(pagination_helper).to receive(:previous_page) { 1 }
              allow(pagination_helper).to receive(:current_page) { 2 }

              expect(page_range_helper.page_range).to eq [1, 2, 3, 4, 5, 6, 7, 8]
            end

            it 'when the current page is 4, the array is [1, 2, 3, 4, 5, 6, 7, 8]' do
              allow(pagination_helper).to receive(:previous_page) { 3 }
              allow(pagination_helper).to receive(:current_page) { 4 }

              expect(page_range_helper.page_range).to eq [1, 2, 3, 4, 5, 6, 7, 8]
            end
          end
        end

        context '3. the current page is at most 4 pages from the LAST page' do
          context 'the position of the current page in the array is the difference between the total pages and the current page subtracted from 7' do
            it 'when the current page is 97, the array is [93, 94, 95, 96, 97, 98, 99, 100]' do
              allow(pagination_helper).to receive(:previous_page) { 96 }
              allow(pagination_helper).to receive(:current_page) { 97 }

              expect(page_range_helper.page_range).to eq [93, 94, 95, 96, 97, 98, 99, 100]
            end

            it 'when the current page is 99, the array is [93, 94, 95, 96, 97, 98, 99, 100]' do
              allow(pagination_helper).to receive(:previous_page) { 98 }
              allow(pagination_helper).to receive(:current_page) { 99 }

              expect(page_range_helper.page_range).to eq [93, 94, 95, 96, 97, 98, 99, 100]
            end
          end
        end

        context '4. the current page is somewhere in the middle' do
          context 'the position of the current page in the array is 4, zero-indexed' do
            it 'when the current page is 51, the array is [47, 48, 49, 50, 51, 52, 53, 54]' do
              allow(pagination_helper).to receive(:previous_page) { 50 }
              allow(pagination_helper).to receive(:current_page) { 51 }

              expect(page_range_helper.page_range).to eq [47, 48, 49, 50, 51, 52, 53, 54]
            end
          end
        end

        context '5. when the current page is greater than the total number of pages' do
          context 'the position of the current page in the array is 7' do
            it 'when the current page is 150, the array is [143, 144, 145, 146, 147, 148, 149, 150]' do
              allow(pagination_helper).to receive(:previous_page) { 149 }
              allow(pagination_helper).to receive(:current_page) { 150 }

              expect(page_range_helper.page_range).to eq [143, 144, 145, 146, 147, 148, 149, 150]
            end
          end
        end
      end
    end
  end
end