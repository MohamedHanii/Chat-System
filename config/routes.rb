Rails.application.routes.draw do

  get 'applications', to: 'applications#index'
  get 'applications/:token', to: 'applications#show'
  post 'applications', to: 'applications#create'
  put 'applications/:token', to: 'applications#update'
  delete 'applications/:token', to: 'applications#destroy'


  get 'applications/:token/chats', to: 'chats#index'
  get 'applications/:token/chats/:chatNumber', to: 'chats#show'
  post 'applications/:token/chats', to: 'chats#create'
  put 'applications/:token/chats/:chatNumber', to: 'chats#update'
  delete 'applications/:token/chats/:chatNumber', to: 'chats#destroy'
end
