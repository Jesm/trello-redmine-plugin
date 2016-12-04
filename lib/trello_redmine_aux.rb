class TrelloRedmineAux
  unloadable

  def self.post!(endpoint, params)
    url = make_url(endpoint)
    params = params.merge(default_params)

    req = Net::HTTP.post_form(URI.parse(url), params)
    handle_response(req)
  end

  def self.put!(endpoint, params)
  	url = make_url(endpoint)
  	params = params.merge(default_params)

    uri = URI.parse(url)
    secure = uri.scheme == 'https'
    http = Net::HTTP.new(uri.host, secure ? 443 : 80)
    http.use_ssl = true if secure
    resp = http.send_request('PUT', "#{uri.path}?#{params.to_query}")
    handle_response(resp)
  end

  def self.get_setting(str)
    initialize_settings!

    setting.value[str]
  end

  def self.initialize_settings!
    setup_version_board!
  end

  protected

  	def self.domain
  	  'api.trello.com'
  	end

  	def self.api_version
  	  '1'
  	end

  	def self.make_url(endpoint)
      "https://#{domain}/#{api_version}/#{endpoint}"
  	end

    def self.default_params
      { key: setting.value['app_key'], token: setting.value['user_token'] }
    end

  	def self.handle_response(req)
  		if req.content_type == "application/json"
        JSON.parse(req.body)
      else
        req
      end
  	end

    def self.setting
      @setting ||= Setting.find_or_default('plugin_trello_redmine_workflow')
    end

    def self.setup_version_board!
      return if setting.value["version_list_id"]

      list = post!('lists', {name: 'BUCKET', idBoard: setting.value["version_board_id"]})

      setting.value = setting.value.merge({ version_list_id: list['id'] })
      setting.save
    end

end