class CsvAggregateJob < ApplicationJob
  def perform(uri)
    uri = URI(uri)
    raw = Net::HTTP.get(uri)
    csv = CSV.new(raw)
    csv.shift # remove header
    csv.each do |row|
      params = Hash[[:date, :amount, :currency, :description, :note, :receipt, :category, :base_currency, :ammount_in_base, :expsense].zip(row)]
      command = CreateTransactionCommand.new(params)
      command_bus.(command)
    end
  end

  def command_bus
    Aggregator::Container.resolve(:command_bus)
  end
end
