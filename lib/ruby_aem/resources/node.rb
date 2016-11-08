=begin
Copyright 2016 Shine Solutions

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
=end

module RubyAem
  module Resources
    # Node class contains API calls related to managing an AEM node.
    class Node

      # Initialise a node.
      #
      # @param client RubyAem::Client
      # @param path the path to the node, e.g. /apps/system/
      # @param name the node name, e.g. somenode
      # @return new RubyAem::Resources::Node instance
      def initialize(client, path, name)
        @client = client
        @call_params = {
          path: path,
          name: name
        }

        @call_params[:path] = RubyAem::Swagger.path(@call_params[:path])
      end

      # Create a new node.
      #
      # @param type the node type, e.g. sling:Folder
      # @return RubyAem::Result
      def create(type)
        @call_params[:type] = type
        @client.call(self.class, __callee__.to_s, @call_params)
      end

      # Delete the node.
      #
      # @return RubyAem::Result
      def delete()
        @client.call(self.class, __callee__.to_s, @call_params)
      end

      # Check whether the node exists or not.
      # If the node exists, this method returns a success result.
      # Otherwise it returns a failure result.
      #
      # @return RubyAem::Result
      def exists()
        @client.call(self.class, __callee__.to_s, @call_params)
      end

    end
  end
end
