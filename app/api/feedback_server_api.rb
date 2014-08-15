#encoding: UTF-8
class FeedbackServerAPI < Grape::API
  #version 'v1', using: :header, vendor: 'serpro'
  version 'v1', using: :path, vendor: 'serpro'
  format :json

  rescue_from :all, :backtrace => true
  #error_formatter :json, Grape::API::ErrorFormatter

  before do
    error!("401 Unauthorized", 401) unless authenticated
  end

  helpers do

    # def warden
    #   env['warden']
    # end

    # def current_user_application
    #   @current_user_application ||= UserApplication.authorize!(env)
    # end
    #
    # def authenticate!
    #   error!('401 Unauthorized', 401) unless current_user_application
    # end
    def authenticated
      #return true if warden.authenticated?
      params[:access_token] && @user = UserApplication.where(authentication_token: params[:access_token]).first
    end

    def current_user_application
      #warden.user || @user
      @user
    end
  end

  resource :feedbacks do
    desc "Cria um registro de feedback"
    params do
      requires :data, type: Array, desc: "Dados do feedback"
      requires :app_token, type: String, desc: "Token da aplicação cadastrada em Feedback.serpro."
    end
    post do
      authenticate!
      Feedback.create!({
        user_application: current_user_application,
        attributes: params[:data][0],
        screenshot: params[:data][1]
        })
      end

      desc 'Retorna últimos 10 feedbacks de uma app'
      get do
        current_user_application.feedbacks.order(:created_at => 'desc').limit(10)
      end
    end
end
