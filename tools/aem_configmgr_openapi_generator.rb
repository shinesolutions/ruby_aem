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

@client = RubyAem::Aem.new

@scheme = SwaggerAemClient.configure.scheme
@host = SwaggerAemClient.configure.host
@username = SwaggerAemClient.configure.username
@password = SwaggerAemClient.configure.password
@api_source_file = api_source_file
@api_dest_file = api_dest_file

def setup_config_node_post_schema(operation_id)
  {
    'post' => {
      'parameters' => [
        {
          'name' => 'post',
          'in' => 'query',
          'schema' => {
            'type' => 'boolean'
          }
        }, {
          'name' => 'apply',
          'in' => 'query',
          'schema' => {
            'type' => 'boolean'
          }
        }, {
          'name' => 'delete',
          'in' => 'query',
          'schema' => {
            'type' => 'boolean'
          }
        }, {
          'name' => 'action',
          'in' => 'query',
          'schema' => {
            'type' => 'string'
          }
        }, {
          'name' => '$location',
          'in' => 'query',
          'schema' => {
            'type' => 'string'
          }
        }, {
          'name' => 'propertylist',
          'in' => 'query',
          'style' => 'form',
          'explode' => 'false',
          'schema' => {
            'type' => 'array',
            'items' => {
              'type' => 'string'
            }
          }
        }

      ],
      'operationId' => operation_id,
      'tags' => [
        'console'
      ],
      'responses' => {
        '200' => {
          'description' => 'Successfully retrieved configuration parameters',
          'content' => {
            'application/json' => {
              'schema' => {
                '$ref' => "#/components/schemas/#{operation_id}Info"
              }
            }
          }
        },
        'default' => {
          'description' => 'Default response',
          'content' => {
            'application/json' => {
              'schema' => {
                'type' => 'string'
              }
            }
          }
        }
      }
    }
  }
end

# Setup configuration node property items schema
#
# @param Configuration node property item value
# @return Hash with configuration nodes property items schema
def setup_config_node_property_response_schema(config_node_property_type)
  {
    'type' => 'object',
    'properties' => {
      'name' => {
        'description' => 'property name',
        'type' => 'string'
      },
      'optional' => {
        'description' => 'True if optional',
        'type' => 'boolean'
      },
      'is_set' => {
        'description' => 'True if property is set',
        'type' => 'boolean'
      },
      'type' => {
        'description' => 'Property type, 1=String, 2=Long, 3=Integer, 7=Float, 11=Boolean, 12=Secrets(String)',
        'type' => 'integer'
      },
      'values' => config_node_property_type,
      'description' => {
        'description' => 'Property description',
        'type' => 'string'
      }
    }
  }
end

# Setup configuration node property items schema for
# property items with a drop down menu
#
# @param Configuration node property item value
# @return Hash with configuration nodes property items schema
def setup_config_node_property_response_dropdown_schema(config_node_property_type)
  {
    'type' => 'object',
    'properties' => {
      'name' => {
        'description' => 'property name',
        'type' => 'string'
      },
      'optional' => {
        'description' => 'True if optional',
        'type' => 'boolean'
      },
      'is_set' => {
        'description' => 'True if property is set',
        'type' => 'boolean'
      },
      'type' => config_node_property_type,
      'value' => {
        'description' => 'Property value',
        'type' => 'array',
        'items' => {
          'anyOf' =>
            %w[string integer]
        }
      },
      'description' => {
        'description' => 'Property description',
        'type' => 'string'
      }
    }
  }
end

# Setup configuration node property items schema for
# Array property items
#
# @return Hash with configuration nodes property items schema Array
def setup_config_node_property_array_response_schema
  config_node_property_array_response_schema =
    {
      'description' => 'Property value',
      'type' => 'array',
      'items' => {
        'type' => 'string'
      }
    }
  setup_config_node_property_response_schema(config_node_property_array_response_schema)
end

# Setup configuration node property items schema for
# property items with a drop-down menu
#
# @return Hash with configuration nodes property items schema drop-down
def setup_config_node_property_dropdown_response_schema
  config_node_property_dropdown_response_schema =
    {
      'description' => 'Property value',
      'type' => 'object',
      'items' => {
        'type' => 'array',
        'items' => {
          'anyOf' =>
            %w[string integer]
        }
      }
    }
  setup_config_node_property_response_dropdown_schema(config_node_property_dropdown_response_schema)
