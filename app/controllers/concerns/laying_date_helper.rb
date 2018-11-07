module LayingDateHelper
  # Gets the earliest laying date for a work package.
  #
  # @param [Grom::Node] work_package Grom::Node of type WorkPackage
  #
  # @return [DateTime, nil] the earliest laying date connected to the work package or nil.
  def self.get_date(work_package)
    layings = work_package&.work_packaged_thing.try(:laidThingHasLaying)

    return nil if layings.nil?

    return layings.first.date if layings.length == 1

    # Remove any nil values and find the earliest date.
    layings.map(&:date).compact.min
  end
end
