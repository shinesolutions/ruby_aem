#!/opt/puppetlabs/puppet/bin/ruby
# This tool usesruby_aem to generate the OpenAPI v3 specification
# for all configuration nodes located at /system/console/configMgr

require 'ruby_aem'

def call_usage
  puts 'aem_configmgr_openapi_generator.rb Usage:
  ./aem_configmgr_openapi_generator.rb --in conf/api.yml --out conf/api2.yml'
  exit 1
end

call_usage unless ARGV.length.eql?(4)
call_usage unless ARGV[0].eql?('--in')
call_usage unless ARGV[2].eql?('--out')

api_source_file = ARGV[1]
api_dest_file = ARGV[3]

client = RubyAem::Aem.new

configmgr = client.aem_configmgr(api_source_file, api_dest_file)
configmgr.get_all_configuration_nodes
