class ProxyController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    image_url = params['url']
    callback = params['callback']

    if  !image_url || !callback
      render :text => 'missing arguments', :status => 400
    end

    begin
      base64_img, ctype = download_image(image_url)
      img_data_src = build_data_img_src(base64_img, ctype)
      render :json => img_data_src.to_json, :callback => callback
    rescue
      render :json => {error: 'Application error'}, :callback => callback
    end

  end

private

    def build_data_img_src(base64_mage, content_type)
      "data:#{content_type};base64,#{base64_mage}"
    end

    def download_image(url, encoding='base64')
      uri = URI.parse(url)
      scheme, host, port, path, query = uri.select(:scheme, :host, :port, :path, :query)
      con = Faraday.new "http://#{host}:#{port}", :ssl => {:verify => false}
      # :ssl => {
      #   :client_cert  => ...,
      #   :client_key   => ...,
      #   :ca_file      => ...,
      #   :ca_path      => ...,
      #   :cert_store   => ...
      # }
      con.scheme = scheme
      response = con.get "#{path}?#{query}", {'accept_encoding' => 'base64'}
      base64_image = Base64.strict_encode64 response.body
      image_content_type = response.headers['Content-Type']
      return base64_image, image_content_type
    end
end
