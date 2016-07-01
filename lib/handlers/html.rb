require 'nokogiri'
require 'result'

module Handlers

  def Handlers.html_authorizable_id(data, status_code, headers, response_spec, info)

    # parse authorizable ID from response body data because the node didn't exist when the handler was created
    html = Nokogiri::HTML(data)
    authorizable_id = html.xpath('//title/text()').to_s
    authorizable_id.slice! "Content created #{info[:path]}"
    info[:authorizable_id] = authorizable_id.sub(/^\//, '')

    status = response_spec['status']
    message = response_spec['message'] % info

    Result.new(status, message)
  end

end
