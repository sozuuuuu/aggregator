require 'net/http'
require 'csv'

class AggregateCommandHandler
  def call(command)
    CsvAggregateJob.perform_later(command.uri)
  end
end
