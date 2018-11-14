require_relative 'spec_helper'

describe 'AuthorizableKeystore' do
  before do
    @aem = init_client

    # ensure authorizable_keystore doesn't exist prior to testing
    @authorizable_keystore = @aem.authorizable_keystore('/home/users/system', 'authentication-service')
    @authorizable_keystore.delete unless @authorizable_keystore.exists.data == false
    result = @authorizable_keystore.exists
    expect(result.data).to eq(false)

    # create authorizable_keystore
    result = @authorizable_keystore.create('s0m3p4ssw0rd')
    expect(result.message).to eq('Authorizable keystore created')
  end

  after do
  end

  describe 'test authorizable_keystore create' do
    it 'should return true on existence check' do
      result = @authorizable_keystore.exists
      expect(result.message).to eq('Authorizable keystore exists')
      expect(result.data).to eq(true)
    end
  end

  describe 'test authorizable keystore delete' do
    it 'should succeed when authorizable keystore exists' do
      result = @authorizable_keystore.exists
      expect(result.message).to eq('Authorizable keystore exists')
      expect(result.data).to eq(true)

      result = @authorizable_keystore.delete
      expect(result.message).to eq('Authorizable keystore deleted')

      result = @authorizable_keystore.exists
      expect(result.message).to eq('Authorizable keystore not found')
      expect(result.data).to eq(false)
    end

    it 'should raise error when authorizable keystore does not exist' do
      result = @authorizable_keystore.exists
      expect(result.message).to eq('Authorizable keystore exists')
      expect(result.data).to eq(true)

      result = @authorizable_keystore.delete
      expect(result.message).to eq('Authorizable keystore deleted')

      result = @authorizable_keystore.exists
      expect(result.message).to eq('Authorizable keystore not found')
      expect(result.data).to eq(false)

      begin
        @authorizable_keystore.delete
        raise
      rescue RubyAem::Error => err
        expect(err.result.message).to eq('Authorizable keystore not found')
      end
    end
  end

  describe 'test authorizable keystore change password' do
    it 'should return true on existence check' do
      result = @authorizable_keystore.change_password('s0m3p4ssw0rd', 's0m3n3wp4ssw0rd')
      expect(result.message).to eq('Authorizable keystore password successfully changed')
    end
  end
end
