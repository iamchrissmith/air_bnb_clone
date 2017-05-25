module PropertyAttributeHelper

  def property_attributes(properties)
    properties.map do |property|
      property.prepare_address
    end
  end
end
