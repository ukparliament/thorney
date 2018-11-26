class CommitteePrototypeController < ApplicationController
  def index
    committees = CommitteeApiService.all_committees

    list_components = committee_cards(committees)

    heading = ComponentSerializer::Heading1ComponentSerializer.new(heading: I18n.t('committee_prototype.index.title'))

    serializer = PageSerializer::ListPageSerializer.new(request: request, heading_component: heading, list_components: list_components)

    render_page(serializer)
  end

  def show
    committee = CommitteeApiSerice.committee(params[:committee_id])
  end

  def current
    committees = CommitteeApiService.current_committees

    list_components = committee_cards(committees)

    heading = ComponentSerializer::Heading1ComponentSerializer.new(subheading: I18n.t('committee_prototype.index.title'), subheading_link: committees_prototype_path, heading: I18n.t('committee_prototype.current.title'))

    serializer = PageSerializer::ListPageSerializer.new(request: request, heading_component: heading, list_components: list_components)

    render_page(serializer)
  end

  private
  def committee_cards(committees)
    committees.map do |committee|
      committee = committee.value

      CardFactory.new(
          heading_text: committee.name,
          heading_url:  committee_prototype_path(committee.id)
      ).build_card
    end
  end
end
