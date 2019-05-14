require_relative 'spec_helper'

describe 'FlushAgent' do
  before do
    @aem = init_client

    # ensure agent doesn't exist prior to testing
    @flush_agent = @aem.flush_agent('author', 'some-flush-agent')
    @flush_agent.delete unless @flush_agent.exists.data == false
    result = @flush_agent.exists
    expect(result.data).to eq(false)

    # create agent
    result = @flush_agent.create_update('Some Flush Agent Title', 'Some flush agent description', 'http://somehost:8080')
    expect(result.message).to eq('Flush agent some-flush-agent created on author')
  end

  after do
  end

  describe 'test flush agent create update' do
    it 'should return true on existence check' do
      result = @flush_agent.exists
      expect(result.message).to eq('Flush agent some-flush-agent exists on author')
      expect(result.data).to eq(true)
    end

    it 'should succeed update' do
      result = @flush_agent.create_update('Some Updated Flush Agent Title', 'Some updated flush agent description', 'https://someotherhost:8081')
      expect(result.message).to eq('Flush agent some-flush-agent updated on author')
    end
  end

  describe 'test flush agent delete' do
    it 'should succeed when flush agent exists' do
      result = @flush_agent.delete
      expect(result.message).to eq('Flush agent some-flush-agent deleted on author')

      result = @flush_agent.exists
      expect(result.message).to eq('Flush agent some-flush-agent not found on author')
      expect(result.data).to eq(false)
    end

    it 'should raise error when flush agent does not exist' do
      flush_agent = @aem.flush_agent('author', 'some-inexisting-flush-agent')
      begin
        flush_agent.delete
        raise
      rescue RubyAem::Error => e
        expect(e.result.message).to eq('Flush agent some-inexisting-flush-agent not found on author')
      end
    end
  end
end
