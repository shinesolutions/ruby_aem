require_relative '../spec_helper'
require_relative '../../../lib/ruby_aem/resources/package'
require 'nokogiri'

describe 'Package' do
  before do
    @mock_client = double('mock_client')
    @package = RubyAem::Resources::Package.new(@mock_client, 'somepackagegroup', 'somepackage', '1.2.3')
  end

  after do
  end

  describe 'test create' do

    it 'should call client with expected parameters' do
      expect(@mock_client).to receive(:call).once().with(
        RubyAem::Resources::Package,
        'create',
        { :group_name => 'somepackagegroup',
          :package_name => 'somepackage',
          :package_version => '1.2.3' })
      @package.create
    end

  end

  describe 'test update' do

    it 'should call client with expected parameters' do
      expect(@mock_client).to receive(:call).once().with(
        RubyAem::Resources::Package,
        'update',
        { :group_name => 'somepackagegroup',
          :package_name => 'somepackage',
          :package_version => '1.2.3',
          :filter => "[{\"root\":\"/apps/geometrixx\",\"rules\":[]},{\"root\":\"/apps/geometrixx-common\",\"rules\":[]}]" })
      @package.update('[{"root":"/apps/geometrixx","rules":[]},{"root":"/apps/geometrixx-common","rules":[]}]')
    end

  end

  describe 'test delete' do

    it 'should call client with expected parameters' do
      expect(@mock_client).to receive(:call).once().with(
        RubyAem::Resources::Package,
        'delete',
        { :group_name => 'somepackagegroup',
          :package_name => 'somepackage',
          :package_version => '1.2.3' })
      @package.delete
    end

  end

  describe 'test install' do

    it 'should call client with expected parameters' do
      expect(@mock_client).to receive(:call).once().with(
        RubyAem::Resources::Package,
        'install',
        { :group_name => 'somepackagegroup',
          :package_name => 'somepackage',
          :package_version => '1.2.3',
          :recursive => false })
      @package.install({ recursive: false })
    end

  end

  describe 'test replicate' do

    it 'should call client with expected parameters' do
      expect(@mock_client).to receive(:call).once().with(
        RubyAem::Resources::Package,
        'replicate',
        { :group_name => 'somepackagegroup',
          :package_name => 'somepackage',
          :package_version => '1.2.3' })
      @package.replicate
    end

  end

  describe 'test build' do

    it 'should call client with expected parameters' do
      expect(@mock_client).to receive(:call).once().with(
        RubyAem::Resources::Package,
        'build',
        { :group_name => 'somepackagegroup',
          :package_name => 'somepackage',
          :package_version => '1.2.3' })
      @package.build
    end

  end

  describe 'test download' do

    it 'should call client with expected parameters' do
      expect(@mock_client).to receive(:call).once().with(
        RubyAem::Resources::Package,
        'download',
        { :group_name => 'somepackagegroup',
          :package_name => 'somepackage',
          :package_version => '1.2.3',
          :file_path => '/tmp' })
      @package.download('/tmp')
    end

  end

  describe 'test upload' do

    it 'should call client with expected parameters' do
      expect(@mock_client).to receive(:call).once().with(
        RubyAem::Resources::Package,
        'upload',
        { :group_name => 'somepackagegroup',
          :package_name => 'somepackage',
          :package_version => '1.2.3',
          :file_path => '/tmp',
          :force => true })
      @package.upload('/tmp', { force: true })
    end

  end

  describe 'test get_filter' do

    it 'should call client with expected parameters' do
      expect(@mock_client).to receive(:call).once().with(
        RubyAem::Resources::Package,
        'get_filter',
        { :group_name => 'somepackagegroup',
          :package_name => 'somepackage',
          :package_version => '1.2.3' })
      @package.get_filter
    end

  end

  describe 'test activate_filter' do

    it 'should call client with expected parameters' do

      mock_result_get_filter = double('mock_result_get_filter')
      mock_result_activate_1 = double('mock_result_activate_1')
      mock_result_activate_2 = double('mock_result_activate_2')

      expect(mock_result_get_filter).to receive(:data).and_return(['/some/path/1', '/some/path/2'])
      expect(@mock_client).to receive(:call).once().with(
        RubyAem::Resources::Package,
        'get_filter',
        { :group_name => 'somepackagegroup',
          :package_name => 'somepackage',
          :package_version => '1.2.3' }).and_return(mock_result_get_filter)
      expect(@mock_client).to receive(:call).once().with(
        RubyAem::Resources::Path,
        'activate',
        { :name => '/some/path/1',
          :ignoredeactivated => true,
          :onlymodified => false }).and_return(mock_result_activate_1)
      expect(@mock_client).to receive(:call).once().with(
        RubyAem::Resources::Path,
        'activate',
        { :name => '/some/path/2',
          :ignoredeactivated => true,
          :onlymodified => false }).and_return(mock_result_activate_2)

      @package.activate_filter(true, false)
    end

  end

  describe 'test list_all' do

    it 'should call client with expected parameters' do
      expect(@mock_client).to receive(:call).once().with(
        RubyAem::Resources::Package,
        'list_all',
        { :group_name => 'somepackagegroup',
          :package_name => 'somepackage',
          :package_version => '1.2.3' })
      @package.list_all
    end

  end

  describe 'test is_uploaded' do

    it 'should return true result data when package exists on the list' do

      mock_data_list_all = Nokogiri::XML(
        '<packages>' \
        '  <package>' \
        '    <group>somepackagegroup</group>' \
        '    <name>somepackage</name>' \
        '    <version>1.2.3</version>' \
        '  </package>' \
        '</packages>')
      mock_result_list_all = double('mock_result_list_all')
      expect(mock_result_list_all).to receive(:data).and_return(mock_data_list_all)

      expect(@mock_client).to receive(:call).once().with(
        RubyAem::Resources::Package,
        'list_all',
        { :group_name => 'somepackagegroup',
          :package_name => 'somepackage',
          :package_version => '1.2.3' }).and_return(mock_result_list_all)
      result = @package.is_uploaded
      expect(result.message).to eq('Package somepackagegroup/somepackage-1.2.3 is uploaded')
      expect(result.response).to be(nil)
      expect(result.data).to eq(true)

    end

    it 'should return false result data when package does not exist on the list' do

      mock_data_list_all = Nokogiri::XML('')
      mock_result_list_all = double('mock_result_list_all')
      expect(mock_result_list_all).to receive(:data).and_return(mock_data_list_all)

      expect(@mock_client).to receive(:call).once().with(
        RubyAem::Resources::Package,
        'list_all',
        { :group_name => 'somepackagegroup',
          :package_name => 'somepackage',
          :package_version => '1.2.3' }).and_return(mock_result_list_all)
      result = @package.is_uploaded
      expect(result.message).to eq('Package somepackagegroup/somepackage-1.2.3 is not uploaded')
      expect(result.response).to be(nil)
      expect(result.data).to eq(false)

    end

  end

  describe 'test is_installed' do

    it 'should return true result data when package has lastUnpackedBy attribute value' do

      mock_data_list_all = Nokogiri::XML(
        '<packages>' \
        '  <package>' \
        '    <group>somepackagegroup</group>' \
        '    <name>somepackage</name>' \
        '    <version>1.2.3</version>' \
        '    <lastUnpackedBy>admin</lastUnpackedBy>' \
        '  </package>' \
        '</packages>')
      mock_result_list_all = double('mock_result_list_all')
      expect(mock_result_list_all).to receive(:data).and_return(mock_data_list_all)

      expect(@mock_client).to receive(:call).once().with(
        RubyAem::Resources::Package,
        'list_all',
        { :group_name => 'somepackagegroup',
          :package_name => 'somepackage',
          :package_version => '1.2.3' }).and_return(mock_result_list_all)
      result = @package.is_installed
      expect(result.message).to eq('Package somepackagegroup/somepackage-1.2.3 is installed')
      expect(result.response).to be(nil)
      expect(result.data).to eq(true)

    end

    it 'should return false result  data when package has null lastUnpackedBy attribute value' do

      mock_data_list_all = Nokogiri::XML(
        '<packages>' \
        '  <package>' \
        '    <group>somepackagegroup</group>' \
        '    <name>somepackage</name>' \
        '    <version>1.2.3</version>' \
        '    <lastUnpackedBy>null</lastUnpackedBy>' \
        '  </package>' \
        '</packages>')
      mock_result_list_all = double('mock_result_list_all')
      expect(mock_result_list_all).to receive(:data).and_return(mock_data_list_all)

      expect(@mock_client).to receive(:call).once().with(
        RubyAem::Resources::Package,
        'list_all',
        { :group_name => 'somepackagegroup',
          :package_name => 'somepackage',
          :package_version => '1.2.3' }).and_return(mock_result_list_all)
      result = @package.is_installed
      expect(result.message).to eq('Package somepackagegroup/somepackage-1.2.3 is not installed')
      expect(result.response).to be(nil)
      expect(result.data).to eq(false)

    end

    it 'should return false result  data when package has null lastUnpackedBy attribute value' do

      mock_data_list_all = Nokogiri::XML(
        '<packages>' \
        '  <package>' \
        '    <group>somepackagegroup</group>' \
        '    <name>somepackage</name>' \
        '    <version>1.2.3</version>' \
        '    <lastUnpackedBy/>' \
        '  </package>' \
        '</packages>')
      mock_result_list_all = double('mock_result_list_all')
      expect(mock_result_list_all).to receive(:data).and_return(mock_data_list_all)

      expect(@mock_client).to receive(:call).once().with(
        RubyAem::Resources::Package,
        'list_all',
        { :group_name => 'somepackagegroup',
          :package_name => 'somepackage',
          :package_version => '1.2.3' }).and_return(mock_result_list_all)
      result = @package.is_installed
      expect(result.message).to eq('Package somepackagegroup/somepackage-1.2.3 is not installed')
      expect(result.response).to be(nil)
      expect(result.data).to eq(false)

    end

    it 'should return false result  data when checked package segment does not exist at all' do

      mock_data_list_all = Nokogiri::XML(
        '<packages>' \
        '  <package>' \
        '    <group>otherpackagegroup</group>' \
        '    <name>otherpackage</name>' \
        '    <version>4.5.6</version>' \
        '    <lastUnpackedBy>admin</lastUnpackedBy>' \
        '  </package>' \
        '</packages>')
      mock_result_list_all = double('mock_result_list_all')
      expect(mock_result_list_all).to receive(:data).and_return(mock_data_list_all)

      expect(@mock_client).to receive(:call).once().with(
        RubyAem::Resources::Package,
        'list_all',
        { :group_name => 'somepackagegroup',
          :package_name => 'somepackage',
          :package_version => '1.2.3' }).and_return(mock_result_list_all)
      result = @package.is_installed
      expect(result.message).to eq('Package somepackagegroup/somepackage-1.2.3 is not installed')
      expect(result.response).to be(nil)
      expect(result.data).to eq(false)

    end
  end

  describe 'test upload_wait_until_ready' do

    it 'should call client with expected parameters' do
      expect(@mock_client).to receive(:call).once().with(
        RubyAem::Resources::Package,
        'upload',
        { :group_name => 'somepackagegroup',
          :package_name => 'somepackage',
          :package_version => '1.2.3',
          :file_path => '/tmp',
          :force => true,
          :_retries => {
            :max_tries => 60,
            :base_sleep_seconds => 2,
            :max_sleep_seconds => 2
          }})

      mock_data_list_all_not_installed = Nokogiri::XML('')
      mock_result_list_all_not_installed = double('mock_result_list_all_not_installed')
      expect(mock_result_list_all_not_installed).to receive(:data).and_return(mock_data_list_all_not_installed)

      expect(@mock_client).to receive(:call).once().with(
        RubyAem::Resources::Package,
        'list_all',
        { :group_name => 'somepackagegroup',
          :package_name => 'somepackage',
          :package_version => '1.2.3',
          :file_path => '/tmp',
          :force => true,
          :_retries => {
            :max_tries => 60,
            :base_sleep_seconds => 2,
            :max_sleep_seconds => 2
          }}).and_return(mock_result_list_all_not_installed)

      mock_data_list_all_uploaded = Nokogiri::XML(
        '<packages>' \
        '  <package>' \
        '    <group>somepackagegroup</group>' \
        '    <name>somepackage</name>' \
        '    <version>1.2.3</version>' \
        '  </package>' \
        '</packages>')
      mock_result_list_all_uploaded = double('mock_result_list_all_uploaded')
      expect(mock_result_list_all_uploaded).to receive(:data).and_return(mock_data_list_all_uploaded)

      expect(@mock_client).to receive(:call).once().with(
        RubyAem::Resources::Package,
        'list_all',
        { :group_name => 'somepackagegroup',
          :package_name => 'somepackage',
          :package_version => '1.2.3',
          :file_path => '/tmp',
          :force => true,
          :_retries => {
            :max_tries => 60,
            :base_sleep_seconds => 2,
            :max_sleep_seconds => 2
          }}).and_return(mock_result_list_all_uploaded)

      expect(STDOUT).to receive(:puts).with('Upload check #1: false - Package somepackagegroup/somepackage-1.2.3 is not uploaded')
      expect(STDOUT).to receive(:puts).with('Upload check #2: true - Package somepackagegroup/somepackage-1.2.3 is uploaded')

      @package.upload_wait_until_ready('/tmp', {
        force: true,
        _retries: {
          max_tries: 60,
          base_sleep_seconds: 2,
          max_sleep_seconds: 2
        }
      })
    end

  end

  describe 'test install_wait_until_ready' do

    it 'should call client with expected parameters' do
      expect(@mock_client).to receive(:call).once().with(
        RubyAem::Resources::Package,
        'install',
        { :group_name => 'somepackagegroup',
          :package_name => 'somepackage',
          :package_version => '1.2.3',
          :recursive => true })

      mock_data_list_all_not_installed = Nokogiri::XML(
        '<packages>' \
        '  <package>' \
        '    <group>somepackagegroup</group>' \
        '    <name>somepackage</name>' \
        '    <version>1.2.3</version>' \
        '    <lastUnpackedBy>null</lastUnpackedBy>' \
        '  </package>' \
        '</packages>')
      mock_result_list_all_not_installed = double('mock_result_list_all_not_installed')
      expect(mock_result_list_all_not_installed).to receive(:data).and_return(mock_data_list_all_not_installed)

      expect(@mock_client).to receive(:call).once().with(
        RubyAem::Resources::Package,
        'list_all',
        { :group_name => 'somepackagegroup',
          :package_name => 'somepackage',
          :package_version => '1.2.3',
          :recursive => true }).and_return(mock_result_list_all_not_installed)

      mock_data_list_all_installed = Nokogiri::XML(
        '<packages>' \
        '  <package>' \
        '    <group>somepackagegroup</group>' \
        '    <name>somepackage</name>' \
        '    <version>1.2.3</version>' \
        '    <lastUnpackedBy>admin</lastUnpackedBy>' \
        '  </package>' \
        '</packages>')
      mock_result_list_all_installed = double('mock_result_list_all')
      expect(mock_result_list_all_installed).to receive(:data).and_return(mock_data_list_all_installed)

      expect(@mock_client).to receive(:call).once().with(
        RubyAem::Resources::Package,
        'list_all',
        { :group_name => 'somepackagegroup',
          :package_name => 'somepackage',
          :package_version => '1.2.3',
          :recursive => true }).and_return(mock_result_list_all_installed)

      expect(STDOUT).to receive(:puts).with('Install check #1: false - Package somepackagegroup/somepackage-1.2.3 is not installed')
      expect(STDOUT).to receive(:puts).with('Install check #2: true - Package somepackagegroup/somepackage-1.2.3 is installed')

      @package.install_wait_until_ready
    end

    describe 'test delete_wait_until_ready' do

      it 'should call client with expected parameters' do
        expect(@mock_client).to receive(:call).once().with(
          RubyAem::Resources::Package,
          'delete',
          { :group_name => 'somepackagegroup',
            :package_name => 'somepackage',
            :package_version => '1.2.3' })

        mock_data_list_all_uploaded = Nokogiri::XML(
          '<packages>' \
          '  <package>' \
          '    <group>somepackagegroup</group>' \
          '    <name>somepackage</name>' \
          '    <version>1.2.3</version>' \
          '  </package>' \
          '</packages>')
        mock_result_list_all_uploaded = double('mock_result_list_all_uploaded')
        expect(mock_result_list_all_uploaded).to receive(:data).and_return(mock_data_list_all_uploaded)

        expect(@mock_client).to receive(:call).once().with(
          RubyAem::Resources::Package,
          'list_all',
          { :group_name => 'somepackagegroup',
            :package_name => 'somepackage',
            :package_version => '1.2.3' }).and_return(mock_result_list_all_uploaded)

        mock_data_list_all_not_uploaded = Nokogiri::XML(
          '<packages>' \
          '</packages>')
        mock_result_list_all_not_uploaded = double('mock_result_list_all_not_uploaded')
        expect(mock_result_list_all_not_uploaded).to receive(:data).and_return(mock_data_list_all_not_uploaded)

        expect(@mock_client).to receive(:call).once().with(
          RubyAem::Resources::Package,
          'list_all',
          { :group_name => 'somepackagegroup',
            :package_name => 'somepackage',
            :package_version => '1.2.3' }).and_return(mock_result_list_all_not_uploaded)

        expect(STDOUT).to receive(:puts).with('Delete check #1: false - Package somepackagegroup/somepackage-1.2.3 is uploaded')
        expect(STDOUT).to receive(:puts).with('Delete check #2: true - Package somepackagegroup/somepackage-1.2.3 is not uploaded')

        @package.delete_wait_until_ready
      end
    end

  end

end
