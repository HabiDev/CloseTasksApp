class Event
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :mission_id, :number, :limit_at

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

end