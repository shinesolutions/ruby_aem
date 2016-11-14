require_relative '../spec_helper'
require_relative '../../../lib/ruby_aem/handlers/html'

describe 'HTML Handler' do
  before do
  end

  after do
  end

  describe 'test html_authorizable_id' do

    it 'should return result with status from data payload' do
      data =
        '<html>' \
        '<head>' \
        '  <title>Content created /home/groups/s/GDKHvEk6jG4lRaPUsAty</title>' \
        '</head>' \
        '<body>' \
        '</body>' \
        '</html>'
      status_code = nil
      headers = nil
      response_spec = { 'message' => 'Group %{name} created at %{path}/%{authorizable_id}' }
      call_params = { :name => 'somegroup', :path => '/home/groups/s' }

      response = RubyAem::Response.new(status_code, data, headers)
      result = RubyAem::Handlers.html_authorizable_id(response, response_spec, call_params)
      expect(result.message).to eq('Group somegroup created at /home/groups/s/GDKHvEk6jG4lRaPUsAty')
      expect(result.response).to be(response)
    end

  end

end