end

# Setup configuration node property items schema for
# Boolean property items
#
# @return Hash with configuration nodes property items schema Boolean
def setup_config_node_property_boolean_response_schema
  config_node_property_boolean_response_schema =
    {
      'description' => 'Property value',
      'type' => 'boolean'
    }

  setup_config_node_property_response_schema(config_node_property_boolean_response_schema)
end

# Setup configuration node property items schema for
# Integer property items
#
# @return Hash with configuration nodes property items schema Integer
def setup_config_node_property_integer_response_schema
  config_node_property_integer_response_schema =
    {
      'description' => 'Property value',
      'type' => 'integer'
    }

  setup_config_node_property_response_schema(config_node_property_integer_response_schema)
end

# Setup configuration node property items schema for
# Float property items
#
# @return Hash with configuration nodes property items schema Float
def setup_config_node_property_float_response_schema
  config_node_property_float_response_schema =
    {
      'description' => 'Property value',
      'type' => 'number'
    }

  setup_config_node_property_response_schema(config_node_property_float_response_schema)
end

# Setup configuration node property items schema for
# String property items
#
# @return Hash with configuration nodes property items schema String
def setup_config_node_property_string_response_schema
  config_node_property_string_response_schema =
    {
      'description' => 'Property value',
      'type' => 'string'
    }
  setup_config_node_property_response_schema(config_node_property_string_response_schema)
end

# Setup configuration node property post schema
#
# @param Dictionary containing the config node property
# @return Hash with configuration nodes property post schema
def setup_config_node_property_post_schema(config_node_property)
  # Save items  in config_node_property in new variables
  config_node_property_name = config_node_property[0]
  config_node_property_type = get_config_node_property_type(config_node_property)

  config_node_property_type_schema = case config_node_property_type
                                     when Integer
                                       {
                                         'type' => 'integer'
                                       }
                                     when Float
                                       {
                                         'type' => 'number'
                                       }
                                     when String
                                       {
                                         'type' => 'string'
                                       }
                                     when [true].include?(config_node_property_type)
                                       {
                                         'type' => 'boolean'
                                       }
                                     when Array
                                       {
                                         'type' => 'array',
                                         'items' =>
                                         {
                                           'type' => 'string'
                                         }
                                       }
                                     else
                                       p 'ERROR:'
                                       p 'config node property type unknown.'
                                       p "Config node property type I got was #{config_node_property_type}"
                                       exit 1
                                     end

  config_node_property_post_schema =
    {
      'name' => config_node_property_name,
      'in' => 'query',
      'schema' => config_node_property_type_schema
    }

  config_node_property_post_schema
end

# Setup configuration node property response schema
#
# @param Dictionary containing the config node property
# @return Hash with configuration nodes property response schema
def setup_config_node_property_type_response_schema(config_node_property)
  # Save items in config_node_property in new variables
  config_node_property_name = config_node_property[0]
  config_node_property_type = get_config_node_property_type_response_schema(config_node_property)
  config_node_property_description = config_node_property[1]['description']

  case config_node_property_type
  when Integer
    config_node_property_type_reponse_schema_name = 'configNodePropertyInteger'
  when Float
    config_node_property_type_reponse_schema_name = 'configNodePropertyFloat'
  when String
    config_node_property_type_reponse_schema_name = 'configNodePropertyString'
  when [true].include?(config_node_property_type)
    config_node_property_type_reponse_schema_name = 'configNodePropertyBoolean'
  when Hash
    config_node_property_type_reponse_schema_name = 'configNodePropertyDropDown'
  when Array
    # Multi-String
    config_node_property_type_reponse_schema_name = 'configNodePropertyArray'
  else
    p 'ERROR:'
    p 'config node property type unknown.'
    p "Config node property type I got was #{config_node_property_type}"
    exit 1
  end

  config_node_property_type_response_schema =
    {
      config_node_property_name.to_s =>
      {
        'description' => config_node_property_description,
        '$ref' => "#/components/schemas/#{config_node_property_type_reponse_schema_name}"
      }
    }

  config_node_property_type_response_schema
end

