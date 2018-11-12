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
    # AEM class contains API calls related to managing the AEM Truststore.
    class Truststore
      # Initialise truststore.
      #
      # @param client RubyAem::Client
      # @return new RubyAem::Resources::Truststore instance
      def initialize(client)
        @client = client
        @call_params = {}
      end

      # Create Truststore
      #
      # @param truststore_password Password for the Truststore
      # @return RubyAem::Result
      def create_truststore(truststore_password)
        truststore = exists_truststore
        if truststore.data.eql? true
          message = 'Truststore already created'
          results = RubyAem::Result.new(message, nil)
          results.data = truststore
        else
          @call_params[:truststore_password] = truststore_password
          results = @client.call(self.class, __callee__.to_s, @call_params)
        end

        results
      end

      # Delete AEM Truststore
      #
      # @return RubyAem::Result
      def delete_truststore
        truststore = exists_truststore
        if truststore.data.eql? true
          results = @client.call(self.class, __callee__.to_s, @call_params)
        else
          message = 'Truststore already deleted'
          results = RubyAem::Result.new(message, nil)
          results.data = truststore
        end

        results
      end

      # Delete a specific certificate from the Truststore by alias name or serialnumber.
      #
      # @param params optional parameters:
      # - certalias: Certificate alias name
      # - serial: Certificate serial number
      # @return RubyAem::Result
      def delete_cert(
        params = {
          certalias: nil,
          serial: nil
        }
      )
        certificates = get_certificate(**params).data
        if certificates.empty?
          message = 'No certificates deleted'
          results = RubyAem::Result.new(message, nil)
          results.data = certificates
        else
          certificates.each { |certificate|
            certalias = certificate[:alias]
            results = delete_cert_by_alias(certalias)
          }
        end
        results
      end

      # Delete a specific certificate by certificate alias from the Truststore.
      #
      # @param certalias Certificate alias name
      # @return RubyAem::Result
      def delete_cert_by_alias(certalias)
        certificate = exists_certs(certalias: certalias)
        if certificate.data.eql? true
          @call_params[:certalias] = certalias
          results = @client.call(self.class, __callee__.to_s, @call_params)
        else
          results = certificate
        end

        results
      end

      # Download the AEM Truststore to a specified directory.
      #
      # @param file_path the directory where the Truststore will be downloaded to
      # @return RubyAem::Result
      def download_truststore(
        params = {
          file: nil,
          path: nil
        }
      )
        file_path = "#{params[:path]}/truststore.p12" unless params[:path].eql? nil
        file_path = params[:file] unless params[:file].eql? nil
        @call_params[:file_path] = file_path
        @client.call(self.class, __callee__.to_s, @call_params)
      end

      # Check if a specific certificate exists in the truststore.
      #
      # @param params optional parameters:
      # - certalias: Certificate alias name
      # - serial: Certificate serial number
      # @return RubyAem::Result
      def exists_certs(
        params = {
          certalias: nil,
          serial: nil
        }
      )
        result = get_certificate(**params)
        exists = if result.message.eql? 'Certificate exists'
                   true
                 else
                   false
                 end

        result = RubyAem::Result.new(result.message, result.response)
        result.data = exists

        result
      end

      # Check if AEM Truststore exists
      #
      # @return RubyAem::Result
      def exists_truststore
        result = get_truststore_informations

        exists = if result.message.eql? 'Truststore exists'
                   true
                 else
                   false
                 end

        result = RubyAem::Result.new(result.message, result.response)
        result.data = exists

        result
      end

      # Get specific certificate from truststore.
      #
      # @param params optional parameters:
      # - certalias: Certificate alias name
      # - serial: Certificate serial number
      # @return RubyAem::Result
      def export_certificate(
        params = {
          serial: serial,
          truststore_password: truststore_password
        }
      )
        temp_file = Tempfile.new.path
        exists = exists_certs(serial: params[:serial])
        certificates = []

        if exists.data.eql? true
          download_truststore(file: temp_file)
          result = read_truststore(temp_file, params[:truststore_password])

          unless params[:serial].eql? nil
            result.ca_certs.each { |certificate|
              certificate_serial = certificate.serial.to_i
              next unless certificate_serial.eql? serial
              certificates.push(certificate)
            }
          end

          message = 'Certificate successfully exported'
        else
          message = 'Certificate do not exists'
        end

        results = RubyAem::Result.new(message, nil)
        results.data = certificates

        results
      end

      # Get specific certificate from truststore.
      #
      # @param params optional parameters:
      # - certalias: Certificate alias name
      # - serial: Certificate serial number
      # @return RubyAem::Result
      def get_certificate(
        params = {
          certalias: nil,
          serial: nil
        }
      )
        certalias = params[:certalias]
        serial = params[:serial]
        raise StandardError.new('Please define one of the parameters certalias or serial') if certalias.nil? && serial.nil?
        truststore = exists_truststore
        if truststore.data == true
          result = get_truststore_informations

          certificates = []
          if !certalias.eql? nil
            result.data[:aliases].each { |certificate|
              next unless certificate[:alias].eql? certalias
              certificates.push(certificate)
            }
          elsif !serial.eql? nil
            result.data[:aliases].each { |certificate|
              next unless certificate[:serialNumber].eql? serial
              certificates.push(certificate)
            }
          end

          message = if certificates.empty?
                      'Certificate do not exists'
                    else
                      'Certificate exists'
                    end
          results = RubyAem::Result.new(message, nil)
          results.data = certificates
        else
          results = truststore
        end
        results
      end

      # Read Truststore informations.
      #
      # @return RubyAem::Result
      def get_truststore_informations
        result = @client.call(self.class, __callee__.to_s, @call_params)
        truststore = result.response.body.to_hash
        status_code = result.response.status_code
        if truststore.key?(:exists) && truststore[:exists].eql?(false)
          message = 'Truststore do not exists'
        elsif truststore.key?(:aliases)
          message = 'Truststore exists'
        end
        result = RubyAem::Result.new(message, status_code)
        result.data = truststore

        result
      end

      # Read certificate informations provides as raw text
      #
      # @param certificate_raw Raw certificate
      # @return RubyAem::Result
      def read_cert_raw(certificate_raw)
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

      def read_truststore(file_path, truststore_password)
        truststore_raw = File.read file_path
        truststore = OpenSSL::PKCS12.new(truststore_raw, truststore_password)

        truststore
      end

      # Upload a certificate from a file to the Truststore.
      #
      # @param file_path local file path to certificate file
      # @return RubyAem::Result
      def upload_cert_from_file(file_path)
        truststore = exists_truststore
        if truststore.data.eql? true
          @call_params[:file_path] = file_path
          results = @client.call(self.class, __callee__.to_s, @call_params)
        else
          results = truststore
        end

        results
      end

      # Upload a raw certificate to the Truststore.
      #
      # @param file_path local file path to certificate file
      # @return RubyAem::Result
      def upload_cert_raw(certificate_raw)
        temp_file = Tempfile.new('tmp')
        temp_file.write(certificate_raw)
        temp_file.close
        results = upload_cert_from_file(temp_file.path)

        temp_file.unlink
        results
      end

      # Upload a truststore PKCS12 file.
      #
      # @param file_path local file path to truststore PKCS12 file
      # @return RubyAem::Result
      def upload_truststore_from_file(
        params = {
          file_path: file_path,
          force: false
        }
      )
        truststore = exists_truststore
        if truststore.data == false || params[:force] == true
          @call_params[:file_path] = params[:file_path]
          results = @client.call(self.class, __callee__.to_s, @call_params)
        else
          results = truststore
        end

        results
      end

      # Upload a certificate to the AEM Truststore and waut until the certificate is uploaded.
      #
      # @param opts optional parameters:
      # - file_path: local file path to certificate file
      # - _retries: retries library's options (http://www.rubydoc.info/gems/retries/0.0.5#Usage), restricted to max_tries, base_sleep_seconds, max_sleep_seconds
      # @return RubyAem::Result
      def upload_cert_from_file_wait_until_ready(
        opts = {
          file_path: file_path,
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

        result = upload_cert_from_file(opts[:file_path])
        cert_serial = read_cert_from_file(opts[:file_path])[:serial]

        with_retries(max_tries: opts[:_retries][:max_tries], base_sleep_seconds: opts[:_retries][:base_sleep_seconds], max_sleep_seconds: opts[:_retries][:max_sleep_seconds]) { |retries_count|
          check_result = exists_certs(serial: cert_serial)
          puts format('Upload check #%<retries_count>d: %<check_result_data>s - %<check_result_message>s', retries_count: retries_count, check_result_data: check_result.data, check_result_message: check_result.message)
          raise StandardError.new(check_result.message) if check_result.data == false
        }
        result
      end

      # Upload a certificate to the AEM Truststore and waut until the certificate is uploaded.
      #
      # @param opts optional parameters:
      # - file_path: local file path to certificate file
      # - _retries: retries library's options (http://www.rubydoc.info/gems/retries/0.0.5#Usage), restricted to max_tries, base_sleep_seconds, max_sleep_seconds
      # @return RubyAem::Result
      def upload_cert_raw_wait_until_ready(
        opts = {
          certificate_raw: certificate_raw,
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

        result = upload_cert_raw(opts[:certificate_raw])
        cert_serial = read_cert_raw(opts[:certificate_raw])[:serial]

        with_retries(max_tries: opts[:_retries][:max_tries], base_sleep_seconds: opts[:_retries][:base_sleep_seconds], max_sleep_seconds: opts[:_retries][:max_sleep_seconds]) { |retries_count|
          check_result = exists_certs(serial: cert_serial)
          puts format('Upload check #%<retries_count>d: %<check_result_data>s - %<check_result_message>s', retries_count: retries_count, check_result_data: check_result.data, check_result_message: check_result.message)
          raise StandardError.new(check_result.message) if check_result.data == false
        }
        result
      end

      # Upload a certificate to the AEM Truststore and waut until the certificate is uploaded.
      #
      # @param opts optional parameters:
      # - file_path: local file path to truststore PKCS12 file
      # - _retries: retries library's options (http://www.rubydoc.info/gems/retries/0.0.5#Usage), restricted to max_tries, base_sleep_seconds, max_sleep_seconds
      # @return RubyAem::Result
      def upload_truststore_from_file_wait_until_ready(
        opts = {
          file_path: file_path,
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

        result = upload_truststore_from_file(file_path: opts[:file_path], force: opts[:force])

        with_retries(max_tries: opts[:_retries][:max_tries], base_sleep_seconds: opts[:_retries][:base_sleep_seconds], max_sleep_seconds: opts[:_retries][:max_sleep_seconds]) { |retries_count|
          check_result = exists_truststore
          puts format('Upload check #%<retries_count>d: %<check_result_data>s - %<check_result_message>s', retries_count: retries_count, check_result_data: check_result.data, check_result_message: check_result.message)
          raise StandardError.new(check_result.message) if check_result.data == false
        }
        result
      end
    end
  end
end
