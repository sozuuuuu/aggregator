class CreateTransactionCommand
  attr_reader :params

  def initialize(params)
    @params = params.slice(:amount, :description, :date)
  end
end
