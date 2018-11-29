class LaidThingListComponentsFactory
  class << self
    include Rails.application.routes.url_helpers
    include ListDescriptionHelper

    # Groups, sorts and builds list components for statutory_instruments
    #
    # @param [Array] statutory_instruments list of statutory_instruments
    # @param [Symbol] type of laid thing. To be refactored.
    # @param [Boolean] small is a boolean to indicate if a small will be included on the cards in the list
    #
    # @return [Array] array of Card components populated with the statutory_instrument data
    def sort_and_build_components(statutory_instruments: nil, small: false)
      grouping_block = proc { |statutory_instrument| LayingDateHelper.get_date(statutory_instrument) }

      sorted_statutory_instruments = GroupSortHelper.group_and_sort(statutory_instruments, group_block: grouping_block, key_sort_descending: true, sort_method_symbols: %i[laidThingName])

      build_components(statutory_instruments: sorted_statutory_instruments, small: small)
    end

    def build_components(statutory_instruments: nil, small: false)
      statutory_instruments.map do |statutory_instrument|
        laying_type = small ? laying_type(statutory_instrument) : nil

        CardFactory.new(
          small:                    laying_type,
          heading_text:             heading_text(statutory_instrument),
          heading_url:              heading_url(statutory_instrument),
          description_list_content: description_list_content(statutory_instrument)
        ).build_card
      end
    end

    private

    def heading_text(statutory_instrument)
      statutory_instrument.try(:laidThingName)
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
        hash[:description] = [
          TimeHelper.time_translation(date_first: LayingDateHelper.get_date(statutory_instrument))
        ]
      end
    end

    def description_list_content(statutory_instrument)
      [].tap do |items|
        items << date_description_item(statutory_instrument) if statutory_instrument&.laying&.date
        items << create_description_list_item(term: 'laid-thing.laying-body', descriptions: [statutory_instrument.laying.body.try(:groupName)]) if statutory_instrument.try(:laying).try(:body)
        items << create_description_list_item(term: 'laid-thing.procedure', descriptions: [statutory_instrument.work_package.procedure.try(:procedureName)]) if statutory_instrument.try(:work_package).try(:procedure)
      end
    end

    def laying_type(statutory_instrument)
      if statutory_instrument.is_a?(Parliament::Grom::Decorator::StatutoryInstrumentPaper)
        'statutory-instruments.type'
      elsif statutory_instrument.is_a?(Parliament::Grom::Decorator::ProposedNegativeStatutoryInstrumentPaper)
        'proposed-negative-statutory-instruments.type'
      end
    end
  end
end
