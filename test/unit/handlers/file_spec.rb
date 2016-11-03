require_relative '../spec_helper'
require_relative '../../../lib/ruby_aem/handlers/file'

describe 'File Handler' do
  before do
  end

  after do
  end

  describe 'test file_download' do

    it 'should move file and return success result' do
      mock_data = double('mock_data')
      expect(mock_data).to receive(:path).once().and_return('/some/download/path')
      expect(mock_data).to receive(:delete).once()

      expect(FileUtils).to receive(:cp).once().with('/some/download/path', '/tmp/somepackage-1.2.3.zip')

      data = mock_data
      status_code = nil
      headers = nil
      response_spec = { 'status' => 'success', 'message' => 'Package downloaded to %{file_path}/%{package_name}-%{package_version}.zip' }
      info = {
        :group_name => 'somepackagegroup',
        :package_name => 'somepackage',
        :package_version => '1.2.3',
        :file_path => '/tmp'
      }

      response = RubyAem::Response.new(status_code, data, headers)
      result = RubyAem::Handlers.file_download(response, response_spec, info)
      expect(result.is_success?).to be(true)
      expect(result.message).to eq('Package downloaded to /tmp/somepackage-1.2.3.zip')
    end

  end

end
