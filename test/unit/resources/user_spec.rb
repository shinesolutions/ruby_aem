require_relative '../spec_helper'
require_relative '../../../lib/ruby_aem/resources/user'

describe 'User' do
  before do
    @mock_client = double('mock_client')
    @mock_result = double('mock_result')
    @user = RubyAem::Resources::User.new(@mock_client, '/home/users/s/', 'someuser')
  end

  after do
  end

  describe 'test create' do

    it 'should call client with expected parameters' do
      expect(@mock_client).to receive(:call).once().with(
        RubyAem::Resources::User,
        'create',
        { :path => '/home/users/s/',
          :name => 'someuser',
          :password => 'somepassword' })
      @user.create('somepassword')
    end

    it 'should ensure that path has a leading slash' do
      expect(@mock_client).to receive(:call).once().with(
        RubyAem::Resources::User,
        'create',
        { :path => '/home/users/s/',
          :name => 'someuser',
          :password => 'somepassword' })
      user = RubyAem::Resources::User.new(@mock_client, 'home/users/s/', 'someuser')
      user.create('somepassword')
    end

  end

  describe 'test delete' do

    it 'should call client with expected parameters' do
      expect(@mock_result).to receive(:data).and_return('someauthorizableid')
      expect(@mock_client).to receive(:call).once().with(
        RubyAem::Resources::User,
        'find_authorizable_id',
        { :path => '/home/users/s/',
          :name => 'someuser' }).and_return(@mock_result)
      expect(@mock_client).to receive(:call).once().with(
        RubyAem::Resources::User,
        'delete',
        { :path => 'home/users/s', :name => 'someuser', :authorizable_id => 'someauthorizableid' })
      @user.delete
    end

    it 'should call client with nil authorizable ID when authorizable ID cannot be found' do
      expect(@mock_result).to receive(:data).and_return(nil)
      expect(@mock_client).to receive(:call).once().with(
        RubyAem::Resources::User,
        'find_authorizable_id',
        { :path => '/home/users/s/',
          :name => 'someuser' }).and_return(@mock_result)
      expect(@mock_client).to receive(:call).once().with(
        RubyAem::Resources::User,
        'delete',
        { :path => 'home/users/s', :name => 'someuser', :authorizable_id => nil })
      @user.delete
    end

  end

  describe 'test exists' do

    it 'should call client with expected parameters' do
      expect(@mock_result).to receive(:data).and_return('someauthorizableid')
      expect(@mock_client).to receive(:call).once().with(
        RubyAem::Resources::User,
        'find_authorizable_id',
        { :path => '/home/users/s/',
          :name => 'someuser' }).and_return(@mock_result)
      expect(@mock_client).to receive(:call).once().with(
        RubyAem::Resources::User,
        'exists',
        { :path => 'home/users/s', :name => 'someuser', :authorizable_id => 'someauthorizableid' })
      @user.exists
    end

  end

  describe 'test set_permission' do

    it 'should call client with expected parameters' do
      expect(@mock_client).to receive(:call).once().with(
        RubyAem::Resources::User,
        'set_permission',
        { :path => '/home/users/s/',
          :name => 'someuser',
          :permission_path => '/etc/replication',
          :permission_csv => 'read:true,modify:true' })
      @user.set_permission('/etc/replication', 'read:true,modify:true')
    end

  end

  describe 'test add_to_group' do

    it 'should call client with expected parameters' do
      expect(@mock_result).to receive(:data).and_return('someauthorizableid')
      expect(@mock_client).to receive(:call).once().with(
        RubyAem::Resources::Group,
        'find_authorizable_id',
        { :path => '/home/groups/s/',
          :name => 'somegroup' }).and_return(@mock_result)
      expect(@mock_client).to receive(:call).once().with(
        RubyAem::Resources::Group,
        'add_member',
        { :path => 'home/groups/s', :name => 'somegroup', :member => 'someuser', :authorizable_id => 'someauthorizableid' })
      @user.add_to_group('/home/groups/s/', 'somegroup')
    end

  end

  describe 'test change_password' do

    it 'should call client with expected parameters' do
      expect(@mock_client).to receive(:call).once().with(
        RubyAem::Resources::User,
        'change_password',
        { :path => '/home/users/s/',
          :name => 'someuser',
          :old_password => 'someoldpassword',
          :new_password => 'somenewpassword' })
      @user.change_password('someoldpassword', 'somenewpassword')
    end

  end

  describe 'test find_authorizable_id' do

    it 'should call client with expected parameters' do
      expect(@mock_client).to receive(:call).once().with(
        RubyAem::Resources::User,
        'find_authorizable_id',
        { :path => '/home/users/s/',
          :name => 'someuser' })
      @user.find_authorizable_id
    end

    it 'should prepend leading slash when path does not have one' do
      user = RubyAem::Resources::User.new(@mock_client, 'home/users/s/', 'someuser')
      expect(@mock_client).to receive(:call).once().with(
        RubyAem::Resources::User,
        'find_authorizable_id',
        { :path => '/home/users/s/',
          :name => 'someuser' })
      user.find_authorizable_id
    end

  end

end
