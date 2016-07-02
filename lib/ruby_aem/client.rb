require 'ruby_aem/handlers/html'
require 'ruby_aem/handlers/json'
require 'ruby_aem/handlers/simple'

module RubyAem
  class Client

    def initialize(apis, spec)
      @apis = apis
      @spec = spec
    end

    def call(clazz, action, info)

      component = clazz.name.downcase.sub('rubyaem::', '')
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
      optional_params.each { |key, value|
        # if there is no value in optional param spec,
        # then only add optional param that is set in info
        if !value
          if info.key? key.to_sym
            params[-1][key.to_sym] = info[key.to_sym]
          end
        # if value is provided in optional param spec,
        # then apply variable interpolation the same way as required param
        else
          params[-1][key.to_sym] = value % info
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
end
