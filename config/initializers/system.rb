# require 'arkency/command_bus'
# require 'aggregate_root'
require './lib/dynamodb_repository'

Dry::Rails.container do
  event_store = RailsEventStore::Client.new(
    repository: DynamoDbRepository.new
  )
  register(:event_store, event_store)
  #
  # command_bus = Arkency::CommandBus.new
  # register(:command_bus, command_bus)
  #
  # AggregateRoot.configure do |config|
  #   config.default_event_store = event_store
  # end
  #
  # repository = AggregateRoot::Repository.new
  # register(:repository, repository)

  command_bus = lambda do |command|
    case command
    when AggregateCommand
      AggregateCommandHandler.new.call(command)
    when CreateTransactionCommand
      CreateTransactionCommandHandler.new.call(command)
    else
      UnHandledCommandError.new("Unhandled command: #{command.class}")
    end
  end

  register(:command_bus, command_bus)
end
