# Copyright 2016-2021 Shine Solutions Group
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

module RubyAem
  module Resources
    # Path class contains API calls related to managing an AEM path.
    class Path
      # Initialise a path.
      #
      # @param client RubyAem::Client
      # @param name the name of the path, e.g. /etc/designs
      # @return new RubyAem::Resources::Path instance
      def initialize(client, name)
        @client = client
        @call_params = {
          name: name
        }
      end

      # Activate a path.
      #
      # @param ignore_deactivated if true, then deactivated items in the path will not be activated
      # @param only_modified if true, then only modified items in the path will be activated
      # @return RubyAem::Result
      def activate(ignore_deactivated, only_modified)
        @call_params[:ignoredeactivated] = ignore_deactivated
        @call_params[:onlymodified] = only_modified

        @client.call(self.class, __callee__.to_s, @call_params)
      end

      # Delete a path.
      #
      # @return RubyAem::Result
      def delete
        # The path parameter will be combined with the name parameter
        # in order to delete the full path.
        @call_params[:path] = @call_params[:name]

        @client.call(self.class, __callee__.to_s, @call_params)
      end
    end
  end
end
