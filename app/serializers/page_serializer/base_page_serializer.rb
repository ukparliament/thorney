module PageSerializer
  class BasePageSerializer < BaseSerializer
    include OpenGraphHelper
    attr_reader :request, :request_id, :data_alternates, :request_original_url
    include ActionDispatch::Routing::UrlFor

    # @param [ActionDispatch::Request] request the current request object.
    # @param [Array<Hash>] data_alternates array containing the href and type of the alternative data urls.
    def initialize(request: nil, data_alternates: nil)
      @request              = request
      @request_id           = request.try(:env)&.fetch('ApplicationInsights.request.id', nil) if request
      @data_alternates      = data_alternates
      @request_original_url = generate_original_url
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
        h[:header_components] = PartialSerializer::HeaderComponentsPartialSerializer.new(include_global_search: include_global_search).to_h
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

    def meta(title: nil, image_id: nil)
      {}.tap do |meta|
        meta[:title]           = title
        meta[:request_id]      = request_id if request_id
        meta[:data_alternates] = data_alternates if data_alternates

        meta[:open_graph]      = OpenGraphHelper.information(page_title: title, request_original_url: request_original_url, image_id: image_id)

        meta[:opensearch_description_url] = url_for(host: request.try(:host), protocol: 'https', port: nil, controller: 'search', action: 'opensearch') if request.try(:host)
      end
    end

    def generate_original_url
      begin
        uri_object = URI.parse(request.try(:original_url))
      rescue URI::InvalidURIError
        return nil
      end

      uri_object.port = nil
      uri_object.scheme = 'https'

      uri_object.to_s
    end

    # Sets the default for including global search in the header to true.
    def include_global_search
      true
    end
  end
end
