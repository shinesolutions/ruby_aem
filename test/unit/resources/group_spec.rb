require_relative '../spec_helper'
require_relative '../../../lib/ruby_aem/resources/group'

describe 'Group' do
  before do
    @mock_client = double('mock_client')
    @mock_result = double('mock_result')
    @group = RubyAem::Resources::Group.new(@mock_client, '/home/groups/s/', 'somegroup')
  end

  after do
  end

  describe 'test create' do

    it 'should call client with expected parameters' do
      expect(@mock_client).to receive(:call).once().with(
        RubyAem::Resources::Group,
        'create',
        { :path => '/home/groups/s/', :name => 'somegroup' })
      @group.create
    end

    it 'should ensure that path has a leading slash' do
      expect(@mock_client).to receive(:call).once().with(
        RubyAem::Resources::Group,
        'create',
        { :path => '/home/groups/s/', :name => 'somegroup' })
      group = RubyAem::Resources::Group.new(@mock_client, 'home/groups/s/', 'somegroup')
      group.create
    end

  end

  describe 'test delete' do

    it 'should call client with expected parameters' do
      expect(@mock_result).to receive(:data).and_return('someauthorizableid')
      expect(@mock_client).to receive(:call).once().with(
        RubyAem::Resources::Group,
        'find_authorizable_id',
        { :path => '/home/groups/s/',
          :name => 'somegroup' }).and_return(@mock_result)
      expect(@mock_client).to receive(:call).once().with(
        RubyAem::Resources::Group,
        'delete',
        { :path => 'home/groups/s', :name => 'somegroup' })
      @group.delete
    end

    it 'should return result when authorizable ID cannot be found' do
      expect(@mock_result).to receive(:data).and_return(nil)
      expect(@mock_client).to receive(:call).once().with(
        RubyAem::Resources::Group,
        'find_authorizable_id',
        { :path => '/home/groups/s/',
          :name => 'somegroup' }).and_return(@mock_result)
      @group.delete
    end

  end

  describe 'test exists' do

    it 'should call client with expected parameters' do
      expect(@mock_client).to receive(:call).once().with(
        RubyAem::Resources::Group,
        'exists',
        { :path => 'home/groups/s', :name => 'somegroup' })
      @group.exists
    end

  end

  describe 'test set_permission' do

    it 'should call client with expected parameters' do
      expect(@mock_client).to receive(:call).once().with(
        RubyAem::Resources::Group,
        'set_permission',
        { :path => '/home/groups/s/',
          :name => 'somegroup',
          :permission_path => '/etc/replication',
          :permission_csv => 'read:true,modify:true' })
      @group.set_permission('/etc/replication', 'read:true,modify:true')
    end

  end

  describe 'test add_member' do

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
        { :path => '/home/groups/s/', :name => 'somegroup', :member => 'somemembergroup' })
      @group.add_member('somemembergroup')
    end

    it 'should return result when authorizable ID cannot be found' do
      expect(@mock_result).to receive(:data).and_return(nil)
      expect(@mock_client).to receive(:call).once().with(
        RubyAem::Resources::Group,
        'find_authorizable_id',
        { :path => '/home/groups/s/',
          :name => 'somegroup' }).and_return(@mock_result)
      @group.add_member('somemembergroup')
    end

  end

  describe 'test find_authorizable_id' do

    it 'should call client with expected parameters' do
      expect(@mock_client).to receive(:call).once().with(
        RubyAem::Resources::Group,
        'find_authorizable_id',
        { :path => '/home/groups/s/',
          :name => 'somegroup' })
      @group.find_authorizable_id
    end

  end

end
