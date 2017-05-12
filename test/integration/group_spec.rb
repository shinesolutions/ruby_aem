require_relative 'spec_helper'

describe 'Group' do
  before do
    @aem = init_client

    # ensure group doesn't exist prior to testing
    @group = @aem.group('/home/groups/s/', 'somegroup')
    if @group.exists().data == true
      @group.delete()
    end
    result = @group.exists()
    expect(result.data).to eq(false)

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
      expect(result.data).to eq(true)
    end

    it 'should succeed permission setting' do
      result = @group.set_permission('/etc/replication', 'read:true,modify:true')
      expect(result.message).to eq('Permission read:true,modify:true on path /etc/replication set for group somegroup')
    end

    it 'should succeed adding another group as a member' do

      # ensure member group doesn't exist prior to testing
      member_group = @aem.group('/home/groups/s/', 'somemembergroup')
      if member_group.exists().data == true
        member_group.delete()
      end
      result = member_group.exists()
      expect(result.data).to eq(false)

      # create member group
      result = member_group.create()
      expect(result.message).to match(/^Group somemembergroup created at \/home\/groups\/s\/.+/)

      # ensure member group exists
      result = member_group.exists()
      expect(result.message).to match(/^Group somemembergroup exists at \/home\/groups\/s\/.+/)
      expect(result.data).to eq(true)

      # add user as member to the group
      result = @group.add_member('somemembergroup')
      expect(result.message).to eq('User/group somemembergroup added to group somegroup')
    end

  end

  it 'should raise error when deleting inexisting group' do
    group = @aem.group('/home/groups/s/', 'someinexistinggroup')
    begin
      group.set_permission('/etc/replication', 'read:true,modify:true')
      fail
    rescue RubyAem::Error => err
      expect(err.message).to match(/^Unexpected response/)
    end
  end

end
