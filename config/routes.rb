require 'sidekiq/web'

Rails.application.routes.draw do
  root 'main#home'

  devise_for :users, controllers: {
    sessions: 'user/sessions',
    passwords: 'user/passwords',
    confirmations: 'user/confirmations',
    omniauth_callbacks: 'user/omniauth_callbacks'
  }, only: [:sessions, :passwords, :confirmations, :omniauth_callbacks]

  devise_for :admins, controllers: {
    sessions: 'admin/sessions',
    passwords: 'user/passwords',
  }, only: [:sessions, :passwords]

  devise_scope :user do
    get '/admin' => 'admin/sessions#new'
  end

  devise_for :doctors, controllers: {
    registrations: 'doctor/registrations'
  }, only: [:registrations]

  devise_for :patients, controllers: {
    registrations: 'patient/registrations'
  }, only: [:registrations]



  namespace :doctor, path: 'd' do
    resource :profile, path: 'me', only: [:show, :update]
  end

  namespace :patient, path: 'p' do
    resource :profile, path: 'me', only: [:show, :update]
  end

  namespace :admin do
    get '/:username/profile' => 'profiles#edit', as: :edit_profile
    patch '/:username/profile' => 'profiles#update', as: :profile
    get '/:username/password' => 'profiles#edit_password', as: :edit_password
    patch '/:username/password' => 'profiles#update_password', as: :update_password

    resources :patients, only: [:index, :edit, :update]
    resources :doctors, only: [:index, :show, :edit, :update] do
      member do
        patch :toggle_approved
      end
    end
    resources :admins, only: [:index, :edit, :update]
    resources :commissions, only: [:index]
    resources :pharmacies
    resources :refunds, only: [:index, :edit, :update]
  end

  namespace :api, path: nil, format: 'json' do
    namespace :v1 do
      resource :auth, only: '' do
        post :logout
        post :login
        post :register
        post :sign_up
        get :check
      end

      post '/devices' => 'devices#create'
      delete '/devices' => 'devices#destroy'

      resources :conferences, only: [:create, :update] do
        collection do
          post :token
          post :notify
        end
      end
      get '/conferences/can_start_call/:appointment_id' => 'conferences#can_start_call'
      post '/conferences/decline_call/:appointment_id' => 'conferences#decline_call'

      resources :doctors, only: [:index, :show] do
        member do
          get 'appointment_periods'
          get 'profile'
        end
      end

      resource :user, only: [:show] do
        member do
          get '/:id/profile' => 'users#profile'
          put 'avatar' => 'users#upload_avatar'
        end
      end
      resources :specialties, only: [:index]
      resources :notifications, only: [:index] do
        member do
          patch :mark_read
        end
      end

      resources :comments, only: [:index, :create]

      namespace :doctors, path: 'd' do
        resource :profile, only: [:show, :update]
        resources :appointment_settings, only: [:index, :update]

        resources :appointments, only: [:show] do
          member do
            put 'approve'
            put 'decline'
          end
          collection do
            get 'upcoming'
            get 'finished'
          end

          resources :prescriptions, only: [:index, :create, :destroy]
          resource :medical_certificate, only: [:show, :create, :destroy]
        end

        resources :appointment_products, only: [:index] do
          collection do
            get 'scheduled'
          end
        end

        resource :bank_account, only: [:create, :show, :destroy]
      end

      namespace :patients, path: 'p' do
        resource :profile, only: [:show, :update]
        resources :appointments, only: [:show, :create] do
          member do
            put 'pay'
            put 'transfer'
            put 'refund'
          end
          collection do
            get 'active'
            get 'finished'
          end

          resources :prescriptions, only: [:index] do
            collection do
              put 'deliver'
            end
          end
        end

        resources :pharmacies, only: [:index]

        resources :surveys, only: [:show, :update]

        resources :reasons, only: [:index]

        resources :checkouts, only: [:index, :create, :destroy] do
          put :set_default, on: :member
        end

      end
    end
  end

  mount Sidekiq::Web => '/_m_'

  get '/*any' => 'main#home'

end
