require 'nokogiri'
require 'result'

module Handlers

  # parse authorizable ID from response body data
  # this is used to get the authorizable ID of a newly created user/group
  def Handlers.html_authorizable_id(data, status_code, headers, response_spec, info)

    html = Nokogiri::HTML(data)
    authorizable_id = html.xpath('//title/text()').to_s
    authorizable_id.slice! "Content created #{info[:path]}"
    info[:authorizable_id] = authorizable_id.sub(/^\//, '')

    status = response_spec['status']
    message = response_spec['message'] % info

    Result.new(status, message)
  end

end
