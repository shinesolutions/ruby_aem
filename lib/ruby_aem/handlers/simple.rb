require 'ruby_aem/result'

module RubyAem
  module Handlers

    def Handlers.simple(data, status_code, headers, response_spec, info)

      status = response_spec['status']
      message = response_spec['message'] % info

      RubyAem::Result.new(status, message)
    end

  end
end
