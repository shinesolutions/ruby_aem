require_relative 'spec_helper'
require_relative '../../lib/ruby_aem/package'

describe 'Package' do
  before do
    @mock_client = double('mock_client')
    @package = RubyAem::Package.new(@mock_client, 'somepackagegroup', 'somepackage', '1.2.3')
  end

  after do
  end

  describe 'test create' do

    it 'should call client with expected parameters' do
      expect(@mock_client).to receive(:call).once().with(
        RubyAem::Package,
        'create',
        { :group_name => 'somepackagegroup',
          :package_name => 'somepackage',
          :package_version => '1.2.3' })
      @package.create
    end

  end

end
