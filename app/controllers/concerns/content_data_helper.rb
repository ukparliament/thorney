module ContentDataHelper
  # Helper method to create hash for any part of a component or partial which needs a content and data hash to send through a translation key with multiple data items.
  # The content value is the translation key.
  # The data hash contains key/value pairs where the key is also the key inside curly braces in the string to be interpolated. The values are the data from the database which will be inserted into the string.
  # Should this be called the data interpolation helper??
  def self.content_data(content: nil, **data)

    {}.tap do |hash|
      hash[:content] = content if content
      hash[:data] = data if data != {}
    end
  end
end
