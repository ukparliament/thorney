module ListDescriptionHelper
  # Helper method to create hash for a ListDescriptionComponentSerializer item
  def create_description_list_item(term: nil, descriptions: nil)
    return if descriptions.all?(&:blank?)

    descriptions.map! { |description| description.is_a?(Hash) ? description : { content: description } }

    {}.tap do |hash|
      hash[:term] = { content: term } if term.is_a? String
      hash[:term] = term if term.is_a? Hash
      hash[:description] = descriptions
    end
  end
end
