class CreateTransactionCommandHandler
  include Aggregator::Deps[:event_store]

  class TransactionCreated < Event; end

  def call(command)
    load_aggregate(SecureRandom.uuid) do |transaction|
      transaction.create(command.params)
      TransactionCreated.new(data: { transaction: transaction })
    end
  end

  private

  def load_aggregate(id)
    version = -1
    transaction = Transaction.new
    event_store.read.stream(stream_name(id)).each do |event|
      case event
      when TransactionCreated
        transaction.create(event.data)
      else
        logger.warn('???')
      end

      version += 1
    end
    events = yield transaction
    event_store.publish(events, stream_name: stream_name(id), expected_version: version)
  end

  def stream_name(id)
    "Stream$#{id}"
  end
end
