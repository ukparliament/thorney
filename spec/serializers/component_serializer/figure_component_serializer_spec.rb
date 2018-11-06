require_relative '../../rails_helper'

RSpec.describe ComponentSerializer::FigureComponentSerializer do
  context '#to_h' do
    it 'When given all data it returns a hash containing the name and data' do
      serializer = described_class.new(
        display_data: 'display data',
        link: 'linky.link.link.link.com',
        aria_hidden: true, tab_index: true,
        source_info: {
          source_media: '(min-width: 480px)',
          source_srcset: 'https://parliament.uk/photo and other things',
          source_srcset_2: 'https://yet-anotherphoto.com'
         },
        img: {
          alt_text: 'Here is a picture of Dianne Abbot',
          alt_data: 'Dianne Abbott',
          source: 'https://and-yet-another-photo.uk'
        },
        figcap: ContentDataHelper.content_data(content: 'image.image_of' , name: 'Dianne Abbott' )
      )

      expected = get_fixture('with_all')

      expect(serializer.to_yaml).to eq expected
    end

    it 'When not given display_data it returns a hash containing the name and data' do
      serializer = described_class.new(
        link: 'linky.link.link.link.com',
        aria_hidden: true, tab_index: true,
        source_info: {
          source_media: '(min-width: 480px)',
          source_srcset: 'https://parliament.uk/photo and other things',
          source_srcset_2: 'https://yet-anotherphoto.com'
        },
        img: {
          alt_text: 'Here is a picture of Dianne Abbot',
          alt_data: 'Dianne Abbott',
          source: 'https://and-yet-another-photo.uk'
        },
        figcap: ContentDataHelper.content_data(content: 'image.image_of' , name: 'Dianne Abbott' )
      )

      expected = get_fixture('no_display_data')

      expect(serializer.to_yaml).to eq expected
    end

    it 'When the aria is not hidden it returns a hash containing the name and data' do
      serializer = described_class.new(
        link: 'linky.link.link.link.com',
        tab_index: true,
        source_info: {
          source_media: '(min-width: 480px)',
          source_srcset: 'https://parliament.uk/photo and other things',
          source_srcset_2: 'https://yet-anotherphoto.com'
        },
        img: {
          alt_text: 'Here is a picture of Dianne Abbot',
          alt_data: 'Dianne Abbott',
          source: 'https://and-yet-another-photo.uk'
        },
        figcap: ContentDataHelper.content_data(content: 'image.image_of' , name: 'Dianne Abbott' )
      )

      expected = get_fixture('aria_not_hidden')

      expect(serializer.to_yaml).to eq expected
    end

    it 'When tab index is not included it returns a hash containing the name and data' do
      serializer = described_class.new(
        link: 'linky.link.link.link.com',
        source_info: { source_media: '(min-width: 480px)', source_srcset: 'https://parliament.uk/photo and other things', source_srcset_2: 'https://yet-anotherphoto.com' },
        img: { alt_text: 'Here is a picture of Dianne Abbot', alt_data: 'Dianne Abbott', source: 'https://and-yet-another-photo.uk' },
        figcap: ContentDataHelper.content_data(content: 'image.image_of' , name: 'Dianne Abbott' )
      )

      expected = get_fixture('not_tab_index')

      expect(serializer.to_yaml).to eq expected
    end

    it 'When figure caption is not included it returns a hash containing the name and data' do
      serializer = described_class.new(
        link: 'linky.link.link.link.com',
        source_info: { source_media: '(min-width: 480px)', source_srcset: 'https://parliament.uk/photo and other things', source_srcset_2: 'https://yet-anotherphoto.com' },
        img: { alt_text: 'Here is a picture of Dianne Abbot', alt_data: 'Dianne Abbott', source: 'https://and-yet-another-photo.uk' }
      )

      expected = get_fixture('no_figcap')

      expect(serializer.to_yaml).to eq expected
    end

    it 'When only one figure source is included it returns a hash containing the name and data' do
      serializer = described_class.new(
        link: 'linky.link.link.link.com',
        img: { alt_text: 'Here is a picture of Dianne Abbot', alt_data: 'Dianne Abbott', source: 'https://and-yet-another-photo.uk' }
      )

      expected = get_fixture('one_source')

      expect(serializer.to_yaml).to eq expected
    end

    it 'When no alt data is included it returns a hash containing the name and data' do
      serializer = described_class.new(
        link: 'linky.link.link.link.com',
        img: { alt_text: 'Here is a picture of Dianne Abbot', source: 'https://and-yet-another-photo.uk' }
      )

      expected = get_fixture('no_alt_data')

      expect(serializer.to_yaml).to eq expected
    end

  end
end
