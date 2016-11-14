require_relative 'spec_helper'

describe 'FlushAgent' do
  before do
    @aem = init_client

    # ensure agent doesn't exist prior to testing
    @flush_agent = @aem.flush_agent('author', 'some-flush-agent')
    result = @flush_agent.delete()

    # create agent
    result = @flush_agent.create_update('Some Flush Agent Title', 'Some flush agent description', 'http://somehost:8080')
    expect(result.message).to eq('Flush agent some-flush-agent created on author')
  end

  after do
  end

  describe 'test flush agent create update' do

    it 'should succeed existence check' do
      result = @flush_agent.exists()
      expect(result.message).to eq('Flush agent some-flush-agent exists on author')
      expect(result.data).to eq(true)
    end

    it 'should succeed update' do
      result = @flush_agent.create_update('Some Updated Flush Agent Title', 'Some updated flush agent description', 'https://someotherhost:8081')
      expect(result.message).to eq('Flush agent some-flush-agent updated on author')
    end

  end

  describe 'test flush agent delete' do

    it 'should succeed existence check' do
      result = @flush_agent.delete()
      expect(result.message).to eq('Flush agent some-flush-agent deleted on author')

      result = @flush_agent.exists()
      expect(result.message).to eq('Flush agent some-flush-agent not found on author')
      expect(result.data).to eq(false)
    end

  end

end
