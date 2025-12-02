Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "users/registrations" }

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :todos do
    collection do
      get "daily/:date", to: "todos#daily", as: :daily

      # API route for daily report generation (JSON response)
      # GET /todos/report?date=YYYY-MM-DD
      get "report"
    end

    member do
      patch :toggle
    end
  end

  # Mypage route
  get "mypage", to: "mypage#show", as: :mypage

  post "mypage/preview_markdown", to: "mypage#preview_markdown", as: :preview_markdown
  post "mypage/reset_markdown", to: "mypage#reset_markdown", as: :reset_markdown

  # Mount LetterOpenerWeb only in development environment
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "todos#index"
end
