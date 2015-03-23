 Rails.application.routes.draw do

  # get 'feedback_targets/index'
  #
  # get 'feedback_targets/create'
  #
  # get 'feedback_targets/update'
  #
  # get 'feedback_targets/destroy'

  devise_for :expresso_user, :registered_user, :ldap_users, skip: [ :sessions ]

  devise_scope :expresso_user do
    root to: "sessions#new", :as => 'expresso_user_root'
    get 'sign_in' => 'sessions#new', :as => :new_session_expresso_user
    match '/auth/:provider/callback', to: 'sessions#create', via: [:get, :post]
    get '/auth/failure', to: 'sessions#omniauth_failure'
    get 'sign_out' => 'sessions#destroy'
  end


  devise_scope :ldap_user do
    root to: "sessions#new"
    delete 'sign_out' => 'sessions#destroy'
   end


  devise_scope :registered_user do
    root to: "sessions#new", :as => 'registered_user_root'
    get 'sign_in' => 'sessions#new', :as => :new_session
    post 'sign_in' => 'sessions#create', :as => :create_session
    delete 'sign_out' => 'sessions#destroy', :as => :destroy_session
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  get 'dashboard' => "dashboard#index"

  get 'widget/:token' => 'feedback_forms#code'


  get 'protected' => 'protected#index'

  get 'proxy' => 'proxy#index'

  resources  :feedback_targets do
    member do
     get 'search_for_members' => 'feedback_targets#search_for_members', as: 'members_for'
     post 'add_members' => 'feedback_targets#add_members', as: 'add_members_for'
     delete 'remove_member' => 'feedback_targets#remove_member', as: 'remove_member_for'
    end
    resources :feedbacks do

    end
    resources :feedback_forms do
      member do
        delete 'destroy_attribute' => 'feedback_forms#destroy_attribute'
        get 'new_attribute' => 'feedback_forms#new_attribute'
      end
      resources :feedbacks do
        member do
          delete 'destroy_comment' => 'feedbacks#destroy_comment'
          post 'add_comment' => 'feedbacks#add_comment'
          post 'archive' => 'feedbacks#archive'
          post 'unarchive' => 'feedbacks#unarchive'
          get 'comments' => 'feedbacks#comments'
          patch 'fire_event'=> 'feedbacks#fire_event'
        end
      end
    end
  end

  get '/users/autocomplete', to: 'users#autocomplete', as: 'autocomplete_user'

  get '/user_applications', to: redirect('/feedback_targets')
  get '/user_applications/:feedback_target_id', to: redirect  { |path_params, req| "/feedback_targets/#{path_params[:feedback_target_id]}" }
  #match '/user_applications' => 'feedback_targets#index',  :via => :get

  mount FeedbackServerAPI => '/api/'

  # You can have the root of your site routed with "root"


  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
