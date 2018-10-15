module SortHelper
  # Sort an Array of Objects
  #
  # @param [Array<Object>] :collection the 'list' which we are sorting.
  # @param [Array<Symbol>] :attributes an array of parameters we are sorting by, for example :date or :name.
  # @param [Boolean] :prepend_rejected (true) should objects that do not respond to our parameters be prepended.
  #
  # @return [Array<Object>] a sorted array of objects using the args passed in.
  def self.sort_by(collection: nil, attributes: nil, prepend_rejected: false)
    options = {}.tap do |hash|
      hash[:list] = collection if collection
      hash[:parameters] = attributes if attributes
      hash[:prepend_rejected] = prepend_rejected
    end

    Parliament::NTriple::Utils.sort_by(options)
  end

  # Sort an Array of Objects in reverse
  #
  # @param [Array<Object>] :collection the 'list' which we are sorting.
  # @param [Array<Symbol>] :attributes an array of parameters we are sorting by, for example :date or :name.
  # @param [Boolean] :prepend_rejected (true) should objects that do not respond to our parameters be prepended.
  #
  # @return [Array<Object>] a sorted array of objects using the args passed in.
  def self.sort_by_reverse(collection: nil, attributes: nil, prepend_rejected: false)
    sort_by(
      collection:       collection,
      attributes:       attributes,
      prepend_rejected: prepend_rejected
    ).reverse
  end
end
