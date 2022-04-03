Rails.application.routes.draw do
  root 'articles#index'
  get 'tags/:tag', to: 'articles#index', as: :tag
  resources :articles do
    resources :comments, except: [:new, :index]
    member do
      put 'like' => 'articles#like'
    end
  end
  get 'signup', to: 'users#new'
  resources :users, except: [:new]
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  get 'logout', to: 'sessions#destroy'
end
