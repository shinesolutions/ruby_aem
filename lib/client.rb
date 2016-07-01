require 'handlers/simple'

class Client

  def initialize(apis, spec)
    @apis = apis
    @spec = spec
  end

  def call(clazz, action, info)

    component = clazz.name.downcase
    action_spec = @spec[component]['actions'][action]

    api = @apis[action_spec['api'].to_sym]
    operation = action_spec['operation']

    params = []
    required_params = action_spec['params']['required'] || {}
    required_params.each { |key, value|
      params.push(value % info)
    }
    params.push({})
    optional_params = action_spec['params']['optional'] || {}
    optional_params.each { |name|
      if info.key? name.to_sym
        params[-1][name.to_sym] = info[name.to_sym]
      end
    }

    base_responses = @spec[component]['responses'] || {}
    action_responses = action_spec['responses'] || {}
    responses = base_responses.merge(action_responses)

    begin
      data, status_code, headers = api.send("#{operation}_with_http_info", *params)
      handle(data, status_code, headers, responses, info)
    rescue SwaggerAemClient::ApiError => err
      handle(err.response_body, err.code, err.response_headers, responses, info)
    end
  end

  def handle(data, status_code, headers, responses, info)
    if responses.key?(status_code)
      response_spec = responses[status_code]
      handler = response_spec['handler']
      result = Handlers.send(handler, data, status_code, headers, response_spec, info)
    else
      result = Result.new('failure', "Unexpected response\nstatus code: #{status_code}\nheaders: #{headers}\ndata: #{data}")
    end
  end

end
