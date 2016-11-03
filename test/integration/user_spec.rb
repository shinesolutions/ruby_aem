require_relative 'spec_helper'

describe 'User' do
  before do
    @aem = init_client

    # ensure user doesn't exist prior to testing
    @user = @aem.user('/home/users/s/', 'someuser')
    result = @user.delete()

    # create user
    result = @user.create('somepassword')
    expect(result.message).to match(/^User someuser created at \/home\/users\/s\/.+/)
  end

  after do
  end

  describe 'test user create' do

    it 'should succeed existence check' do
      result = @user.exists()
      expect(result.message).to match(/^User someuser exists at \/home\/users\/s\/.+/)
    end

    it 'should succeed permission setting' do
      result = @user.set_permission('/etc/replication', 'read:true,modify:true')
      expect(result.message).to eq('Permission read:true,modify:true on path /etc/replication set for user someuser')
    end

    it 'should succeed admin password change' do
      result = @user.change_password('admin', 'admin')
      expect(result.message).to eq('Logged in user password changed')
    end

    it 'should succeed created user password change' do
      aem = RubyAem::Aem.new({
        :username => 'someuser',
        :password => 'somepassword',
        :protocol => 'http',
        :host => 'localhost',
        :port => 4502,
        :debug => false
      })
      user = aem.user('/home/users/s/', 'someuser')
      result = user.change_password('somepassword', 'somenewpassword')
      expect(result.message).to eq('Logged in user password changed')

    end

    it 'should succeed being added to a group' do

      # ensure group doesn't exist prior to testing
      group = @aem.group('/home/groups/s/', 'somegroup')
      result = group.delete()

      # create group
      result = group.create()
      expect(result.message).to match(/^Group somegroup created at \/home\/groups\/s\/.+/)

      # create group
      result = @user.add_to_group('/home/groups/s/', 'somegroup')
      expect(result.message).to eq('User/group someuser added to group somegroup')

    end

  end

end
