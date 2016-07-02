Gem::Specification.new do |s|
  s.name              = 'ruby_aem'
  s.version           = '0.0.1'
  s.platform          = Gem::Platform::RUBY
  s.authors           = ['Cliffano Subagio']
  s.email             = ['']
  s.homepage          = 'https://github.com/shinesolutions/ruby_aem'
  s.summary           = 'AEM API Ruby client'
  s.description       = 'Ruby client for Adobe Experience Manager (AEM) API, written on top of Swagger AEM'
  s.license           = 'Apache 2.0'
  s.files             = Dir.glob("{conf,lib}/**/*")
  s.require_paths     = ['lib']
end
