require 'yaml'

gem_conf = YAML.load_file('conf/gem.yaml')

Gem::Specification.new do |s|
  s.name              = 'ruby_aem'
  s.version           = gem_conf['version']
  s.platform          = Gem::Platform::RUBY
  s.authors           = ['Shine Solutions', 'Cliffano Subagio']
  s.email             = ['opensource@shinesolutions.com', 'cliffano@gmail.com']
  s.homepage          = 'https://github.com/shinesolutions/ruby_aem'
  s.summary           = 'AEM API Ruby client'
  s.description       = 'ruby_aem is a Ruby client for Adobe Experience Manager (AEM) API, written on top of swagger_aem'
  s.license           = 'Apache-2.0'
  s.required_ruby_version = '>= 3.2'
  s.files             = Dir.glob('{conf,lib}/**/*')
  s.require_paths     = ['lib']

  s.add_dependency 'retries', '0.0.5'
  s.add_dependency 'swagger_aem', '4.0.0'
  s.add_dependency 'swagger_aem_osgi', '2.0.0'
end
