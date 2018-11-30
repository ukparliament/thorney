require 'ostruct'

# Lifted from https://github.com/citizen428/shenanigans under MIT license https://github.com/citizen428/shenanigans/blob/4e6e841f62ad7e7650bda431e69ca91fa15c39c0/LICENSE
class Hash
  def to_ostruct
    arr = map do |k, v|
      case v
      when Hash
        [k, v.to_ostruct]
      when Array
        [k, v.map { |el| el.respond_to?(:to_ostruct) ? el.to_ostruct : el }]
      else
        [k, v]
      end
    end
    OpenStruct.new(Hash[arr])
  end
end

class CommitteePrototypeService
  extend ListDescriptionHelper
  extend ActionView::Helpers::UrlHelper

  def self.all_committees
    request = committee_request.committees.get(params: {take: 1000})

    data = JSON.parse(request.response.body).to_ostruct

    return data.items
  end

  def self.current_committees
    committees = all_committees

    # Get only those with no end date
    committees.select! do |committee|
      committee.value.try(:endDate).nil?
    end

    return committees
  end

  def self.business(id)
    request = committee_request.committees.business(id).get(params: {take: 1000})

    data = JSON.parse(request.response.body).to_ostruct

    return data.value
  end

  def self.all_business(id)
    [current_business(id), former_business(id)].flatten
  end

  def self.current_business(id)
    request = committee_request.committees(id).business.current.get(params: {take: 1000})

    data = JSON.parse(request.response.body).to_ostruct

    return data.items
  end

  def self.former_business(id)
    request = committee_request.committees(id).business.former.get(params: {take: 1000})

    data = JSON.parse(request.response.body).to_ostruct

    return data.items
  end

  def self.committee_only(id)
    request = committee_request.committees(id).get

    data = JSON.parse(request.response.body).to_ostruct

    return data.value
  end

  def self.committee(id)
    c, business, memberships, staff = [committee_request.committees(id), committee_request.committees(id).business.current, committee_request.committees(id).membership.current, committee_request.committees(id).staff].map do |request|
      begin
        response = request.get
      rescue Parliament::ServerError
        Rails.logger.warn "Got a 5XX response from #{request.query_url}"
        next nil
      end

      JSON.parse(response.response.body).to_ostruct
    end

    c           = c.value
    business    = business.items
    memberships = memberships.items
    staff       = staff.items

    parent = nil
    children = []
    all_committees.each do |committee_to_check|
      next unless committee_to_check.try(:value)

      committee_to_check = committee_to_check.value
      if committee_to_check.try(:id) && c.try(:parentCommitteeId)
        parent = committee_to_check if committee_to_check.id == c.parentCommitteeId
      end

      if c.try(:id)
        children << committee_to_check if committee_to_check.try(:parentCommitteeId) == c.id
      end
    end

    [c, business, memberships, staff, parent, children]
  end

  def self.committee_request()
    Parliament::Request::UrlRequest.new(
        base_url: 'https://dm-qa-committeemanagementsystem-services.azurewebsites.net',
        builder: Parliament::Builder::BaseResponseBuilder
    )
  end

  def self.committee_cards(committees, include_house: true, include_date: false)
    committees.map do |committee|
      committee = committee.value

      small = generate_card_small_text(committee) if include_house
      paragraph = generate_committee_date_range(committee) if include_date
      description_list = generate_description_list(committee, committees)

      CardFactory.new(
          small: small,
          heading_text: committee.name,
          heading_url:  Rails.application.routes.url_helpers.committee_prototype_path(committee.id),
          paragraph_content: paragraph,
          description_list_content: description_list
      ).build_card
    end
  end

  def self.generate_committee_date_range(committee)
    begin
      current = (committee.try(:startDate).present? && committee.try(:endDate).nil?)
      complete_data = (committee.try(:startDate).present? && committee.try(:endDate).present?)

      start_date = DateTime.parse(committee.startDate) if committee.try(:startDate).present?
      end_date = DateTime.parse(committee.endDate) if committee.try(:endDate).present?

      range = []
      range << I18n.t('committee_prototype.prepositional_to', first: I18n.l(start_date), second: I18n.t('committee_prototype.present')) if current
      range << I18n.t('committee_prototype.prepositional_to', first: I18n.l(start_date), second: I18n.l(end_date)) if !current && complete_data
    rescue I18n::ArgumentError => e
      logger.warn 'Attempted to localise non-date object'
      logger.warn e
      range = nil
    rescue ArgumentError => e
      logger.warn 'Possible data issue: Attempted to parse non-date string value'
      logger.warn e
      range = nil
    end

    range
  end

  def self.all_images
    request = Parliament::Request::UrlRequest.new(
        base_url: 'https://api.parliament.uk/query/mnis_id_image_table.json',
        builder: Parliament::Builder::BaseResponseBuilder
    )
    response = request.get.response
    raw_data = JSON.parse(response.body)

    values = raw_data.dig('results', 'bindings') || []

    image_hash = {}
    values.each do |value|
      mnis_id = value.dig('mnisId', 'value')
      image_uri = value.dig('imageUri', 'value')
      next unless image_uri

      image_id = image_uri.split('/').last
      image_hash[mnis_id] = image_id if mnis_id && image_id
    end

    image_hash
  end

  def self.business_cards(business, committee)
    business.map do |business_item|
      business_item = business_item.value

      small = business_item.try(:committeeBusinessType).try(:name)

      CardFactory.new(
          small: small,
          heading_text: business_item.title,
          heading_url:  Rails.application.routes.url_helpers.committee_prototype_business_show_path(committee_id: committee.id, business_id: business_item.id),
          description_list_content: business_item_card_description_list(business_item)
      ).build_card
    end
  end

  private
  def self.generate_card_small_text(committee)
    return nil if committee.nil?

    type = if committee.try(:isCommons) && committee.try(:isLords)
             'both'
           elsif committee.try(:isCommons)
             'commons'
           elsif committee.try(:isLords)
             'lords'
           end

    I18n.t("committee_prototype.card.small.#{type}") if type
  end

  def self.generate_description_list(committee, committees)
    category          = committee.try(:category).try(:name)
    type_descriptions = generate_description_list_type_descriptions(committee)
    parent_link       = generate_description_list_parent_link(committee, committees)

    lead_house_commons = committee.try(:leadHouse).try(:isCommons)
    lead_house_lords   = committee.try(:leadHouse).try(:isLords)
    if lead_house_commons || lead_house_lords
      lead_house = if lead_house_commons
                     I18n.t('committee_prototype.card.small.commons')
                   elsif lead_house_lords
                     I18n.t('committee_prototype.card.small.lords')
                   end
    end

    [].tap do |items|
      items << create_description_list_item(term: I18n.t('committee_prototype.card.terms.category'), descriptions: [category]) if category.present?
      items << create_description_list_item(term: I18n.t('committee_prototype.card.terms.type'), descriptions: type_descriptions) if type_descriptions.present?
      items << create_description_list_item(term: I18n.t('committee_prototype.card.terms.parent'), descriptions: [parent_link]) if parent_link
      items << create_description_list_item(term: I18n.t('committee_prototype.card.terms.lead'), descriptions: [lead_house]) if lead_house
    end
  end

  def self.generate_description_list_type_descriptions(committee)
    return nil unless committee.try(:committeeTypes)

    committee.committeeTypes.map { |type| type.try(:name) }.compact
  end

  def self.generate_description_list_parent_link(committee, committees)
    return nil unless committee.try(:parentCommitteeId)

    parents = committees.select { |parent_committee| parent_committee.try(:value).try(:id) == committee.parentCommitteeId }

    if parents.try(:first)
      parent = parents.first.try(:value)
      parent_name = parent.try(:name)
      parent_name ||= I18n.t('no_name')
      parent_link = ActionController::Base.helpers.link_to(parent_name, Rails.application.routes.url_helpers.committee_prototype_path(parent.id)) if parent.try(:id)
    end

    parent_link
  end

  def self.business_item_card_description_list(business_item)
    [].tap do |items|
      items << create_description_list_item(term: I18n.t('committee_prototype.business.card.terms.open'), descriptions: [I18n.l(DateTime.parse(business_item.openDate))]) if business_item.try(:openDate)
      items << create_description_list_item(term: I18n.t('committee_prototype.business.card.terms.closed'), descriptions: [I18n.l(DateTime.parse(business_item.closedDate))]) if business_item.try(:closedDate)
      items << create_description_list_item(term: I18n.t('committee_prototype.business.card.terms.prefix'), descriptions: [business_item.prefix]) if business_item.try(:prefix)
    end
  end
end
