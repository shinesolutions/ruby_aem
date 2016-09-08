require_relative 'spec_helper'
require_relative '../../lib/ruby_aem/result'

describe 'Result' do
  before do
  end

  after do
  end

  describe 'test initialize' do

    it 'should have message and data' do
      result = RubyAem::Result.new('success', 'somemessage')
      result.data = 'somedata'
      expect(result.message).to eq('somemessage')
      expect(result.data).to eq('somedata')
    end

  end

  describe 'test is_success' do

    it 'should be true when status is success' do
      result = RubyAem::Result.new('success', 'somemessage')
      expect(result.is_success?).to be(true)
    end

    it 'should be false when status is not success' do
      result = RubyAem::Result.new('warning', 'somemessage')
      expect(result.is_success?).to be(false)
    end

  end

  describe 'test is_warning' do

    it 'should be true when status is warning' do
      result = RubyAem::Result.new('warning', 'somemessage')
      expect(result.is_warning?).to be(true)
    end

    it 'should be false when status is not warning' do
      result = RubyAem::Result.new('failure', 'somemessage')
      expect(result.is_warning?).to be(false)
    end

  end

  describe 'test is_failure' do

    it 'should be true when status is failure' do
      result = RubyAem::Result.new('failure', 'somemessage')
      expect(result.is_failure?).to be(true)
    end

    it 'should be false when status is not failure' do
      result = RubyAem::Result.new('success', 'somemessage')
      expect(result.is_failure?).to be(false)
    end

  end

end
