class CommitteePrototypeController < ApplicationController
  def index
    committees = CommitteePrototypeService.all_committees

    list_components = CommitteePrototypeService.committee_cards(committees, include_date: true)

    heading = ComponentSerializer::Heading1ComponentSerializer.new(heading: I18n.t('committee_prototype.index.title'))

    serializer = PageSerializer::ListPageSerializer.new(request: request, heading_component: heading, list_components: list_components)

    render_page(serializer)
  end

  def show
    committee, business, memberships, parent, children = CommitteePrototypeService.committee(params[:committee_id])
    images = CommitteePrototypeService.all_images

    serializer = PageSerializer::CommitteePrototypeShowPageSerializer.new(request: request, committee: committee, business: business, memberships: memberships, parent: parent, children: children, images: images)

    render_page(serializer)
  end

  def current
    committees = CommitteePrototypeService.current_committees

    list_components = CommitteePrototypeService.committee_cards(committees)

    heading = ComponentSerializer::Heading1ComponentSerializer.new(subheading: I18n.t('committee_prototype.index.title'), subheading_link: committees_prototype_path, heading: I18n.t('committee_prototype.current.title'))

    serializer = PageSerializer::ListPageSerializer.new(request: request, heading_component: heading, list_components: list_components)

    render_page(serializer)
  end
end
