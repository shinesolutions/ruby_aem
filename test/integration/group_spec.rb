require_relative 'spec_helper'

describe 'Group' do
  before do
    @aem = init_client

    # ensure group doesn't exist prior to testing
    @group = @aem.group('/home/groups/s/', 'somegroup')
    result = @group.delete()

    # create group
    result = @group.create()
    expect(result.message).to match(/^Group somegroup created at \/home\/groups\/s\/.+/)
  end

  after do
  end

  describe 'test group create' do

    it 'should succeed existence check' do
      result = @group.exists()
      expect(result.message).to match(/^Group somegroup exists at \/home\/groups\/s\/.+/)
    end

    it 'should succeed permission setting' do
      result = @group.set_permission('/etc/replication', 'read:true,modify:true')
      expect(result.message).to eq('Permission read:true,modify:true on path /etc/replication set for group somegroup')
    end

    it 'should succeed adding another group as a member' do

      # ensure member group doesn't exist prior to testing
      member_group = @aem.group('/home/groups/s/', 'somemembergroup')
      result = member_group.delete()

      # create member group
      result = member_group.create()
      expect(result.message).to match(/^Group somemembergroup created at \/home\/groups\/s\/.+/)

      # add user as member to the group
      result = @group.add_member('somemembergroup')
      expect(result.message).to eq('User/group somemembergroup added to group somegroup')
    end

  end

end
