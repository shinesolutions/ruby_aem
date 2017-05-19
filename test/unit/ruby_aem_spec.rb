require_relative 'spec_helper'
require_relative '../../lib/ruby_aem'

describe 'RubyAem' do
  before do
  end

  after do
  end

  describe 'test initialize' do
    it 'should return client with resource methods' do
      aem = RubyAem::Aem.new
      expect(aem).to respond_to(:aem)
      expect(aem).to respond_to(:bundle)
      expect(aem).to respond_to(:config_property)
      expect(aem).to respond_to(:flush_agent)
      expect(aem).to respond_to(:group)
      expect(aem).to respond_to(:node)
      expect(aem).to respond_to(:package)
      expect(aem).to respond_to(:path)
      expect(aem).to respond_to(:replication_agent)
      expect(aem).to respond_to(:outbox_replication_agent)
      expect(aem).to respond_to(:reverse_replication_agent)
      expect(aem).to respond_to(:repository)
      expect(aem).to respond_to(:user)
    end
  end

  describe 'test aem' do
    it 'should return aem instance' do
      aem = RubyAem::Aem.new.aem
      expect(aem).to_not be(nil)
    end
  end

  describe 'test bundle' do
    it 'should return bundle instance' do
      bundle = RubyAem::Aem.new.bundle('com.adobe.cq.social.cq-social-forum')
      expect(bundle).to_not be(nil)
    end
  end

  describe 'test config property' do
    it 'should return config_property instance' do
      config_property = RubyAem::Aem.new.config_property('someproperty', 'Boolean', 'true')
      expect(config_property).to_not be(nil)
    end
  end

  describe 'test flush agent' do
    it 'should return flush agent instance' do
      flush_agent = RubyAem::Aem.new.flush_agent('author', 'some-flush-agent')
      expect(flush_agent).to_not be(nil)
    end
  end

  describe 'test group' do
    it 'should return group instance' do
      group = RubyAem::Aem.new.group('/home/groups/s/', 'somegroup')
      expect(group).to_not be(nil)
    end
  end

  describe 'test node' do
    it 'should return node instance' do
      node = RubyAem::Aem.new.node('/apps/system/', 'somefolder')
      expect(node).to_not be(nil)
    end
  end

  describe 'test package' do
    it 'should return package instance' do
      package = RubyAem::Aem.new.package('somepackagegroup', 'somepackage', '1.2.3')
      expect(package).to_not be(nil)
    end
  end

  describe 'test path' do
    it 'should return path instance' do
      path = RubyAem::Aem.new.path('/etc/designs/cloudservices')
      expect(path).to_not be(nil)
    end
  end

  describe 'test replication agent' do
    it 'should return replication agent instance' do
      replication_agent = RubyAem::Aem.new.replication_agent('author', 'some-replication-agent')
      expect(replication_agent).to_not be(nil)
    end
  end

  describe 'test outbox replication agent' do
    it 'should return outbox replication agent instance' do
      outbox_replication_agent = RubyAem::Aem.new.outbox_replication_agent('publish', 'some-outbox-replication-agent')
      expect(outbox_replication_agent).to_not be(nil)
    end
  end

  describe 'test reverse replication agent' do
    it 'should return reverse replication agent instance' do
      reverse_replication_agent = RubyAem::Aem.new.reverse_replication_agent('author', 'some-reverse-replication-agent')
      expect(reverse_replication_agent).to_not be(nil)
    end
  end

  describe 'test repository' do
    it 'should return repository instance' do
      repository = RubyAem::Aem.new.repository
      expect(repository).to_not be(nil)
    end
  end

  describe 'test user' do
    it 'should return user instance' do
      user = RubyAem::Aem.new.user('/home/users/s/', 'someuser')
      expect(user).to_not be(nil)
    end
  end
end
