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

  describe 'test html_package_service_allow_error' do

    it 'should return result with status from data payload' do
      data =
        '<html>' \
        '<head>' \
        '<meta http-equiv="Content-Type" content="text/html;charset=ISO-8859-1"/>' \
        '  <title>Error 500 </title>' \
        '</head>' \
        '<body>' \
        '<h2>HTTP ERROR: 500</h2>' \
        '<p>Problem accessing /crx/packmgr/service/.json/etc/packages/adobe/cq620/servicepack/aem-service-pkg-6.2.SP1.zip. Reason:' \
        '<pre>java.lang.NullPointerException</pre></p>' \
        '<hr /><i><small>Powered by Jetty://</small></i>' \
        '</body>' \
        '</html>'
      status_code = nil
      headers = nil
      response_spec = { 'message' => 'Allowed package installation error - %{title}: %{desc} %{reason}' }
      call_params = {}

      response = RubyAem::Response.new(status_code, data, headers)
      result = RubyAem::Handlers.html_package_service_allow_error(response, response_spec, call_params)
      expect(result.message).to eq('Allowed package installation error - Error 500 : Problem accessing /crx/packmgr/service/.json/etc/packages/adobe/cq620/servicepack/aem-service-pkg-6.2.SP1.zip. Reason: java.lang.NullPointerException')
      expect(result.response).to be(response)
    end

  end
end
