# Copyright 2016-2017 Shine Solutions
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'openssl'
require 'retries'
require 'tempfile'
require 'ruby_aem/error'

module RubyAem
  module Resources
    # AEM class contains API calls related to managing the AEM Authorizable Keystore.
    class AuthorizableKeystore
      # Initialise an Authorizable Keystore
      #
      # @param client RubyAem::Client
      # @param intermediate_path AEM User home path
      # @param authorizable_id AEM User id
      # @return new RubyAem::Resources::AuhtorizableKeystore instance
      def initialize(client, intermediate_path, authorizable_id)
        @client = client
        @call_params = {
          intermediate_path: intermediate_path,
          authorizable_id: authorizable_id
        }
      end

      # Change the password of an AEM Authorizable Keystore
      #
      # @param old_keystore_password Current password for the keystore
      # @param new_keystore_password New password for the keystore

      # @return RubyAem::Result
      def change_password(old_keystore_password, new_keystore_password)
        result = exists
        keystore = result.data
        status_code = result.response

        if keystore.eql? true
          message = 'Keystore do not exists'
          results = RubyAem::Result.new(message, status_code)
          results.data = keystore
        else
          @call_params[:old_keystore_password] = old_keystore_password
          @call_params[:new_keystore_password] = new_keystore_password
          results = @client.call(self.class, __callee__.to_s, @call_params)
        end

        results
      end

      # Create AEM Authorizable Keystore
      #
      # @param keystore_password Password for the keystore
      # @return RubyAem::Result
      def create(keystore_password)
        result = exists
        keystore = result.data
        status_code = result.response

        if keystore.eql? true
          message = 'Keystore already created'
          results = RubyAem::Result.new(message, status_code)
          results.data = keystore
        else
          @call_params[:keystore_password] = keystore_password
          results = @client.call(self.class, __callee__.to_s, @call_params)
        end

        results
      end

      # Delete AEM Authorizable Keystore
      #
      # @return RubyAem::Result
      def delete
        result = exists
        keystore = result.data
        status_code = result.response

        if keystore.eql? true
          results = @client.call(self.class, __callee__.to_s, @call_params)
        else
          message = 'Keystore already deleted'
          results = RubyAem::Result.new(message, status_code)
          results.data = keystore
        end

        results
      end

      # Delete a specific certificate by certificate alias from the Keystore.
      #
      # @param private_key_alias Certificate Chain alias name in Keystore
      # @return RubyAem::Result
      def delete_certificate_chain(private_key_alias)
        result = exists_certificate_chain(private_key_alias)
        certificate = result.data

        if certificate.eql? true
          @call_params[:_alias] = private_key_alias
          results = @client.call(self.class, __callee__.to_s, @call_params)
        else
          results = result
        end

        results
      end

      # Download the AEM Keystore to a specified directory.
      #
      # @param file_path the directory where the Keystore will be downloaded to
      # @return RubyAem::Result
      def download(
        params = {
          file: nil,
          path: nil
        }
      )
        file_path = "#{params[:path]}/store.p12" unless params[:path].eql? nil
        file_path = params[:file] unless params[:file].eql? nil
        @call_params[:file_path] = file_path
        @client.call(self.class, __callee__.to_s, @call_params)
      end

      # Check if a Keystore for the given authorizable id already exists
      #
      # @return RubyAem::Result
      def exists
        result = get
        message = result.message
        status_code = result.response

        exists = if result.message.eql? 'Keystore exists'
                   true
                 else
                   false
                 end

        result = RubyAem::Result.new(message, status_code)
        result.data = exists

        result
      end

      # Check if a specific certificate exists in the truststore.
      #
      # @param private_key_alias Certificate Chain alias name in Keystore
      # @return RubyAem::Result
      def exists_certificate_chain(private_key_alias)
        result = get_certificate_chain(private_key_alias)
        message = result.message
        status_code = result.response

        exists = if result.message.eql? 'Certificate exists'
                   true
                 else
                   false
                 end

        result = RubyAem::Result.new(message, status_code)
        result.data = exists

        result
      end

      # Read Keystore information for given authorizable id.
      #
      # @return RubyAem::Result
      def get
        result = @client.call(self.class, __callee__.to_s, @call_params)
        keystore = result.response.body.to_hash
        status_code = result.response.status_code
        if keystore.key?(:exists) && keystore[:exists].eql?(false)
          message = 'Keystore do not exists'
        elsif keystore.key?(:aliases)
          message = 'Keystore exists'
        end
        result = RubyAem::Result.new(message, status_code)
        result.data = keystore

        result
      end

      # Get specific certificate from truststore.
      #
      # @param private_key_alias Certificate Chain alias name in Keystore
      # @return RubyAem::Result
      def get_certificate_chain(private_key_alias)
        result = exists
        keystore = result.data
        status_code = result.response

        if keystore.eql? true
          result = get
          certificates = []
          result.data[:aliases].each { |certificate|
            next unless certificate[:alias].eql? private_key_alias
            certificates.push(certificate)
          }

          message = if certificates.empty?
                      'Certificate do not exists'
                    else
                      'Certificate exists'
                    end
          results = RubyAem::Result.new(message, status_code)
          results.data = certificates
        else
          results = result
        end
        results
      end

      # Read certificate informations from certificate provided as a file
      #
      # @param file_path Full Path to the Certificate file on the Filesystem
      # @return RubyAem::Result
      def read_cert_from_file(file_path)
        cert_raw = File.read file_path
        cert = OpenSSL::X509::Certificate.new(cert_raw)
        cert_data = {
          issuer: cert.issuer.to_s,
          not_after: cert.not_after,
          not_before: cert.not_before,
          serial: cert.serial.to_i,
          subject: cert.subject.to_s
        }

        cert_data
      end

      # Read certificate informations provides as raw text
      #
      # @param certificate_raw Raw certificate in PEM Format
      # @return RubyAem::Result
      def read_certificate_raw(certificate_raw)
        cert = OpenSSL::X509::Certificate.new(certificate_raw)
        cert_data = {
          issuer: cert.issuer.to_s,
          not_after: cert.not_after,
          not_before: cert.not_before,
          serial: cert.serial.to_i,
          subject: cert.subject.to_s
        }

        cert_data
      end

      # Read A Keystore in PKCS#12 Format
      #
      # @param file_path local file path to Keystore PKCS12 file
      # @param keystore_password Password of the Keystore PKCS12 File
      # @return OpenSSL::PKCS12
      def read_keystore(file_path, keystore_password)
        keystore_raw = File.read file_path
        keystore = OpenSSL::PKCS12.new(keystore_raw, keystore_password)

        keystore
      end

      # Upload a Keystore PKCS12 file.
      #
      # @param file_path local file path to Keystore PKCS12 file
      # @param new_alias New alias name of the Certificate Chain in Keystore
      # @param key_store_file_password Password of the Keystore PKCS12 File
      # @param private_key_alias Alias name of the Certificate chain to import in Keystore
      # @param private_key_password Password of the Private key of the Certificate chain to import
      # @return RubyAem::Result
      def upload(file_path, new_alias, key_store_file_password, private_key_alias, private_key_password, force = false)
        result = exists
        keystore = result.data

        if keystore.eql?(true) || force == true
          @call_params[:file_path] = file_path
          @call_params[:new_alias] = new_alias
          @call_params[:key_store_file_password] = key_store_file_password
          @call_params[:private_key_alias] = private_key_alias
          @call_params[:private_key_password] = private_key_password
          results = @client.call(self.class, __callee__.to_s, @call_params)
        else
          results = keystore
        end

        results
      end

      # Upload a certificate to the Keystore.
      #
      # @param private_key_alias Certificate Chain alias name in Keystore
      # @param certificate Path to the certificate in PEM Format to upload in Keystore
      # @param private_key Path to the private key in DER Format to upload in Keystore
      # @return RubyAem::Result
      def upload_certificate_chain(private_key_alias, certificate, private_key)
        result = exists
        keystore = result.data

        if keystore.eql? true
          @call_params[:_alias] = private_key_alias
          @call_params[:file_path_certificate] = certificate
          @call_params[:file_path_private_key] = private_key
          results = @client.call(self.class, __callee__.to_s, @call_params)
        else
          results = result
        end

        results
      end

      # Upload a Certificate given as String in PEM Format
      # and the path to the Private key in DER Format to the Keystore
      #
      # @param private_key_alias Certificate Chain alias name in Keystore
      # @param certificate Certificate as string in PEM Format to upload in Keystore.
      # @param private_key Path to the private key in DER Format to upload in Keystore
      # @return RubyAem::Result
      def upload_certificate_chain_raw(private_key_alias, certificate_raw, private_key)
        temp_certificate_file = Tempfile.new('tmp')
        temp_certificate_file.write(certificate_raw)
        temp_certificate_file.close
        temp_certificate_file_path = temp_certificate_file.path

        results = upload_certificate_chain(private_key_alias, temp_certificate_file_path, private_key)

        temp_certificate_file.unlink
        results
      end

      # Upload a certificate to the AEM Keystore and wait until the certificate is uploaded.
      #
      # @param opts optional parameters:
      # - private_key_alias Certificate Chain alias name in Keystore
      # - certificate Path to the certificate in PEM Format to upload in Keystore
      # - private_key Path to the private key in DER Format to upload in Keystore
      # - _retries: retries library's options (http://www.rubydoc.info/gems/retries/0.0.5#Usage), restricted to max_tries, base_sleep_seconds, max_sleep_seconds
      # @return RubyAem::Result
      def upload_certificate_chain_from_file_wait_until_ready(
        opts = {
          private_key_alias: private_key_alias,
          certificate: certificate,
          private_key: private_key,
          _retries: {
            max_tries: 30,
            base_sleep_seconds: 2,
            max_sleep_seconds: 2
          }
        }
      )
        opts[:_retries] ||= {}
        opts[:_retries][:max_tries] ||= 30
        opts[:_retries][:base_sleep_seconds] ||= 2
        opts[:_retries][:max_sleep_seconds] ||= 2

        # ensure integer retries setting (Puppet 3 passes numeric string)
        opts[:_retries][:max_tries] = opts[:_retries][:max_tries].to_i
        opts[:_retries][:base_sleep_seconds] = opts[:_retries][:base_sleep_seconds].to_i
        opts[:_retries][:max_sleep_seconds] = opts[:_retries][:max_sleep_seconds].to_i

        result = upload_certificate_chain(opts[:private_key_alias], opts[:certificate], opts[:private_key])

        with_retries(max_tries: opts[:_retries][:max_tries], base_sleep_seconds: opts[:_retries][:base_sleep_seconds], max_sleep_seconds: opts[:_retries][:max_sleep_seconds]) { |retries_count|
          check_result = exists_certificate_chain(opts[:private_key_alias])

          puts format('Upload check #%<retries_count>d: %<check_result_data>s - %<check_result_message>s', retries_count: retries_count, check_result_data: check_result.data, check_result_message: check_result.message)
          raise StandardError.new(check_result.message) if check_result.data == false
        }
        result
      end

      # Upload a certificate to the AEM Truststore and waut until the certificate is uploaded.
      #
      # @param opts optional parameters:
      # - private_key_alias Certificate Chain alias name in Keystore
      # - certificate_raw Certificate as string in PEM Format to upload in Keystore.
      # - private_key Path to the private key in DER Format to upload in Keystore
      # - _retries: retries library's options (http://www.rubydoc.info/gems/retries/0.0.5#Usage), restricted to max_tries, base_sleep_seconds, max_sleep_seconds
      # @return RubyAem::Result
      def upload_certificate_chain_raw_wait_until_ready(
        opts = {
          private_key_alias: private_key_alias,
          certificate_raw: certificate_raw,
          private_key: private_key,
          _retries: {
            max_tries: 30,
            base_sleep_seconds: 2,
            max_sleep_seconds: 2
          }
        }
      )
        opts[:_retries] ||= {}
        opts[:_retries][:max_tries] ||= 30
        opts[:_retries][:base_sleep_seconds] ||= 2
        opts[:_retries][:max_sleep_seconds] ||= 2

        # ensure integer retries setting (Puppet 3 passes numeric string)
        opts[:_retries][:max_tries] = opts[:_retries][:max_tries].to_i
        opts[:_retries][:base_sleep_seconds] = opts[:_retries][:base_sleep_seconds].to_i
        opts[:_retries][:max_sleep_seconds] = opts[:_retries][:max_sleep_seconds].to_i

        result = upload_certificate_chain_raw(opts[:private_key_alias], opts[:certificate_raw], opts[:private_key])

        with_retries(max_tries: opts[:_retries][:max_tries], base_sleep_seconds: opts[:_retries][:base_sleep_seconds], max_sleep_seconds: opts[:_retries][:max_sleep_seconds]) { |retries_count|
          check_result = exists_certificate_chain(opts[:private_key_alias])
          puts format('Upload check #%<retries_count>d: %<check_result_data>s - %<check_result_message>s', retries_count: retries_count, check_result_data: check_result.data, check_result_message: check_result.message)
          raise StandardError.new(check_result.message) if check_result.data == false
        }
        result
      end

      # Upload a PKCS#12 Keystore to AEM and wait until it's finished.
      #
      # @param opts optional parameters:
      # - file_path local file path to Keystore PKCS12 file
      # - new_alias New alias name of the Certificate Chain in Keystore
      # - key_store_file_password Password of the Keystore PKCS12 File
      # - private_key_alias Alias name of the Certificate chain to import in Keystore
      # - private_key_password Password of the Private key of the Certificate chain to import
      # - _retries: retries library's options (http://www.rubydoc.info/gems/retries/0.0.5#Usage), restricted to max_tries, base_sleep_seconds, max_sleep_seconds
      # @return RubyAem::Result
      def upload_keystore_from_file_wait_until_ready(
        opts = {
          file_path: file_path,
          new_alias: new_alias,
          key_store_file_password: key_store_file_password,
          private_key_alias: private_key_alias,
          private_key_password: private_key_password,
          force: false,
          _retries: {
            max_tries: 30,
            base_sleep_seconds: 2,
            max_sleep_seconds: 2
          }
        }
      )
        opts[:_retries] ||= {}
        opts[:_retries][:max_tries] ||= 30
        opts[:_retries][:base_sleep_seconds] ||= 2
        opts[:_retries][:max_sleep_seconds] ||= 2

        # ensure integer retries setting (Puppet 3 passes numeric string)
        opts[:_retries][:max_tries] = opts[:_retries][:max_tries].to_i
        opts[:_retries][:base_sleep_seconds] = opts[:_retries][:base_sleep_seconds].to_i
        opts[:_retries][:max_sleep_seconds] = opts[:_retries][:max_sleep_seconds].to_i

        # before uploading certificate chain from backuped keystore create a new keystore
        create(opts[:key_store_file_password]) if exists.data.eql? true
        result = upload(opts[:file_path], opts[:new_alias], opts[:key_store_file_password], opts[:private_key_alias], opts[:private_key_password], opts[:force])

        with_retries(max_tries: opts[:_retries][:max_tries], base_sleep_seconds: opts[:_retries][:base_sleep_seconds], max_sleep_seconds: opts[:_retries][:max_sleep_seconds]) { |retries_count|
          check_result = exists
          puts format('Upload check #%<retries_count>d: %<check_result_data>s - %<check_result_message>s', retries_count: retries_count, check_result_data: check_result.data, check_result_message: check_result.message)
          raise StandardError.new(check_result.message) if check_result.data == false
        }
        result
      end
    end
  end
end
