# The serializer which all serializers inherit from.
class BaseSerializer
  # Creates a hash of the serializer's content
  def to_h
    dasherize_keys(content)
  end

  # Formats the serializer's content as yaml. Used for testing.
  def to_yaml
    to_h.to_yaml
  end

  # Creates a hash that is used for css classes in the front-end
  def display_data(component: nil, variant: nil)
    {}.tap do |hash|
      hash[:component] = component if component
      hash[:variant] = variant if variant
    end
  end

  # Evaluates a translation block
  def t(*args)
    I18n.t(*args)
  end

  # Creates links for use in translation blocks
  def link_to(body, url, html_options = {})
    ActionController::Base.helpers.link_to(body, url, html_options).html_safe
  end

  # Abstract method that is implemented in each specific serializer
  def content
    raise 'You must implement #content'
  end

  # Recursively transforms all keys in a hash from snake-cased symbols to hyphenated strings
  def dasherize_keys(hash)
    hash.deep_transform_keys do |key|
      key.to_s.dasherize
    end
  end
end
