require 'ruby_aem'

def init_client
  RubyAem::Aem.new(
    username: 'admin',
    password: 'admin',
    protocol: 'http',
    host: 'localhost',
    port: 4502,
    debug: false
  )
end
