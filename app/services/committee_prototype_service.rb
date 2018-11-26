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

  def self.committee(_)
    return {}.to_ostruct
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

      small = generate_card_small_text(committee.try(:house)) if include_house
      paragraph = generate_card_paragraph_text(committee) if include_date

      CardFactory.new(
          small: small,
          heading_text: committee.name,
          heading_url:  Rails.application.routes.url_helpers.committee_prototype_path(committee.id),
          paragraph_content: paragraph
      ).build_card
    end
  end

  private
  def self.generate_card_small_text(house)
    return nil if house.nil?

    type = if house.isCommons && house.isLords
             'both'
           elsif house.isCommons
             'commons'
           elsif house.isLords
             'lords'
           end

    I18n.t("committee_prototype.card.small.#{type}") if type
  end

  def self.generate_card_paragraph_text(committee)
    begin
      current = (committee.try(:startDate).present? && committee.try(:endDate).nil?)
      complete_data = (committee.try(:startDate).present? && committee.try(:endDate).present?)

      start_date = DateTime.parse(committee.startDate) if committee.try(:startDate).present?
      end_date = DateTime.parse(committee.endDate) if committee.try(:endDate).present?

      paragraph = []
      paragraph << I18n.t('prepositional_to', first: I18n.l(start_date), second: I18n.t('present')) if current
      paragraph << I18n.t('prepositional_to', first: I18n.l(start_date), second: I18n.l(end_date))  if !current && complete_data
    rescue I18n::ArgumentError => e
      logger.warn 'Attempted to localise non-date object'
      logger.warn e
    rescue ArgumentError => e
      logger.warn 'Possible data issue: Attempted to parse non-date string value'
      logger.warn e
    end

    paragraph
  end
end
