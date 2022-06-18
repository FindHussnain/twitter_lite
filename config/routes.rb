Rails.application.routes.draw do
  root 'tweets#index'
  get 'tags/:tag', to: 'tweets#index', as: :tag
  resources :tweets do
    resources :comments, except: [:new, :index]
    member do
      put 'like' => 'tweets#like'
    end
  end
  get 'signup', to: 'users#new'
  resources :users, except: [:new] do
    member do
      post :follow
      post :unfollow
    end
  end
  get 'users/:id/:tag', to: 'users#index', as: :followers
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  get 'logout', to: 'sessions#destroy'
end
