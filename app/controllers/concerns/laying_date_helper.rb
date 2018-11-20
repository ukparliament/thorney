module LayingDateHelper
  # Gets the earliest laying date for a thing connected to a laying.
  #
  # @param [Grom::Node] laying_connected_thing Grom::Node which has a connection to a laying
  #
  # @return [DateTime, nil] the earliest laying date connected to the laying_connected_thing or nil.
  def self.get_date(laying_connected_thing)
    layings = if laying_connected_thing.is_a?(Parliament::Grom::Decorator::WorkPackage)
                laying_connected_thing&.work_packaged_thing.try(:laidThingHasLaying)
              elsif laying_connected_thing.is_a?(Parliament::Grom::Decorator::LaidThing)
                laying_connected_thing.try(:laidThingHasLaying)
              end

    return nil if layings.nil?

    return layings.first.date if layings.length == 1

    # Remove any nil values and find the earliest date.
    layings.map(&:date).compact.min
  end
end
