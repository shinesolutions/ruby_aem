require_relative '../spec_helper'
require_relative '../../../lib/ruby_aem/resources/certificate'

describe 'Certificate' do
  before do
    @mock_client = double('mock_client')

    # certificate initialisation looks up the certificate alias from truststore info
    mock_alias = double('mock_alias')
    allow(mock_alias).to receive(:_alias).and_return('somecertalias')
    allow(mock_alias).to receive(:serial_number).and_return(15_863_505_968_020_663_268)
    mock_other_alias = double('mock_other_alias')
    allow(mock_other_alias).to receive(:_alias).and_return('someothercertalias')
    allow(mock_other_alias).to receive(:serial_number).and_return(1234)
    mock_truststore_info = double('mock_truststore_info')
    allow(mock_truststore_info).to receive(:aliases).and_return([mock_other_alias, mock_alias])
    mock_result_truststore_info = double('mock_result_truststore_info')
    allow(mock_result_truststore_info).to receive(:data).and_return(mock_truststore_info)
    allow(@mock_client).to receive(:call).with(RubyAem::Resources::Truststore, 'info', anything).and_return(mock_result_truststore_info)

    @certificate = RubyAem::Resources::Certificate.new(@mock_client, '15863505968020663268')
  end

  describe 'test create' do
    it 'should call client with expected parameters' do
      mock_result = double('mock_result')
      expect(@mock_client).to receive(:call).once.with(
        RubyAem::Resources::Certificate,
        'import',
        {
          serial_number: '15863505968020663268',
          file_path: '/somepath/cert_chain.crt'
        }
      ).and_return(mock_result)
      result = @certificate.create('/somepath/cert_chain.crt')
      expect(result).to be(mock_result)
    end
  end

  describe 'test import' do
    it 'should call client with expected parameters' do
      mock_result = double('mock_result')
      expect(@mock_client).to receive(:call).once.with(
        RubyAem::Resources::Certificate,
        'import',
        {
          serial_number: '15863505968020663268',
          file_path: '/somepath/cert_chain.crt'
        }
      ).and_return(mock_result)
      result = @certificate.import('/somepath/cert_chain.crt')
      expect(result).to be(mock_result)
    end
  end

  describe 'test export' do
    it 'should download truststore and return the certificate having the serial number' do
      mock_temp_file = double('mock_temp_file')
      expect(mock_temp_file).to receive(:path).and_return('/tmp/sometruststore')
      expect(Tempfile).to receive(:new).and_return(mock_temp_file)
      expect(@mock_client).to receive(:call).once.with(
        RubyAem::Resources::Truststore,
        'download',
        { file_path: '/tmp/sometruststore' }
      )

      mock_ca_cert = double('mock_ca_cert')
      expect(mock_ca_cert).to receive(:serial).and_return(15_863_505_968_020_663_268)
      mock_other_ca_cert = double('mock_other_ca_cert')
      expect(mock_other_ca_cert).to receive(:serial).and_return(1234)
      mock_truststore = double('mock_truststore')
      expect(mock_truststore).to receive(:ca_certs).and_return([mock_other_ca_cert, mock_ca_cert])
      allow(File).to receive(:read).and_call_original
      expect(File).to receive(:read).with('/tmp/sometruststore').and_return('sometruststoreraw')
      expect(OpenSSL::PKCS12).to receive(:new).with('sometruststoreraw', 's0m3p4ssw0rd').and_return(mock_truststore)

      result = @certificate.export('s0m3p4ssw0rd')
      expect(result.message).to eq('Certificate exported')
      expect(result.data).to be(mock_ca_cert)
    end
  end

  describe 'test delete' do
    it 'should call client with expected parameters when certificate exists' do
      mock_result_exists = double('mock_result_exists')
      expect(mock_result_exists).to receive(:data).and_return(true)
      mock_result_delete = double('mock_result_delete')
      expect(@mock_client).to receive(:call).once.with(
        RubyAem::Resources::Certificate,
        'exists',
        anything
      ).and_return(mock_result_exists)
      expect(@mock_client).to receive(:call).once.with(
        RubyAem::Resources::Certificate,
        'delete',
        {
          serial_number: '15863505968020663268',
          cert_alias: 'somecertalias'
        }
      ).and_return(mock_result_delete)
      result = @certificate.delete
      expect(result).to be(mock_result_delete)
    end

    it 'should raise error when certificate does not exist' do
      mock_result_exists = double('mock_result_exists')
      expect(mock_result_exists).to receive(:data).and_return(false)
      expect(@mock_client).to receive(:call).once.with(
        RubyAem::Resources::Certificate,
        'exists',
        { serial_number: '15863505968020663268' }
      ).and_return(mock_result_exists)
      expect { @certificate.delete }.to raise_error(RubyAem::Error) { |error|
        expect(error.message).to eq('Certificate not found')
        expect(error.result).to be(mock_result_exists)
      }
    end
  end

  describe 'test exists' do
    it 'should call client with expected parameters' do
      expect(@mock_client).to receive(:call).once.with(
        RubyAem::Resources::Certificate,
        'exists',
        { serial_number: '15863505968020663268' }
      )
      @certificate.exists
    end
  end

  describe 'test import_wait_until_ready' do
    it 'should import then check existence until certificate exists' do
      mock_result_import = double('mock_result_import')
      mock_result_not_exists = double('mock_result_not_exists')
      expect(mock_result_not_exists).to receive(:data).twice.and_return(false)
      expect(mock_result_not_exists).to receive(:message).twice.and_return('Certificate not found')
      mock_result_exists = double('mock_result_exists')
      expect(mock_result_exists).to receive(:data).twice.and_return(true)
      expect(mock_result_exists).to receive(:message).and_return('Certificate exists')

      expect(@mock_client).to receive(:call).once.with(RubyAem::Resources::Certificate, 'import', anything).and_return(mock_result_import)
      expect(@mock_client).to receive(:call).once.with(RubyAem::Resources::Certificate, 'exists', anything).and_return(mock_result_not_exists)
      expect(@mock_client).to receive(:call).once.with(RubyAem::Resources::Certificate, 'exists', anything).and_return(mock_result_exists)

      expect($stdout).to receive(:puts).with('Import check #1: false - Certificate not found')
      expect($stdout).to receive(:puts).with('Import check #2: true - Certificate exists')
      result = @certificate.import_wait_until_ready(
        '/somepath/cert_chain.crt',
        _retries: {
          max_tries: '3',
          base_sleep_seconds: '0',
          max_sleep_seconds: '0'
        }
      )
      expect(result).to be(mock_result_import)
    end

    it 'should use default retries settings when they are not specified' do
      mock_result_import = double('mock_result_import')
      mock_result_exists = double('mock_result_exists')
      expect(mock_result_exists).to receive(:data).twice.and_return(true)
      expect(mock_result_exists).to receive(:message).and_return('Certificate exists')

      expect(@mock_client).to receive(:call).once.with(RubyAem::Resources::Certificate, 'import', anything).and_return(mock_result_import)
      expect(@mock_client).to receive(:call).once.with(RubyAem::Resources::Certificate, 'exists', anything).and_return(mock_result_exists)

      expect($stdout).to receive(:puts).with('Import check #1: true - Certificate exists')
      result = @certificate.import_wait_until_ready('/somepath/cert_chain.crt')
      expect(result).to be(mock_result_import)
    end
  end
end
