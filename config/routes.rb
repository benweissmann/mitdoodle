Mitdoodle::Application.routes.draw do
  resources :polls do
    member do
      post :vote
      post :open
      post :close
    end
  end

  delete 'polls/:id/voters/:voter_id' => 'polls#delete_voter',
         :as => 'delete_voter',
         :via => 'delete'

  get 'static/:page' => 'static#show', :as => 'static'

  root :to => 'dashboard#index'
end
