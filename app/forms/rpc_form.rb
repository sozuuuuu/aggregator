class RpcForm
  include ActiveModel::Model
  include ActiveModel::Validations::Callbacks

  attr_accessor :jsonrpc, :method, :id, :params

  after_validation :convert_params_to_object

  validates :jsonrpc, presence: true
  validates :method, presence: true
  validates :id, presence: true
  validates :params, presence: true

  def convert_params_to_object
    @params = JSON.parse(@params.to_json, object_class: OpenStruct)
  end
end
