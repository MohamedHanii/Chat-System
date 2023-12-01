Rails.application.routes.draw do

  get 'applications', to: 'applications#index'
  get 'applications/:token', to: 'applications#show'
  post 'applications', to: 'applications#create'
  put 'applications/:token', to: 'applications#update'
  delete 'applications/:token', to: 'applications#destroy'
end
