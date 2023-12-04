require 'sidekiq/web'
Rails.application.routes.draw do

    
  scope 'api/v1' do
    resources :applications, param: :token do
      resources :chats, param: :chat_number do
        resources :messages, param: :message_number
        get 'search', to: 'messages#search', on: :member
      end
    end
  end
  

  mount Sidekiq::Web => "/sidekiq"

end