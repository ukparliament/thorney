class LaidThingListComponentsFactory
  include ListDescriptionHelper
  include Rails.application.routes.url_helpers

  def initialize(statutory_instruments: nil, type: nil)
    @statutory_instruments = statutory_instruments
    @type                  = type
  end

  def heading_text(statutory_instrument)
    if @type == :statutory_instrument
      statutory_instrument.try(:statutoryInstrumentPaperName)
    elsif @type == :proposed_negative_statutory_instrument
      statutory_instrument.try(:proposedNegativeStatutoryInstrumentPaperName)
    end
  end

  def heading_url(statutory_instrument)
    if @type == :statutory_instrument
      statutory_instrument_path(statutory_instrument.graph_id)
    elsif @type == :proposed_negative_statutory_instrument
      proposed_negative_statutory_instrument_path(statutory_instrument.graph_id)
    end
  end

  def date_description_item(statutory_instrument)
    { term:        {
      content: 'laid-thing.laid-date'
    },
      description: [{
                      content: 'shared.time-html',
                      data:    {
                        datetime_value: I18n.l(statutory_instrument&.laying&.date, format: :datetime_format),
                        date:           I18n.l(statutory_instrument&.laying&.date)
                      }
                    }]
    }
  end

  def build_components
    @statutory_instruments.map do |statutory_instrument|
      description_list_content = [].tap do |items|
        items << date_description_item(statutory_instrument) if statutory_instrument&.laying&.date
        items << create_description_list_item('laid-thing.laying-body', [statutory_instrument&.laying&.body.try(:groupName)]) if statutory_instrument&.laying&.body
        items << create_description_list_item('laid-thing.procedure', [statutory_instrument&.work_package&.procedure.try(:procedureName)]) if statutory_instrument&.work_package&.procedure
      end

      CardFactory.new(
        heading_text:             heading_text(statutory_instrument),
        heading_url:              heading_url(statutory_instrument),
        description_list_content: description_list_content
      ).build_card
    end
  end
end
