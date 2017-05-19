require_relative '../spec_helper'
require_relative '../../../lib/ruby_aem/resources/path'

describe 'Path' do
  before do
    @mock_client = double('mock_client')
    @path = RubyAem::Resources::Path.new(@mock_client, '/etc/designs/cloudservices')
  end

  after do
  end

  describe 'test activate' do
    it 'should call client with expected parameters' do
      expect(@mock_client).to receive(:call).once.with(
        RubyAem::Resources::Path,
        'activate',
        name: '/etc/designs/cloudservices',
        ignoredeactivated: true,
        onlymodified: false
      )
      @path.activate(true, false)
    end
  end
end
