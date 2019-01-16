module ContentDataHelper
  # Helper method to create hash for any part of a component or partial which needs a content and data hash to send through a translation key with multiple data items.
  # The data hash contains key/value pairs where the key is also the key inside curly braces in the string to be interpolated. The values are the data from the database which will be inserted into the string.
  # @param [String] content is the translation key to be added as the content value
  # @param [Array<Hash>] data takes an unlimited number of arguments which must be in the form of key vaule pairs
  # @return [Array<Hash>] { content: 'translation.key', data: { key: 'value', key2: 'value2'} }
  # @example creating a content data hash
  #   ContentDataHelper.content_data(content: content, key: 'value', key2: 'value2')
  def self.content_data(content: nil, **data)
    {}.tap do |hash|
      hash[:content] = content
      hash[:data] = data if data != {}
    end
  end
end
