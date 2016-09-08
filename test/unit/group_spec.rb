require_relative 'spec_helper'
require_relative '../../lib/ruby_aem/group'

describe 'Group' do
  before do
    @mock_client = double('mock_client')
    @group = RubyAem::Group.new(@mock_client, '/home/groups/s/', 'somegroup')
  end

  after do
  end

  describe 'test create' do

    it 'should call client with expected parameters' do
      expect(@mock_client).to receive(:call).once().with(
        RubyAem::Group,
        'create',
        { :path => '/home/groups/s/', :name => 'somegroup' })
      @group.create
    end

    it 'should ensure that path has a leading slash' do
      expect(@mock_client).to receive(:call).once().with(
        RubyAem::Group,
        'create',
        { :path => '/home/groups/s/', :name => 'somegroup' })
      group = RubyAem::Group.new(@mock_client, 'home/groups/s/', 'somegroup')
      group.create
    end

  end
  #
  # describe 'test delete' do
  #
  #   it 'should call client with expected parameters' do
  #     expect(@mock_client).to receive(:call).once().with(
  #       RubyAem::Group,
  #       'create',
  #       { :path => '/home/groups/s/', :name => 'somegroup' })
  #     @group.create
  #   end
  #
  #   it 'should return result when authorizable ID cannot be found' do
  #     expect(@mock_client).to receive(:call).once().with(
  #       RubyAem::Group,
  #       'create',
  #       { :path => '/home/groups/s/', :name => 'somegroup' })
  #     group = RubyAem::Group.new(@mock_client, 'home/groups/s/', 'somegroup')
  #     group.create
  #   end
  #
  # end

  describe 'test find_authorizable_id' do

    it 'should call client with expected parameters' do
      expect(@mock_client).to receive(:call).once().with(
        RubyAem::Group,
        'find_authorizable_id',
        { :path => '/home/groups/s/',
          :name => 'somegroup' })
      @group.find_authorizable_id
    end

  end

end
