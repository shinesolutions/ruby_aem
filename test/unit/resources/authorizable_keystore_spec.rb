require_relative '../spec_helper'
require_relative '../../../lib/ruby_aem/resources/authorizable_keystore'

describe 'AuthorizableKeystore' do
  before do
    @mock_client = double('mock_client')
    @authorizable_keystore = RubyAem::Resources::AuthorizableKeystore.new(@mock_client, '/home/users/s', 'someauthorizableid')
  end

  after do
  end

  describe 'test create' do
    it 'should call client with expected parameters' do
      expect(@mock_client).to receive(:call).once.with(
        RubyAem::Resources::AuthorizableKeystore,
        'create',
        intermediate_path: '/home/users/s',
        authorizable_id: 'someauthorizableid',
        password: 's0m3p4ssw0rd'
      )
      @authorizable_keystore.create('s0m3p4ssw0rd')
    end
  end

  describe 'test change password' do
    it 'should call client with expected parameters' do
      expect(@mock_client).to receive(:call).once.with(
        RubyAem::Resources::AuthorizableKeystore,
        'change_password',
        intermediate_path: '/home/users/s',
        authorizable_id: 'someauthorizableid',
        old_password: 's0m30ldp4ssw0rd',
        new_password: 's0m3n3wp4ssw0rd'
      )
      @authorizable_keystore.change_password('s0m30ldp4ssw0rd', 's0m3n3wp4ssw0rd')
    end
  end

  describe 'test delete' do
    it 'should call client with expected parameters' do
      expect(@mock_client).to receive(:call).once.with(
        RubyAem::Resources::AuthorizableKeystore,
        'delete',
        intermediate_path: '/home/users/s',
        authorizable_id: 'someauthorizableid'
      )
      @authorizable_keystore.delete
    end
  end

  describe 'test exists' do
    it 'should call client with expected parameters' do
      expect(@mock_client).to receive(:call).once.with(
        RubyAem::Resources::AuthorizableKeystore,
        'exists',
        intermediate_path: '/home/users/s',
        authorizable_id: 'someauthorizableid'
      )
      @authorizable_keystore.exists
    end
  end

  describe 'test info' do
    it 'should call client with expected parameters' do
      expect(@mock_client).to receive(:call).once.with(
        RubyAem::Resources::AuthorizableKeystore,
        'info',
        intermediate_path: '/home/users/s',
        authorizable_id: 'someauthorizableid'
      )
      @authorizable_keystore.info
    end
  end

  describe 'test download' do
    it 'should call client with expected parameters' do
      expect(@mock_client).to receive(:call).once.with(
        RubyAem::Resources::AuthorizableKeystore,
        'download',
        intermediate_path: '/home/users/s',
        authorizable_id: 'someauthorizableid',
        file_path: '/somepath'
      )
      @authorizable_keystore.download('/somepath')
    end
  end
end
