require 'json'
require 'result'

module Handlers

  def Handlers.json_authorizable_id(data, status_code, headers, response_spec, info)

    json = JSON.parse(data)
    authorizable_id = nil
    if json['success'] == true && json['hits'].length == 1
      authorizable_id = json['hits'][0]['name']
      info[:authorizable_id] = authorizable_id
      message = response_spec['message'] % info
    else
      message = "User #{info[:name]} authorizable ID not found"
    end

    status = response_spec['status']

    result = Result.new(status, message)
    result.data = authorizable_id
    result
  end

end
