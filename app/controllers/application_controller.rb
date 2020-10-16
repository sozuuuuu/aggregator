class ApplicationController < ActionController::API
  include Aggregator::Deps[:command_bus]

  class UnHandledCommandError < StandardError; end
end
