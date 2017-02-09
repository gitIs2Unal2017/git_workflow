Rails.application.routes.draw do
  root to: 'pages#index'

  resources :images, only: [:show,:index]
  resources :comments, only: [:show,:index] do
    resources :images, except: [:show,:edit,:update]
  end
  resources :posts, only: [:show,:index] do
    resources :images, except: [:show,:edit,:update]
  end
  resources :users do
    resources :comments, except: [:show,:create]
    resources :posts, except: [:show] do
      resources :comments, only: [:new,:create]
    end
  end
end
