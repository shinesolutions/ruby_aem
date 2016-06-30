require 'result'

module Handlers

  def Handlers.simple(data, status_code, headers, response_spec, info)

    status = response_spec['status']
    message = response_spec['message'] % info

    return Result.new(status, message)
  end

end
