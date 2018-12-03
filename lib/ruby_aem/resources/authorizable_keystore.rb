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

      # Create AEM Authorizable Keystore.
      #
      # @param password Password for the keystore
      # @return RubyAem::Result
      def create(password)
        @call_params[:password] = password
        @client.call(self.class, __callee__.to_s, @call_params)
      end

      # Change the password of an AEM Authorizable Keystore
      #
      # @param old_password Current password for the authorizable keystore
      # @param new_password New password for the authorizable keystore

      # @return RubyAem::Result
      def change_password(old_password, new_password)
        @call_params[:old_password] = old_password
        @call_params[:new_password] = new_password
        @client.call(self.class, __callee__.to_s, @call_params)
      end

      # Download the AEM Keystore to a specified directory.
      #
      # @param file_path the directory where the Keystore will be downloaded to
      # @return RubyAem::Result
      def download(
        file_path
      )
        @call_params[:file_path] = file_path
        @client.call(self.class, __callee__.to_s, @call_params)
      end

      # Delete AEM Authorizable Keystore
      #
      # @return RubyAem::Result
      def delete
        @client.call(self.class, __callee__.to_s, @call_params)
      end

      # Check if a keystore for the given authorizable id already exists.
      #
      # @return RubyAem::Result
      def exists
        @client.call(self.class, __callee__.to_s, @call_params)
      end

      # Retrieve AEM Authorizable Keystore info.
      #
      # @return RubyAem::Result
      def info
        @client.call(self.class, __callee__.to_s, @call_params)
      end
    end
  end
end
