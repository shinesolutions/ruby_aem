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

module RubyAem
  module Resources
    # Group class contains API calls related to managing an AEM group.
    class Group
      # Initialise a group.
      #
      # @param client RubyAem::Client
      # @param path the path to group node, e.g. /home/groups/s/
      # @param name the name of the AEM group, e.g. somegroup
      # @return new RubyAem::Resources::Group instance
      def initialize(client, path, name)
        @client = client
        @call_params = {
          path: path,
          name: name
        }
      end

      # Create a new group.
      #
      # @return RubyAem::Result
      def create
        @call_params[:path] = "/#{@call_params[:path]}" unless @call_params[:path].start_with? '/'
        @client.call(self.class, __callee__.to_s, @call_params)
      end

      # Delete the group.
      #
      # @return RubyAem::Result
      def delete
        result = find_authorizable_id
        @call_params[:authorizable_id] = result.data
        @call_params[:path] = RubyAem::Swagger.path(@call_params[:path])
        @client.call(self.class, __callee__.to_s, @call_params)
      end

      # Check whether the group exists or not.
      # If the group exists, this method returns a true result data,
      # false otherwise.
      #
      # @return RubyAem::Result
      def exists
        result = find_authorizable_id
        @call_params[:authorizable_id] = result.data
        @call_params[:path] = RubyAem::Swagger.path(@call_params[:path])
        @client.call(self.class, __callee__.to_s, @call_params)
      end

      # Set the group's permission.
      #
      # @param permission_path the path that the group's permission is to be set against, e.g. /etc/replication
      # @param permission_csv comma-separated-values of the group's permission, e.g. read:true,modify:true
      # @return RubyAem::Result
      def set_permission(permission_path, permission_csv)
        @call_params[:permission_path] = permission_path
        @call_params[:permission_csv] = permission_csv
        @client.call(self.class, __callee__.to_s, @call_params)
      end

      # Add another group as a member of this group.
      #
      # @param member the name of the member group to be added
      # @return RubyAem::Result
      def add_member(member)
        result = find_authorizable_id
        @call_params[:authorizable_id] = result.data
        @call_params[:member] = member
        @call_params[:path] = RubyAem::Swagger.path(@call_params[:path])
        @client.call(self.class, __callee__.to_s, @call_params)
      end

      # Find the group's authorizable ID.
      # Return authorizable ID as result data, or nil if authorizable ID
      # cannot be found.
      #
      # @return RubyAem::Result
      def find_authorizable_id
        @call_params[:path] = "/#{@call_params[:path]}" unless @call_params[:path].start_with? '/'
        @client.call(self.class, __callee__.to_s, @call_params)
      end
    end
  end
end
