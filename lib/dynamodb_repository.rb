class DynamoDbRepository
  TABLE_NAME = ENV['DYNAMO_DB_TABLE_NAME']

  def read(specification)
    params = {
      table_name: TABLE_NAME,
      key_condition_expression: 'pk = :pk and begins_with(sk, :sk)',
      expression_attribute_values: {
        ':pk': pk(specification.stream),
        ':sk': SK_PREFIX
      }
    }

    client
      .query(params)
      .items
  end

  def append_to_stream(events, stream, _expected_version)
    # TODO: How does it handle the expected_version?

    items = Array(events).map do |ev|
      ev.to_h.merge({
                      pk: pk(stream.name),
                      sk: sk(ev)
                    })
    end

    requests = make_put_requests(items)

    params = {
      request_items: {
        TABLE_NAME => requests
      }
    }

    client.batch_write_item(params)
  end

  private

  PK_PREFIX = "RES$"
  SK_PREFIX = 'RES$'

  def pk(stream_name)
    "#{PK_PREFIX}#{stream_name}"
  end

  def sk(event)
    "#{SK_PREFIX}Event$#{event.event_type}$#{event.event_id}"
  end

  def counter_sk
    "#{SK_PREFIX}Counter"
  end

  def client
    @client ||= Aws::DynamoDB::Client.new(options)
  end

  def options
    opt = {
    }
    opt[:endpoint] = ENV['DYNAMO_DB_ENDPOINT'] if ENV['DYNAMO_DB_ENDPOINT']
    opt
  end

  def make_put_requests(items)
    items.map do |i|
      {
        put_request: {
          item: i
        }
      }
    end
  end
end
