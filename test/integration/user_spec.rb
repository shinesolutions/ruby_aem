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

  end

end
