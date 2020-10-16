Rails.application.routes.draw do
  post 'rpc', to: 'rpc#handle'
end
