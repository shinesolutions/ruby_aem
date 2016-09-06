require_relative '../../lib/ruby_aem/swagger'

describe 'Swagger' do
  before do
  end

  after do
  end

  describe 'test operation_to_method' do

    it 'should replace all uppercases with lowercases letters, each prefixed with an underscore' do
      method = RubyAem::Swagger.operation_to_method('postBundle')
      expect(method).to eq('post_bundle')
    end

    it 'should keep value as-is when operation does not have upppercase letter' do
      method = RubyAem::Swagger.operation_to_method('post')
      expect(method).to eq('post')
    end

  end

  describe 'test property_to_parameter' do

    it 'should replace all dots with underscores' do
      method = RubyAem::Swagger.property_to_parameter('foo.bar.foo')
      expect(method).to eq('foo_bar_foo')
    end

    it 'should keep value as-is when property does not have any dot' do
      method = RubyAem::Swagger.operation_to_method('foobarfoo')
      expect(method).to eq('foobarfoo')
    end

  end

  describe 'test path' do

    it 'should trim leading and trailing slashes' do
      method = RubyAem::Swagger.path('/path/to/')
      expect(method).to eq('path/to')
    end

    it 'should keep value as-is when path does not have leading and trailing slashes' do
      method = RubyAem::Swagger.path('path/to')
      expect(method).to eq('path/to')
    end

  end

end
