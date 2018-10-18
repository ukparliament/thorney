module ListDescriptionHelper
  # Helper method to create hash for a ListDescriptionComponentSerializer item
  def create_description_list_item(term, descriptions)
    return if descriptions.all?(&:blank?)

    {}.tap do |hash|
      hash[:term] = { content: term }
      hash[:description] = descriptions.map { |description| { content: description } }
    end
  end
end
