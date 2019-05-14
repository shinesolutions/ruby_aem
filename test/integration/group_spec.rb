require_relative 'spec_helper'

describe 'Group' do
  before do
    @aem = init_client

    # ensure group doesn't exist prior to testing
    @group = @aem.group('/home/groups/s/', 'somegroup')
    @group.delete unless @group.exists.data == false
    result = @group.exists
    expect(result.data).to eq(false)

    # create group
    result = @group.create
    expect(result.message).to match(%r{^Group somegroup created at /home/groups/s/.+})
  end

  after do
  end

  describe 'test group create' do
    it 'should succeed existence check' do
      result = @group.exists
      expect(result.message).to match(%r{^Group somegroup exists at /home/groups/s/.+})
      expect(result.data).to eq(true)
    end

    it 'should succeed permission setting' do
      result = @group.set_permission('/etc/replication', 'read:true,modify:true')
      expect(result.message).to eq('Permission read:true,modify:true on path /etc/replication set for group somegroup')
    end

    it 'should succeed adding another group as a member' do
      # ensure member group doesn't exist prior to testing
      member_group = @aem.group('/home/groups/s/', 'somemembergroup')
      member_group.delete unless member_group.exists.data == false
      result = member_group.exists
      expect(result.data).to eq(false)

      # create member group
      result = member_group.create
      expect(result.message).to match(%r{^Group somemembergroup created at /home/groups/s/.+})

      # ensure member group exists
      result = member_group.exists
      expect(result.message).to match(%r{^Group somemembergroup exists at /home/groups/s/.+})
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
      raise
    rescue RubyAem::Error => e
      expect(e.message).to match(/^Unexpected response/)
    end
  end
end
