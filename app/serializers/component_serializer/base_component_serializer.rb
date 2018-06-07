module ComponentSerializer
  # The serializer which all component serializers inherit from.
  class BaseComponentSerializer < BaseSerializer
    def content
      {
        name: name,
        data: data
      }
    end

    private

    def name
      raise 'You must implement #name'
    end

    def data
      raise 'You must implement #data'
    end
  end
end
