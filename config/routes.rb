Rails.application.routes.draw do
  root 'articles#index'
  get 'tags/:tag', to: 'articles#index', as: :tag
  resources :articles do
    resources :comments, except: [:new, :index]
  end
  get 'signup', to: 'users#new'
  resources :users, except: [:new] do
    member do
      post :follow
      post :unfollow
    end
  end
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  get 'logout', to: 'sessions#destroy'
end
