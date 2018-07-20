module PageSerializer
  class BasePageSerializer < BaseSerializer
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
        h[:meta] = meta
        h[:pugin_version] = '1.10.1'
        h[:open_search] = opensearch_description_url
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

    def meta
      raise 'You must implement #meta'
    end
  end
end
