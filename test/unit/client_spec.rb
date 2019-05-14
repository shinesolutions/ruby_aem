require_relative 'spec_helper'
require_relative '../../lib/ruby_aem/client'
require_relative '../../lib/ruby_aem/error'

describe 'Client' do
  before do
    @spec = {
      'bundle' => {
        'actions' => {
          'start' => {
            'api' => 'console',
            'operation' => 'postBundle',
            'params' => {
              'required' => {
                'name' => '%<name>s',
                'action' => 'start'
              }
            },
            'responses' => {
              200 => {
                'status' => 'success',
                'handler' => 'simple',
                'message' => 'Bundle %<name>s started'
              }
            }
          }
        }
      }
    }
  end

  after do
  end

  describe 'test call' do
    it 'should call api send and handle the response' do
      mock_class = double('mock_class')
      expect(mock_class).to receive(:name).once.and_return('RubyAem::Resources::Bundle')

      mock_api = double('mock_api')
      expect(mock_api).to receive(:post_bundle_with_http_info).once.with('somebundle', 'start', {}).and_return(['some data', 200, {}])
      apis = { console: mock_api }

      client = RubyAem::Client.new(apis, @spec)
      client.call(mock_class, 'start', name: 'somebundle')
    end

    it 'should handle api error' do
      mock_error = SwaggerAemClient::ApiError.new(code: 200, response_headers: {}, response_body: 'some data')

      mock_class = double('mock_class')
      expect(mock_class).to receive(:name).once.and_return('RubyAem::Resources::Bundle')

      mock_api = double('mock_api')
      expect(mock_api).to receive(:post_bundle_with_http_info).once.with('somebundle', 'start', {}).and_raise(mock_error)
      apis = { console: mock_api }

      client = RubyAem::Client.new(apis, @spec)
      client.call(mock_class, 'start', name: 'somebundle')
    end

    it 'should handle optional param without value' do
      spec = {
        'bundle' => {
          'actions' => {
            'start' => {
              'api' => 'console',
              'operation' => 'postBundle',
              'params' => {
                'optional' => %w[
                  optional1
                  optional2
                ]
              },
              'responses' => {
                200 => {
                  'status' => 'success',
                  'handler' => 'simple',
                  'message' => 'Bundle %<name>s started'
                }
              }
            }
          }
        }
      }

      mock_class = double('mock_class')
      expect(mock_class).to receive(:name).once.and_return('RubyAem::Resources::Bundle')

      mock_api = double('mock_api')
      expect(mock_api).to receive(:post_bundle_with_http_info).once.with(optional1: 'value1', optional2: 'value2').and_return(['some data', 200, {}])
      apis = { console: mock_api }

      client = RubyAem::Client.new(apis, spec)
      client.call(mock_class, 'start', name: 'somebundle', optional1: 'value1', optional2: 'value2')
    end

    it 'should handle optional param with non-String value' do
      spec = {
        'bundle' => {
          'actions' => {
            'start' => {
              'api' => 'console',
              'operation' => 'postBundle',
              'params' => {
                'optional' => {
                  'optional1' => true,
                  'optional2' => false
                }
              },
              'responses' => {
                200 => {
                  'status' => 'success',
                  'handler' => 'simple',
                  'message' => 'Bundle %<name>s started'
                }
              }
            }
          }
        }
      }

      mock_class = double('mock_class')
      expect(mock_class).to receive(:name).once.and_return('RubyAem::Resources::Bundle')

      mock_api = double('mock_api')
      expect(mock_api).to receive(:post_bundle_with_http_info).once.with(optional1: true, optional2: false).and_return(['some data', 200, {}])
      apis = { console: mock_api }

      client = RubyAem::Client.new(apis, spec)
      client.call(mock_class, 'start', name: 'somebundle', optional1: true, optional2: false)
    end

    it 'should handle optional param with non-File String value' do
      spec = {
        'bundle' => {
          'actions' => {
            'start' => {
              'api' => 'console',
              'operation' => 'postBundle',
              'params' => {
                'optional' => {
                  'optional1' => 'value1',
                  'optional2' => 'value2'
                }
              },
              'responses' => {
                200 => {
                  'status' => 'success',
                  'handler' => 'simple',
                  'message' => 'Bundle %<name>s started'
                }
              }
            }
          }
        }
      }

      mock_class = double('mock_class')
      expect(mock_class).to receive(:name).once.and_return('RubyAem::Resources::Bundle')

      mock_api = double('mock_api')
      expect(mock_api).to receive(:post_bundle_with_http_info).once.with(optional1: 'value1', optional2: 'value2').and_return(['some data', 200, {}])
      apis = { console: mock_api }

      client = RubyAem::Client.new(apis, spec)
      client.call(mock_class, 'start', name: 'somebundle', optional1: 'value1', optional2: 'value2')
    end

    it 'should handle optional param with File String value' do
      spec = {
        'bundle' => {
          'actions' => {
            'start' => {
              'api' => 'console',
              'operation' => 'postBundle',
              'params' => {
                'optional' => {
                  'optional1' => '__FILE_PACKAGE__',
                  'optional2' => '__FILE_PLAIN__',
                  'optional3' => '__FILE_CERTIFICATE__',
                  'optional4' => '__FILE_PRIVATE_KEY__'
                }
              },
              'responses' => {
                200 => {
                  'status' => 'success',
                  'handler' => 'simple',
                  'message' => 'Bundle %<name>s started'
                }
              }
            }
          }
        }
      }

      mock_file_package = double('mock_file_package')
      mock_file_plain = double('mock_file_plain')
      mock_file_certificate = double('mock_file_certificate')
      mock_file_private_key = double('mock_file_private_key')
      expect(File).to receive(:open).once.with('/tmp/somepackage-1.2.3.zip', 'r').and_yield(mock_file_package)
      expect(File).to receive(:open).once.with('/tmp', 'r').and_yield(mock_file_plain)
      expect(File).to receive(:open).once.with('/tmp/somecert', 'r').and_yield(mock_file_certificate)
      expect(File).to receive(:open).once.with('/tmp/someprivatekey', 'r').and_yield(mock_file_private_key)

      mock_class = double('mock_class')
      expect(mock_class).to receive(:name).once.and_return('RubyAem::Resources::Bundle')

      mock_api = double('mock_api')
      expect(mock_api).to receive(:post_bundle_with_http_info)
        .once.with(optional1: mock_file_package, optional2: mock_file_plain, optional3: mock_file_certificate, optional4: mock_file_private_key)
        .and_return(['some data', 200, {}])
      apis = { console: mock_api }

      client = RubyAem::Client.new(apis, spec)
      client.call(
        mock_class,
        'start',
        name: 'somebundle',
        optional1: '__FILE_PACKAGE__',
        optional2: '__FILE_PLAIN__',
        optional3: '__FILE_CERTIFICATE__',
        optional4: '__FILE_PRIVATE_KEY__',
        file_path: '/tmp',
        file_path_certificate: '/tmp/somecert',
        file_path_private_key: '/tmp/someprivatekey',
        package_name: 'somepackage',
        package_version: '1.2.3'
      )
    end
  end

  describe 'test handle' do
    it 'should raise error when responses does not contain status code' do
      data = 'somepayload'
      status_code = 404
      headers = nil
      response = RubyAem::Response.new(status_code, data, headers)
      responses_spec = {
        200 => { 'status' => 'success', 'message' => 'Bundle %<name>s started' }
      }
      call_params = {
        name: 'somebundle'
      }

      client = RubyAem::Client.new(nil, nil)
      begin
        client.handle(response, responses_spec, call_params)
      rescue RubyAem::Error => e
        expect(e.result.message).to eq("Unexpected response\nstatus code: 404\nheaders: \nbody: somepayload")
        expect(e.result.response.status_code).to eq(404)
        expect(e.result.response.body).to eq('somepayload')
        expect(e.result.response.headers).to eq(nil)
      end
    end

    it 'should call handler when responses contain status code' do
      data = 'somepayload'
      status_code = 200
      headers = nil
      response = RubyAem::Response.new(status_code, data, headers)
      responses_spec = {
        200 => { 'status' => 'success', 'message' => 'Bundle %<name>s started' }
      }
      call_params = {
        name: 'somebundle'
      }

      expect(RubyAem::Handlers).to receive(:send).once.with(nil, response, { 'status' => 'success', 'message' => 'Bundle %<name>s started' }, { name: 'somebundle' })

      client = RubyAem::Client.new(nil, nil)
      client.handle(response, responses_spec, call_params)
    end
  end
end
