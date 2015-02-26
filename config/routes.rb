Rails.application.routes.draw do

  # get 'user_applications/index'
  #
  # get 'user_applications/create'
  #
  # get 'user_applications/update'
  #
  # get 'user_applications/destroy'

  devise_for :expresso_user, :registered_user, :ldap_users, skip: [ :sessions ]

  devise_scope :expresso_user do
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


  get 'protected' => 'protected#index'

  get 'proxy' => 'proxy#index'

  resources  :user_applications do
    member do
     get 'search_for_members' => 'user_applications#search_for_members', as: 'members_for'
     post 'add_members' => 'user_applications#add_members', as: 'add_members_for'
     delete 'remove_member' => 'user_applications#remove_member', as: 'remove_member_for'
    end
    resources :feedbacks do
      member do
        delete 'destroy_comment' => 'feedbacks#destroy_comment'
        post 'add_comment' => 'feedbacks#add_comment'
        post 'archive' => 'feedbacks#archive'
        post 'unarchive' => 'feedbacks#unarchive'
      end
    end
    resources :feedback_forms do
      resources :feedbacks
    end
  end

  get '/users/autocomplete', to: 'users#autocomplete', as: 'autocomplete_user'



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
