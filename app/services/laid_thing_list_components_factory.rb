class LaidThingListComponentsFactory
  class << self
    include Rails.application.routes.url_helpers
    include ListDescriptionHelper

    def build_components(statutory_instruments: nil, type: nil)
      statutory_instruments.map do |statutory_instrument|
        CardFactory.new(
          heading_text:             heading_text(statutory_instrument, type),
          heading_url:              heading_url(statutory_instrument),
          description_list_content: description_list_content(statutory_instrument)
        ).build_card
      end
    end

    private

    def heading_text(statutory_instrument, type)
      if type == :statutory_instrument
        statutory_instrument.try(:statutoryInstrumentPaperName)
      elsif type == :proposed_negative_statutory_instrument
        statutory_instrument.try(:proposedNegativeStatutoryInstrumentPaperName)
      elsif type == :laid_thing
        statutory_instrument.try(:laidThingName)
      end
    end

    def heading_url(statutory_instrument)
      if statutory_instrument.is_a?(Parliament::Grom::Decorator::StatutoryInstrumentPaper)
        statutory_instrument_path(statutory_instrument.graph_id)
      elsif statutory_instrument.is_a?(Parliament::Grom::Decorator::ProposedNegativeStatutoryInstrumentPaper)
        proposed_negative_statutory_instrument_path(statutory_instrument.graph_id)
      end
    end

    def date_description_item(statutory_instrument)
      {}.tap do |item|
        term_hash(item)
        description_hash(item, statutory_instrument)
      end
    end

    def term_hash(item)
      item.tap do |hash|
        hash[:term] = { content: 'laid-thing.laid-date' }
      end
    end

    def description_hash(item, statutory_instrument)
      item.tap do |hash|
        hash[:description] = [{
          content: 'shared.time-html',
          data:    {
            datetime_value: I18n.l(statutory_instrument&.laying&.date, format: :datetime_format),
            date:           I18n.l(statutory_instrument&.laying&.date)
          }
        }]
      end
    end

    def description_list_content(statutory_instrument)
      [].tap do |items|
        items << date_description_item(statutory_instrument) if statutory_instrument
        items << create_description_list_item(term: 'laid-thing.laying-body', descriptions: [statutory_instrument&.laying&.body.try(:groupName)]) if statutory_instrument&.laying&.body
        items << create_description_list_item(term: 'laid-thing.procedure', descriptions: [statutory_instrument&.work_package&.procedure.try(:procedureName)]) if statutory_instrument&.work_package&.procedure
      end
    end
  end
end
