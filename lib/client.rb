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
    action_spec['params'].each { |key, value|
      params.push(value % info)
    }

    base_responses = @spec[component]['responses']
    action_responses = action_spec['responses']
    responses = base_responses.merge(action_responses)

    result = nil

    begin

      data, status_code, headers = api.send("#{operation}_with_http_info", *params)

      if responses.key?(status_code)
        response_spec = responses[status_code]
        handler = response_spec['handler']
        result = Handlers.send(handler, data, status_code, headers, response_spec, info)
      else
        result = Result.new('failure', 'Unexpected response')
      end

    rescue SwaggerAemClient::ApiError => err
      response_spec = responses[err.code]
      handler = response_spec['handler']
      result = Handlers.send(handler, err.response_body, err.code, err.response_headers, response_spec, info)
    end

    result
  end

end
