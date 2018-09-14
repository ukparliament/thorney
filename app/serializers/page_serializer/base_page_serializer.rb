module PageSerializer
  class BasePageSerializer < BaseSerializer
    include OpenGraphHelper
    attr_reader :request_id, :data_alternates

    def initialize(request_id: nil, data_alternates: nil, request_original_url: nil)
      @request_id           = request_id if request_id
      @data_alternates      = data_alternates
      @request_original_url = request_original_url
    end

    # Creates a hash of the serializer's content
    def to_h
      dasherize_keys(hash)
    end

    private

    def hash
      {}.tap do |hash|
        head_section(hash)
        header_section(hash)
        main_section(hash)
        footer_section(hash)
      end
    end

    def main_components
      content
    end

    def head_section(hash)
      hash.tap do |h|
        h[:layout] = { template: 'layout' }
        h[:meta]   = meta
      end
    end

    def header_section(hash)
      hash.tap do |h|
        h[:header_components] = PartialSerializer::HeaderComponentsPartialSerializer.new.to_h
      end
    end

    def main_section(hash)
      hash.tap do |h|
        h[:main_components] = main_components
      end
    end

    def footer_section(hash)
      hash.tap do |h|
        h[:footer_components] = PartialSerializer::FooterComponentsPartialSerializer.new.to_h
      end
    end

    def opensearch_description_url
      raise 'You must implement #opensearch_description_url'
    end

    def meta(title: nil, image_id: nil)
      {}.tap do |meta|
        meta[:title]           = title
        meta[:request_id]      = @request_id if @request_id
        meta[:data_alternates] = @data_alternates
        meta[:open_graph]      = OpenGraphHelper.information(page_title: title, request_original_url: @request_original_url, image_id: image_id)
      end
    end
  end
end