# Get all properties of a configuration node in JSON
#
# @param the configuration nodes ID name
# @return Hash with all values for specified configuration node
def get_config_node(config_node_id)
  # Make config node id html compatible
  config_node_id_url = config_node_id.gsub(' ', '%20')

  request = Typhoeus::Request.new(
    "#{@scheme}://#{@host}/system/console/configMgr/#{config_node_id_url}",
    method: :post,
    body: 'this is a request body',
    params: { post: 'true' },
    headers: { ContentType: 'application/json' },
    userpwd: "#{@username}:#{@password}"
  )
  response_body = request.run.body
  JSON.parse(response_body)
end

# Get the configuration node property type.
# This method checks which kind
# the config node property type is of.
#
# @param Dictionary containing the config node property
# @return a value depending ont the type of the config node property
#         return values are Array, Boolean, Float, Integer or String
def get_config_node_property_type(config_node_property)
  config_node_property_value = config_node_property[1]['value'] unless config_node_property[1]['value'].nil?
  config_node_property_value = config_node_property[1]['values'] unless config_node_property[1]['values'].nil?
  config_node_property_type = config_node_property[1]['type']

  # 27-05-2019
  # This logic determines the OSGI Sling property type.
  #
  # So far we know about the following config node property types:
  #
  # 1 = String & Multi-Strings e.g. type"=>1, "values"=>[] = multistring
  # 2 = long
  # 3 = integer
  # 7 = float
  # 11 = boolean e.g. type"=>11 = boolean
  # 12 = Secrets (String) e.g. type"=>12 = secret (unmodified)
  # Hashs e.g. type"=>{"labels"=>["default sync", "oak external idp sync"] = pre-defined list
  #       Hashs contains a drop-down menu to choose from
  #       Hashs types can be either strings or integer
  #
  # Check if config node property type is a hash
  # If it is a hash the config node property type contains
  # a list of values we need to check for the value type
  #
  if config_node_property_type.is_a?(Hash)
    config_node_property_values = config_node_property_type['values']
    config_node_property_type = {}
  end

  case config_node_property_type
  when 1 # String / Multi-String
    case config_node_property_value
    when Array
      # Multi-String
      config_node_property_type_value = []
    else String
      # String
      config_node_property_type_value = 'string'
    end
  when 2 # Long
    config_node_property_type_value = 1
  when 3 # Integer
    config_node_property_type_value = 1
  when 7 # Float
    config_node_property_type_value = 1.0
  when 11 # boolean
    config_node_property_type_value = true
  when 12 # Secrets
    config_node_property_type_value = 'string'
  when Hash # Hash
    # Check if values in the config property are a string or integer
    config_node_property_values.each do |value|
      @config_node_property_value_integer = value.match?(/^\d/)
    end

    # Set config property type schema
    config_node_property_type_value = 1 if @config_node_property_value_integer
    config_node_property_type_value = 'string' unless @config_node_property_value_integer
  else
    p 'ERROR:'
    p 'config node property unknown. I only know about 1, 2, 3, 7, 11 & 12.'
    p "Config node property type I got was #{config_node_property_type}"
    exit 1
  end

  config_node_property_type_value
end

# Get the configuration node property type for the response schema.
# This method checks which kind the config node property type is made of.
# Since the reponse types differs from the post type we need a own method for it
#
# @param Dictionary containing the config node property
# @return a value depending ont the type of the config node property
#         return values are Array, Boolean, Float, Hash, Integer or String
def get_config_node_property_type_response_schema(config_node_property)
  config_node_property_value = config_node_property[1]['value'] unless config_node_property[1]['value'].nil?
  config_node_property_value = config_node_property[1]['values'] unless config_node_property[1]['values'].nil?
  config_node_property_type = config_node_property[1]['type']

  # 27-05-2019
  # This logic determines the OSGI Sling property type.
  #
  # So farw e know about the following config node property types:
  #
  # 1 = String & Multi-Strings e.g. type"=>1, "values"=>[] = multistring
  # 2 = long
  # 3 = integer
  # 7 = float
  # 11 = boolean e.g. type"=>11 = boolean
  # 12 = Secrets (String) e.g. type"=>12 = secret (unmodified)
  # Hashs e.g. type"=>{"labels"=>["default sync", "oak external idp sync"] = pre=defined list
  #       Hashs contains a drop-down menu to choose from
  #       Hashs types can be either strings or integer
  #

  case config_node_property_type
  when 1 # String / Multi-String
    case config_node_property_value
    when Array
      # Multi-String
      config_node_property_type_response_value = []
    else String
      # String
      config_node_property_type_response_value = 'string'
    end
  when 2 # Long
    config_node_property_type_response_value = 1
  when 3 # Integer
    config_node_property_type_response_value = 1
  when 7 # Float
    config_node_property_type_response_value = 1.0
  when 11 # boolean
    config_node_property_type_response_value = true
  when 12 # Secrets
    config_node_property_type_response_value = 'string'
  when Hash # Hash
    config_node_property_type_response_value = {}
  else
    p 'ERROR:'
    p 'config node property unknown. I only know about 1, 2, 3, 7, 11 & 12.'
    p "Config node property type I got was #{config_node_property_type}"
    exit 1
  end

  config_node_property_type_response_value
