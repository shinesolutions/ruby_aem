require 'ruby_aem'

def init_client
  RubyAem::Aem.new(
    username: ENV['aem_username'] || 'admin',
    password: ENV['aem_password'] || 'admin',
    protocol: ENV['aem_protocol'] || 'http',
    host: ENV['aem_host'] || 'localhost',
    port: ENV['aem_port'] ? ENV['aem_port'].to_i : 4502,
    debug: ENV['aem_debug'] ? ENV['aem_debug'] == 'true' : false
  )
end
