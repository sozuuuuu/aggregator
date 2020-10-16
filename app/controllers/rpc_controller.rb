class RpcController < ApplicationController
  def handle
    form = RpcForm.new(params.permit(:id, :jsonrpc, :method, params: {}))
    form.validate

    if form.errors.any?
      return render json: {
        jsonrpc: '2.0',
        id: form.id,
        error: form.errors
      }
    end

    command = Command.lookup(form)
    command_bus.(command)
    render json: '', status: :accepted
  end
end
