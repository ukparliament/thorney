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

class CommitteeApiService
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
end