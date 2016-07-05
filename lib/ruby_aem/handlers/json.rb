require 'json'

module RubyAem
  module Handlers

    def Handlers.json_authorizable_id(data, status_code, headers, response_spec, info)

      json = JSON.parse(data)
      authorizable_id = nil
      if json['success'] == true && json['hits'].length == 1
        authorizable_id = json['hits'][0]['name']
        info[:authorizable_id] = authorizable_id
        message = response_spec['message'] % info
      else
        message = "User/Group #{info[:name]} authorizable ID not found"
      end

      status = response_spec['status']

      result = RubyAem::Result.new(status, message)
      result.data = authorizable_id
      result
    end

    def Handlers.json_package_service(data, status_code, headers, response_spec, info)

      json = JSON.parse(data)

      status = json['success'] == true ? 'success' : 'failure'
      message = json['msg']

      RubyAem::Result.new(status, message)
    end

    def Handlers.json_package_filter(data, status_code, headers, response_spec, info)

      json = JSON.parse(data)

      filter = []
      json.each do |key, value|
        if json[key]['root'] != nil
          filter.push(json[key]['root'])
        end
      end

      message = response_spec['message'] % info

      result = RubyAem::Result.new('success', message)
      result.data = filter
      result

    end

  end
end
