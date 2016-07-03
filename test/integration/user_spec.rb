require_relative 'spec_helper'

describe 'User' do
  before do
    @aem = init_client

    # ensure user doesn't exist prior to testing
    @user = @aem.user('/home/users/s/', 'someuser')
    result = @user.delete()
    expect(result.is_success?).to be(true)

    # create user
    result = @user.create('somepassword')
    expect(result.is_success?).to be(true)
    expect(result.message).to match(/^User someuser created at \/home\/users\/s\/.+/)
  end

  after do
  end

  describe 'test user create' do

    it 'should succeed existence check' do
      result = @user.exists()
      expect(result.is_success?).to be(true)
      expect(result.message).to match(/^User someuser exists at \/home\/users\/s\/.+/)
    end

    it 'should succeed permission setting' do
      result = @user.set_permission('/etc/replication', 'read:true,modify:true')
      expect(result.is_success?).to be(true)
      expect(result.message).to eq('Permission read:true,modify:true on path /etc/replication set for user someuser')
    end

    it 'should succeed admin password change' do
      result = @user.change_password('admin', 'admin')
      expect(result.is_success?).to be(true)
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
      expect(result.is_success?).to be(true)
      expect(result.message).to eq('Logged in user password changed')    end

      it 'should succeed being added to a group' do

        # TODO: implement after group implementation is done
        # # ensure group doesn't exist prior to testing
        # group_authorizable_id = find_authorizable_id(@sling, '/home/groups/s', 'somegroup')
        # if group_authorizable_id
        #   data, status_code, headers = @sling.delete_node_with_http_info(
        #     path = 'home/groups/s',
        #     name = group_authorizable_id
        #   )
        #   expect(status_code).to eq(204)
        # end
        #
        # # create group
        # data, status_code, headers = @sling.post_authorizables_with_http_info(
        #   authorizable_id = 'somegroup',
        #   intermediate_path = '/home/groups/s',
        #   {
        #     :create_group => '',
        #     :profilegiven_name => 'somegroup'
        #   }
        # )
        # expect(status_code).to eq(201)
        # group_authorizable_id = find_authorizable_id(@sling, '/home/groups/s', 'somegroup')
        #
        # # add user as member to the group
        # data, status_code, headers = @sling.post_node_rw_with_http_info(
        #   path = 'home/groups/s',
        #   name = group_authorizable_id,
        #   {
        #     :add_members => 'someuser'
        #   }
        # )
        # expect(status_code).to eq(200)

      end

  end

end
