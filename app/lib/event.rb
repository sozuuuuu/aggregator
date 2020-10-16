class Event
  attr_reader :data, :metadata, :event_id, :event_type

  def initialize(data)
    @data = data
    @metadata = OpenStruct.new
    @event_id = ULID.generate
    @event_type = self.class.to_s.split('::').last
  end
end
