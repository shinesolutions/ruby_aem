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
      response_spec = { 'message' => 'Group %{name} created at %{path}/%<authorizable_id>s' }
      call_params = { name: 'somegroup', path: '/home/groups/s' }

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
      response_spec = { 'message' => 'Allowed package installation error - %<title>s: %<desc>s %<reason>s' }
      call_params = {}

      response = RubyAem::Response.new(status_code, data, headers)
      result = RubyAem::Handlers.html_package_service_allow_error(response, response_spec, call_params)
      expect(result.message).to eq('Allowed package installation error - Error 500 : Problem accessing /crx/packmgr/service/.json/etc/packages/adobe/cq620/servicepack/aem-service-pkg-6.2.SP1.zip. Reason: java.lang.NullPointerException')
      expect(result.response).to be(response)
    end
  end

  describe 'test html_change_password' do
    it 'should identify success response body and display username in message' do
      data =
        '<html>' \
        '<head>' \
        '  <title>Content created /home/groups/s/GDKHvEk6jG4lRaPUsAty</title>' \
        '</head>' \
        '<body style="background-color:white" frameborder="no">' \
        '<div class="listNamelistName" style="margin-left:7px;margin-top:15px;">' \
        '  <table>' \
        '    <tr>' \
        '      <td>User Name:</td>' \
        '      <td><b>someuser</b></td>' \
        '    </tr>' \
        '    <tr>' \
        '      <td></td>' \
        '      <td><font color="green">Password successfully changed.</font></td>' \
        '    </tr>' \
        '  </table>' \
        '</body>' \
        '</html>'
      status_code = nil
      headers = nil
      response_spec = { 'message' => 'User %<user>s\'s password has been changed' }
      call_params = { old_password: 'someoldpassword', new_password: 'somenewpassword' }

      response = RubyAem::Response.new(status_code, data, headers)
      result = RubyAem::Handlers.html_change_password(response, response_spec, call_params)
      expect(result.message).to eq('User someuser\'s password has been changed')
      expect(result.response).to be(response)
    end

    it 'should identify error response body and pass error message' do
      data =
        '<html>' \
        '<head>' \
        '  <title>Content created /home/groups/s/GDKHvEk6jG4lRaPUsAty</title>' \
        '</head>' \
        '<body style="background-color:white" frameborder="no">' \
        '<div class="listNamelistName" style="margin-left:7px;margin-top:15px;">' \
        '  <table>' \
        '    <tr>' \
        '      <td>User Name:</td>' \
        '      <td><b>someuser</b></td>' \
        '    </tr>' \
        '    <tr>' \
        '      <td></td>' \
        '      <td><font color="red">Failed to change password for user \'someuser\': Failed to change password: Old password does not match.</font></td>' \
        '    </tr>' \
        '  </table>' \
        '</body>' \
        '</html>'
      status_code = nil
      headers = nil
      response_spec = { 'message' => 'User %<name>s\'s password has been changed' }
      call_params = { old_password: 'someoldpassword', new_password: 'somenewpassword' }

      begin
        response = RubyAem::Response.new(status_code, data, headers)
        RubyAem::Handlers.html_change_password(response, response_spec, call_params)
        raise
      rescue RubyAem::Error => err
        expect(err.message).to eq('Failed to change password for user \'someuser\': Failed to change password: Old password does not match.')
        expect(err.result.response).to be(response)
      end
    end

    it 'should pass error message when response body is empty' do
      data = ''
      status_code = nil
      headers = nil
      response_spec = { 'message' => 'User %<name>s\'s password has been changed' }
      call_params = { old_password: 'someoldpassword', new_password: 'somenewpassword' }

      begin
        response = RubyAem::Response.new(status_code, data, headers)
        RubyAem::Handlers.html_change_password(response, response_spec, call_params)
        raise
      rescue RubyAem::Error => err
        expect(err.message).to eq('Failed to change password: Response body is empty, user likely does not exist.')
        expect(err.result.response).to be(response)
      end
    end
  end
end
