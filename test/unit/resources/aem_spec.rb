require_relative '../spec_helper'
require_relative '../../../lib/ruby_aem/resources/aem'

require 'rexml/document'

describe 'Aem' do
  before do
    @mock_client = double('mock_client')
  end

  after do
  end

  describe 'test get_login_page' do
    it 'should call client with expected parameters' do
      expect(@mock_client).to receive(:call).once.with(RubyAem::Resources::Aem, 'get_login_page', {})
      aem = RubyAem::Resources::Aem.new(@mock_client)
      aem.get_login_page
    end
  end

  describe 'test get_package_manager_servlet_status' do
    it 'should call client with expected parameters' do
      expect(@mock_client).to receive(:call).once.with(RubyAem::Resources::Aem, 'get_package_manager_servlet_status', {})
      aem = RubyAem::Resources::Aem.new(@mock_client)
      aem.get_package_manager_servlet_status
    end
  end

  describe 'test get_crxde_status' do
    it 'should call client with expected parameters' do
      expect(@mock_client).to receive(:call).once.with(RubyAem::Resources::Aem, 'get_crxde_status', {})
      aem = RubyAem::Resources::Aem.new(@mock_client)
      aem.get_crxde_status
    end
  end

  describe 'test get_aem_health_check' do
    it 'should call client with expected parameters' do
      expect(@mock_client).to receive(:call).once.with(RubyAem::Resources::Aem, 'get_aem_health_check', tags: 'shallow', combine_tags_or: false)
      aem = RubyAem::Resources::Aem.new(@mock_client)
      aem.get_aem_health_check(tags: 'shallow', combine_tags_or: false)
    end
  end

  describe 'test get_login_page_wait_until_ready' do
    it 'should call client with expected parameters' do
      mock_message_error = 'Login page has some error'
      mock_result_error = double('mock_result_error')
      mock_error = RubyAem::Error.new(mock_message_error, mock_result_error)

      mock_message_not_ok = 'Login page retrieved'
      mock_body_not_ok = 'PAGE NOT READY'
      mock_response_not_ok = double('mock_response_not_ok')
      mock_result_not_ok = double('mock_result_not_ok')
      expect(mock_response_not_ok).to receive(:body).and_return(mock_body_not_ok)
      expect(mock_result_not_ok).to receive(:response).and_return(mock_response_not_ok)
      expect(mock_result_not_ok).to receive(:message).twice.and_return(mock_message_not_ok)

      mock_message_ok = 'Login page retrieved'
      mock_body_ok = 'QUICKSTART_HOMEPAGE'
      mock_response_ok = double('mock_response_ok')
      mock_result_ok = double('mock_result_ok')
      expect(mock_response_ok).to receive(:body).and_return(mock_body_ok)
      expect(mock_result_ok).to receive(:response).and_return(mock_response_ok)
      expect(mock_result_ok).to receive(:message).and_return(mock_message_ok)

      expect(@mock_client).to receive(:call).once.with(RubyAem::Resources::Aem, 'get_login_page', {}).and_raise(mock_error)
      expect(@mock_client).to receive(:call).once.with(RubyAem::Resources::Aem, 'get_login_page', {}).and_return(mock_result_not_ok)
      expect(@mock_client).to receive(:call).once.with(RubyAem::Resources::Aem, 'get_login_page', {}).and_return(mock_result_ok)
      aem = RubyAem::Resources::Aem.new(@mock_client)

      expect(STDOUT).to receive(:puts).with('Retrieve login page attempt #1: Login page has some error')
      expect(STDOUT).to receive(:puts).with('Retrieve login page attempt #2: Login page retrieved but not ready yet')
      expect(STDOUT).to receive(:puts).with('Retrieve login page attempt #3: Login page retrieved and ready')
      aem.get_login_page_wait_until_ready(
        _retries: {
          max_tries: '60',
          base_sleep_seconds: '2',
          max_sleep_seconds: '2'
        }
      )
    end
  end

  ########################################################################
  # TO-DO:
  # This test needs to be updated as it only works if
  # package manager is active at the moment
  ########################################################################
  describe 'test get_package_manager_servlet_status_wait_until_ready' do
    it 'should call client with expected parameters' do
      # mock_message_error = 'Package Manager disabled'
      # mock_result_error = double('mock_result_error')
      # mock_error = RubyAem::Error.new(mock_message_error, mock_result_error)

      mock_data_ok = double('true')
      mock_message_ok = 'Package Manager active'
      mock_result_ok = double('mock_result_ok')
      expect(mock_result_ok).to receive(:data).and_return(mock_data_ok)
      expect(mock_result_ok).to receive(:message).and_return(mock_message_ok)

      # expect(@mock_client).to receive(:call).once.with(RubyAem::Resources::Aem, 'get_package_manager_servlet_status', {}).and_raise(mock_error)
      expect(@mock_client).to receive(:call).once.with(RubyAem::Resources::Aem, 'get_package_manager_servlet_status', {}).and_return(mock_result_ok)
      aem = RubyAem::Resources::Aem.new(@mock_client)

      expect(STDOUT).to receive(:puts).with('Check CRX Package Manager service attempt #1: Package Manager active')
      aem.get_package_manager_servlet_status_wait_until_ready(
        _retries: {
          max_tries: '60',
          base_sleep_seconds: '2',
          max_sleep_seconds: '2'
        }
      )
    end
  end

  describe 'test get_aem_health_check_wait_until_ok' do
    it 'should call client with expected parameters' do
      mock_message_error = 'AEM Health Check has some error'
      mock_result_error = double('mock_result_error')
      mock_error = RubyAem::Error.new(mock_message_error, mock_result_error)

      mock_message_not_ok = 'AEM Health Check retrieved'
      mock_body_not_ok =
        '{' \
        '  "results": [' \
        '    {' \
        '      "name": "name1",' \
        '      "status": "OK",' \
        '      "timeMs": 11' \
        '    },' \
        '    {' \
        '      "name": "name2",' \
        '      "status": "CRITICAL",' \
        '      "timeMs": 22' \
        '    }' \
        '  ]' \
        '}'
      mock_result_not_ok = double('mock_result_not_ok')
      expect(mock_result_not_ok).to receive(:data).and_return(JSON.parse(mock_body_not_ok)['results'])
      expect(mock_result_not_ok).to receive(:message).twice.and_return(mock_message_not_ok)

      mock_message_ok = 'AEM Health Check retrieved'
      mock_body_ok =
        '{' \
        '  "results": [' \
        '    {' \
        '      "name": "name1",' \
        '      "status": "OK",' \
        '      "timeMs": 11' \
        '    },' \
        '    {' \
        '      "name": "name2",' \
        '      "status": "OK",' \
        '      "timeMs": 22' \
        '    }' \
        '  ]' \
        '}'
      mock_result_ok = double('mock_result_ok')
      expect(mock_result_ok).to receive(:data).and_return(JSON.parse(mock_body_ok)['results'])
      expect(mock_result_ok).to receive(:message).and_return(mock_message_ok)

      expect(@mock_client).to receive(:call).once.with(RubyAem::Resources::Aem, 'get_aem_health_check', tags: 'shallow', combine_tags_or: false).and_raise(mock_error)
      expect(@mock_client).to receive(:call).once.with(RubyAem::Resources::Aem, 'get_aem_health_check', tags: 'shallow', combine_tags_or: false).and_return(mock_result_not_ok)
      expect(@mock_client).to receive(:call).once.with(RubyAem::Resources::Aem, 'get_aem_health_check', tags: 'shallow', combine_tags_or: false).and_return(mock_result_ok)
      aem = RubyAem::Resources::Aem.new(@mock_client)

      expect(STDOUT).to receive(:puts).with('Retrieve AEM Health Check attempt #1: AEM Health Check has some error')
      expect(STDOUT).to receive(:puts).with('Retrieve AEM Health Check attempt #2: AEM Health Check retrieved but not ok yet')
      expect(STDOUT).to receive(:puts).with('Retrieve AEM Health Check attempt #3: AEM Health Check retrieved and ok')
      aem.get_aem_health_check_wait_until_ok(
        tags: 'shallow',
        combine_tags_or: false,
        _retries: {
          max_tries: '60',
          base_sleep_seconds: '2',
          max_sleep_seconds: '2'
        }
      )
    end
  end

  describe 'test get_agents' do
    it 'should call client with expected parameters' do
      expect(@mock_client).to receive(:call).once.with(RubyAem::Resources::Aem, 'get_agents', run_mode: 'author')
      aem = RubyAem::Resources::Aem.new(@mock_client)
      aem.get_agents('author')
    end
  end

  describe 'test get_install_status' do
    it 'should call client with expected parameters' do
      expect(@mock_client).to receive(:call).once.with(RubyAem::Resources::Aem, 'get_install_status', {})
      aem = RubyAem::Resources::Aem.new(@mock_client)
      aem.get_install_status
    end
  end

  describe 'test get_aem_health_check_wait_until_finished' do
    it 'should call client with expected parameters' do
      mock_message_error = 'Install status has some error'
      mock_result_error = double('mock_result_error')
      mock_error = RubyAem::Error.new(mock_message_error, mock_result_error)

      mock_message_not_finished = 'Install status retrieved'
      status_not_finished = SwaggerAemClient::InstallStatusStatus.new(finished: false, item_count: 123)
      mock_body_not_finished = SwaggerAemClient::InstallStatus.new(status: status_not_finished)
      mock_response_not_finished = double('mock_response_not_finished')
      mock_result_not_finished = double('mock_result_not_finished')
      expect(mock_response_not_finished).to receive(:body).twice.and_return(mock_body_not_finished)
      expect(mock_result_not_finished).to receive(:response).twice.and_return(mock_response_not_finished)
      expect(mock_result_not_finished).to receive(:message).twice.and_return(mock_message_not_finished)

      mock_message_finished = 'Install status retrieved'
      status_finished = SwaggerAemClient::InstallStatusStatus.new(finished: true, item_count: 0)
      mock_body_finished = SwaggerAemClient::InstallStatus.new(status: status_finished)
      mock_response_finished = double('mock_response_finished')
      mock_result_finished = double('mock_result_finished')
      expect(mock_response_finished).to receive(:body).twice.and_return(mock_body_finished)
      expect(mock_result_finished).to receive(:response).twice.and_return(mock_response_finished)
      expect(mock_result_finished).to receive(:message).and_return(mock_message_finished)

      expect(@mock_client).to receive(:call).once.with(RubyAem::Resources::Aem, 'get_install_status', {}).and_raise(mock_error)
      expect(@mock_client).to receive(:call).once.with(RubyAem::Resources::Aem, 'get_install_status', {}).and_return(mock_result_not_finished)
      expect(@mock_client).to receive(:call).once.with(RubyAem::Resources::Aem, 'get_install_status', {}).and_return(mock_result_finished)
      aem = RubyAem::Resources::Aem.new(@mock_client)

      expect(STDOUT).to receive(:puts).with('Retrieve AEM install status attempt #1: Install status has some error')
      expect(STDOUT).to receive(:puts).with('Retrieve AEM install status attempt #2: Install status retrieved but not finished yet, still installing 123 package(s)')
      expect(STDOUT).to receive(:puts).with('Retrieve AEM install status attempt #3: Install status retrieved and finished')
      aem.get_install_status_wait_until_finished
    end

    describe 'test get_packages' do
      it 'should have result data of packages list' do
        mock_packages_xml =
          '<packages>' \
          '  <package>' \
          '    <group>shinesolutions</group>' \
          '    <name>aem-password-reset-content</name>' \
          '    <version>1.0.1</version>' \
          '    <downloadName>aem-password-reset-content-1.0.1.zip</downloadName>' \
          '    <size>23579</size>' \
          '    <created>Tue, 4 Apr 2017 13:38:35 +1000</created>' \
          '    <createdBy>root</createdBy>' \
          '    <lastModified/>' \
          '    <lastModifiedBy>null</lastModifiedBy>' \
          '    <lastUnpacked>Wed, 18 Apr 2018 22:57:01 +1000</lastUnpacked>' \
          '    <lastUnpackedBy>admin</lastUnpackedBy>' \
          '  </package>' \
          '</packages>'
        mock_message = double('mock_message')
        mock_response = double('mock_response')
        mock_result_ok = double('mock_result_ok')
        expect(mock_result_ok).to receive(:message).and_return(mock_message)
        expect(mock_result_ok).to receive(:response).and_return(mock_response)
        expect(mock_result_ok).to receive(:data).and_return(REXML::Document.new(mock_packages_xml))
        expect(@mock_client).to receive(:call).once.with(RubyAem::Resources::Aem, 'get_packages', {}).and_return(mock_result_ok)
        aem = RubyAem::Resources::Aem.new(@mock_client)
        aem.get_packages
      end
    end
  end
end
