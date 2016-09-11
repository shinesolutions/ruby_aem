require_relative 'spec_helper'
require_relative '../../lib/ruby_aem/user'

describe 'User' do
  before do
    @mock_client = double('mock_client')
    @user = RubyAem::User.new(@mock_client, '/home/users/s/', 'someuser')
  end

  after do
  end

  describe 'test create' do

    it 'should call client with expected parameters' do
      expect(@mock_client).to receive(:call).once().with(
        RubyAem::User,
        'create',
        { :path => '/home/users/s/',
          :name => 'someuser',
          :password => 'somepassword' })
      @user.create('somepassword')
    end

  end
  
  describe 'test find_authorizable_id' do

    it 'should call client with expected parameters' do
      expect(@mock_client).to receive(:call).once().with(
        RubyAem::User,
        'find_authorizable_id',
        { :path => '/home/users/s/',
          :name => 'someuser' })
      @user.find_authorizable_id
    end

  end

end
