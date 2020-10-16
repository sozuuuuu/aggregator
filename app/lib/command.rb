class Command
  METHOD_COMMAND_MAP = {
    'aggregate' => AggregateCommand
  }.freeze

  class UnsupportedMethodError < StandardError; end

  def self.lookup(form)
    klass = METHOD_COMMAND_MAP[form.method]
    raise UnsupportedMethodError unless klass

    klass.new(form.params)
  end
end