end

# Method to generate a proper name for the Swagger operation ID.
# It removes all special chars and will set each character after
# a special char with the CAPITAL character.
#
# @param the configuration nodes ID name
# @return configuration node ID name without special char and
#         with each char after a special char in CAPITAL character.
def gen_operation_id(config_node_id)
  # Clone config node id so we get a new object_id to alter with
  operation_id_raw = config_node_id.clone

  # Convert each first char after non alphabetical char to UPPERCASE
  # operation_id_uppercase_after_dots = operation_id_raw.gsub!(/(\W[a-zA-Z])/){ $1.upcase }
  operation_id_uppercase_after_dots = operation_id_raw.gsub!(/(\W[a-zA-Z])/) { Regexp.last_match(1).upcase }

  # Replace each special char with '.' if config_node_id_uppercase_after_dots is not nil
  operation_id_raw = operation_id_uppercase_after_dots.gsub(/\W/, '') unless operation_id_uppercase_after_dots.nil?

  # If config_node_id doesn't has any non alphabetical char we return the
  # operation_id_raw
  return operation_id_raw if operation_id_uppercase_after_dots.nil?

  # Convert first char to lower case
  # operation_id = operation_id_raw.gsub!(/(^.)/) { $1.downcase }
  operation_id = operation_id_raw.gsub!(/(^.)/) { Regexp.last_match(1).downcase }

  operation_id
end

# Generate a template dict for post method
#
# @returns Returns a dict template to be used by the post method
def generate_config_nodes_post_dict_template
  {
    'paths' =>
    {
    },
    'servers' =>
    [
      'url' => '/'
    ]
  }
end

# Generate a template dict for response schema
#
# @returns Returns a dict template to be used to setup the response schema
def generate_config_nodes_response_schema_dict_template
  {
    'components' =>
    {
      'schemas' =>
      {
        'configNodePropertyInteger' => setup_config_node_property_integer_response_schema,
        'configNodePropertyFloat' => setup_config_node_property_float_response_schema,
        'configNodePropertyArray' => setup_config_node_property_array_response_schema,
        'configNodePropertyDropDown' => setup_config_node_property_dropdown_response_schema,
        'configNodePropertyBoolean' => setup_config_node_property_boolean_response_schema,
        'configNodePropertyString' => setup_config_node_property_string_response_schema
      }
    }
  }
end

# Generate a list of all found configuration nodes.
#
# @params RubyAem::Result.data from method get_configmgr
# @returns Returns a list of all found pids
def generate_config_node_pid_list(data)
  # This is the heart of the whole function
  # it only works because we are checking for the
  # value configData in the page source code which
  # contains all config nodes which exists in AEM.
  config_data = data.match('configData(.*)')
  sub_config_data = config_data.to_s.sub('configData = ', '').gsub(/\;$/, '')
  config_data_json = JSON.parse(sub_config_data)
  config_nodes_pids = config_data_json['pids']
  config_nodes_fpids = config_data_json['fpids']

  config_nodes_pids.concat(config_nodes_fpids)
end

############################################################
# To-Do:
# * Check for default values
############################################################
configmgr = @client.aem_configmgr()
data, _status_code, _headers = configmgr.get_configmgr
config_nodes_pids = generate_config_node_pid_list(data.response.body)

