require_relative '../../rails_helper'

RSpec.describe TimeHelper, type: :helper do

  let(:first) { DateTime.parse('23/12/2016') }
  let(:second) { DateTime.parse('23/12/2017') }

  describe '#time_translation_object' do
    it 'creates a hash which can be passed to a paragraph serializer as content' do
      paragraph_time_translation_object_example = TimeHelper.time_translation(date_first: first, date_second: second)

      expect(paragraph_time_translation_object_example).to eq({ :content=>"shared.time-html-to", data: { :date=>"23 December 2016", :date_second=>"23 December 2017", :datetime_value=>"2016-12-23", :datetime_value_second=>"2017-12-23" } })
    end

    it 'creates a hash without an end date' do
      paragraph_time_translation_object_example = TimeHelper.time_translation(date_first: first)

      expect(paragraph_time_translation_object_example).to eq({ :content=>"shared.time-html", data: { :date=>"23 December 2016", :datetime_value=>"2016-12-23" } })
    end

    it 'creates a hash without to present' do
      paragraph_time_translation_object_example = TimeHelper.time_translation(date_first: first, to_present: true)

      expect(paragraph_time_translation_object_example).to eq({ :content=>"shared.time-html-to-present", data: { :date=>"23 December 2016", :datetime_value=>"2016-12-23" } })
    end
  end
end
