class CommitteePrototype::BusinessController < ApplicationController
  def index
    business = CommitteePrototypeService.all_business(params[:committee_id])
    committee = CommitteePrototypeService.committee_only(params[:committee_id])

    list_components = CommitteePrototypeService.business_cards(business, committee)

    heading = ComponentSerializer::Heading1ComponentSerializer.new(subheading: committee.try(:name), subheading_link: committee_prototype_path(committee_id: params[:committee_id]), heading: I18n.t('committee_prototype.business.index.title'))

    serializer = PageSerializer::ListPageSerializer.new(request: request, heading_component: heading, list_components: list_components)

    render_page(serializer)
  end

  def show
    business = CommitteePrototypeService.business(params[:business_id])
    committee = CommitteePrototypeService.committee_only(params[:committee_id])

    serializer = PageSerializer::CommitteePrototype::BusinessShowPageSerializer.new(request: request, business: business, committee: committee)

    render_page(serializer)
  end

  def current
    business = CommitteePrototypeService.all_business(params[:committee_id])
    committee = CommitteePrototypeService.committee_only(params[:committee_id])

    list_components = CommitteePrototypeService.business_cards(business, committee)

    heading = ComponentSerializer::Heading1ComponentSerializer.new(subheading: committee.try(:name), subheading_link: committee_prototype_path(committee_id: params[:committee_id]), heading: I18n.t('committee_prototype.business.current.title'))

    serializer = PageSerializer::ListPageSerializer.new(request: request,  heading_component: heading, list_components: list_components)

    render_page(serializer)
  end

  def former
    business = CommitteePrototypeService.all_business(params[:committee_id])
    committee = CommitteePrototypeService.committee_only(params[:committee_id])

    list_components = CommitteePrototypeService.business_cards(business, committee)

    heading = ComponentSerializer::Heading1ComponentSerializer.new(subheading: committee.try(:name), subheading_link: committee_prototype_path(committee_id: params[:committee_id]), heading: I18n.t('committee_prototype.business.former.title'))

    serializer = PageSerializer::ListPageSerializer.new(request: request, heading_component: heading, list_components: list_components)

    render_page(serializer)
  end
end
