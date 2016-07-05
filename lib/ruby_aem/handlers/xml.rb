require 'nokogiri'

module RubyAem
  module Handlers

    def Handlers.xml_package_list(data, status_code, headers, response_spec, info)

      xml = Nokogiri::XML(data)

      status_code = xml.xpath('//crx/response/status/@code').to_s
      status_text = xml.xpath('//crx/response/status/text()').to_s

      if status_code == '200' && status_text == 'ok'
        message = response_spec['message'] % info
        result = RubyAem::Result.new('success', message)
        result.data = xml.xpath('//crx/response/data/packages')
      else
        result = RubyAem::Result.new('failure', "Unable to retrieve package list, getting status code #{status_code} and status text #{status_text}")
      end

      result
    end

  end
end
