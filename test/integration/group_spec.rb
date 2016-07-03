require_relative 'spec_helper'

describe 'Group' do
  before do
    @aem = init_client

    # ensure group doesn't exist prior to testing
    @group = @aem.group('/home/groups/s/', 'somegroup')
    result = @group.delete()
    expect(result.is_success?).to be(true)

    # create group
    result = @group.create()
    expect(result.is_success?).to be(true)
    expect(result.message).to match(/^Group somegroup created at \/home\/groups\/s\/.+/)
  end

  after do
  end

  describe 'test group create' do

    it 'should succeed existence check' do
      result = @group.exists()
      expect(result.is_success?).to be(true)
      expect(result.message).to match(/^Group somegroup exists at \/home\/groups\/s\/.+/)
    end

    it 'should succeed permission setting' do
      result = @group.set_permission('/etc/replication', 'read:true,modify:true')
      expect(result.is_success?).to be(true)
      expect(result.message).to eq('Permission read:true,modify:true on path /etc/replication set for group somegroup')
    end

  end

end
