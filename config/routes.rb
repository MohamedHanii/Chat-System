require 'sidekiq/web'

Rails.application.routes.draw do

  get 'applications', to: 'applications#index'
  get 'applications/:token', to: 'applications#show'
  post 'applications', to: 'applications#create'
  put 'applications/:token', to: 'applications#update'
  delete 'applications/:token', to: 'applications#destroy'


  get 'applications/:token/chats', to: 'chats#index'
  get 'applications/:token/chats/:chat_number', to: 'chats#show'
  post 'applications/:token/chats', to: 'chats#create'
  put 'applications/:token/chats/:chat_number', to: 'chats#update'
  delete 'applications/:token/chats/:chat_number', to: 'chats#destroy'


  get 'applications/:token/chats/:chat_number/messages', to: 'messages#index'
  get 'applications/:token/chats/:chat_number/messages/:message_number', to: 'messages#show'
  post 'applications/:token/chats/:chat_number/messages', to: 'messages#create'
  put 'applications/:token/chats/:chat_number/messages/:message_number', to: 'messages#update'
  delete 'applications/:token/chats/:chat_number/messages/:message_number', to: 'messages#destroy'


  mount Sidekiq::Web => "/sidekiq"

end
