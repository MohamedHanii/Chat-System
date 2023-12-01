Rails.application.routes.draw do

  get 'applications', to: 'applications#index'
  get 'applications/:token', to: 'applications#show'
  post 'applications', to: 'applications#create'
  put 'applications/:token', to: 'applications#update'
  delete 'applications/:token', to: 'applications#destroy'


  get 'applications/:token/chats', to: 'chat#index'
  get 'applications/:token/chats/:chatNumber', to: 'chat#show'
  post 'applications/:token/chats', to: 'chat#create'
  put 'applications/:token/chats/:chatNumber', to: 'chat#update'
  delete 'applications/:token/chats/:chatNumber', to: 'chat#destroy'
end
