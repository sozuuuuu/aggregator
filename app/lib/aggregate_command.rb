class AggregateCommand
  attr_reader :uri

  def initialize(params)
    @uri = params.uri
  end
end
