require_relative '../spec_helper'
require_relative '../../../lib/ruby_aem/resources/aem'

describe 'Aem' do
  before do
    @mock_client = double('mock_client')
  end

  after do
  end

  # describe 'test get_login_page' do
  #
  #   it 'should call client with expected parameters' do
  #     expect(@mock_client).to receive(:call).once().with(RubyAem::Resources::Aem, 'get_login_page', {})
  #     aem = RubyAem::Resources::Aem.new(@mock_client)
  #     aem.get_login_page
  #   end
  #
  # end

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
      expect(mock_result_not_ok).to receive(:message).twice().and_return(mock_message_not_ok)

      mock_message_ok = 'Login page retrieved'
      mock_body_ok = 'QUICKSTART_HOMEPAGE'
      mock_response_ok = double('mock_response_ok')
      mock_result_ok = double('mock_result_ok')
      expect(mock_response_ok).to receive(:body).and_return(mock_body_ok)
      expect(mock_result_ok).to receive(:response).and_return(mock_response_ok)
      expect(mock_result_ok).to receive(:message).and_return(mock_message_ok)

      expect(@mock_client).to receive(:call).once().with(RubyAem::Resources::Aem, 'get_login_page', {}).and_raise(mock_error)
      expect(@mock_client).to receive(:call).once().with(RubyAem::Resources::Aem, 'get_login_page', {}).and_return(mock_result_not_ok)
      expect(@mock_client).to receive(:call).once().with(RubyAem::Resources::Aem, 'get_login_page', {}).and_return(mock_result_ok)
      aem = RubyAem::Resources::Aem.new(@mock_client)

      expect(STDOUT).to receive(:puts).with('Retrieve login page attempt #1: Login page has some error')
      expect(STDOUT).to receive(:puts).with('Retrieve login page attempt #2: Login page retrieved but not ready yet')
      expect(STDOUT).to receive(:puts).with('Retrieve login page attempt #3: Login page retrieved and ready')
      aem.get_login_page_wait_until_ready
    end

  end

end