############################################################
# Create dictionary templates
############################################################
# Create config nodes post dictionary template
config_nodes_post_dict = generate_config_nodes_post_dict_template

# Create config nodes response schema dictionary template
config_nodes_response_schema_dict = generate_config_nodes_response_schema_dict_template

# Iterate through the full list of all config nodes
config_nodes_pids.each do |config_node|
  # Set config node id
  config_node_id = config_node['id']

  # get all informations of the config node
  config_node_json = get_config_node(config_node_id)

  # Skip configuration nodes which are already configured
  # So we have a clean list of configuration nodes which we can configure
  # if config_node_json['factoryPid'] is not empty we know this is a
  # pre-configured configuration node and we can skip it as we only
  # want parent configuration node in our OpenAPI Spec

  next unless config_node_json['factoryPid'].to_s.strip.empty?

  # Generate Operations ID for Swagger
  operation_id = gen_operation_id(config_node_id)

  # Setup config node dictionary template
  config_nodes_post_dict['paths']["/system/console/configMgr/#{config_node_id}"] = setup_config_node_post_schema(operation_id)

  # Setup config node response schema dictionary template
  config_nodes_response_schema_dict['components']['schemas']["#{operation_id}Info"] =
    {
      'type' => 'object',
      'properties' => {

      }
    }
  config_nodes_response_schema_dict['components']['schemas']["#{operation_id}Properties"] =
    {
      'type' => 'object',
      'properties' => {

      }
    }

  # Create config node response schema for each found config node item
  config_node_json.each do |config_node_item|
    # Setup config node response schema
    # Since the PID contains two bundle locations items
    # bundle_location and bundleLocation we only want to know
    # bundle_location, since bundleLocation get's translated to
    # bundle_location as well which would than overwrite
    # the previous set bundle_location param
    next if config_node_item[0].to_s.eql?('bundleLocation')

    config_nodes_response_schema_dict['components']['schemas']["#{operation_id}Info"]['properties'][config_node_item[0].to_s] =
      {
        'type' => 'string'
      }
  end

  # Setup config node property response schema dict
  config_nodes_response_schema_dict['components']['schemas']["#{operation_id}Info"]['properties']['properties'] =
    {
      '$ref' => "#/components/schemas/#{operation_id}Properties"
    }

  # Iterate through each found config node property to
  # setup config node properties post & response schema dict
  config_node_json['properties'].each do |config_node_property|
    # Setup config node property post schema
    config_node_property_post_schema = setup_config_node_property_post_schema(config_node_property)

    # check if config node post paramter already exists
    config_nodes_post_dict['paths']["/system/console/configMgr/#{config_node_id}"]['post']['parameters'].each do |config_node_name|
      @config_node_post_parameter_exist = false
      @config_node_post_parameter_exist = true if config_node_name['name'].eql?(config_node_property_post_schema['name'])
      break if @config_node_post_parameter_exist.eql?(true)
    end
    # To avoid duplication in the config node post parameter list we do not add them to the post parameter list
    next if @config_node_post_parameter_exist.eql?(true)

    # Add config node property post schema to config node post schema if it does not already exists
    config_nodes_post_dict['paths']["/system/console/configMgr/#{config_node_id}"]['post']['parameters'].push(config_node_property_post_schema)

    # Set up config node property response schema
    config_node_property_response_schema = setup_config_node_property_type_response_schema(config_node_property)
    # Add config node property response schema to config node response schema
    config_nodes_response_schema_dict['components']['schemas']["#{operation_id}Properties"]['properties'].merge!(config_node_property_response_schema)
  end
end

# We need to merge our created dicts where
config_nodes_post_dict.merge!(config_nodes_response_schema_dict)

# yaml_config_nodes_response_schema_dict = config_nodes_post_dict.to_yaml
api_spec_yaml = YAML.load_file(@api_source_file)

api_spec_paths = config_nodes_post_dict['paths'].merge!(api_spec_yaml['paths'])
api_spec_components_schema = config_nodes_post_dict['components']['schemas'].merge!(api_spec_yaml['components']['schemas'])

api_spec_yaml['paths'].merge!(api_spec_paths)
api_spec_yaml['components']['schemas'].merge!(api_spec_components_schema)

api_spec = api_spec_yaml

File.open(@api_dest_file, 'w') do |file|
  file.write api_spec.to_yaml
end
