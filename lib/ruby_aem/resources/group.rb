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
      def create()
        if !@call_params[:path].match(/^\//)
          @call_params[:path] = "/#{@call_params[:path]}"
        end
        @client.call(self.class, __callee__.to_s, @call_params)
      end

      # Delete the group.
      #
      # @return RubyAem::Result
      def delete()
        result = find_authorizable_id
        if result.data
          @call_params[:path] = RubyAem::Swagger.path(@call_params[:path])
          @client.call(self.class, __callee__.to_s, @call_params)
        else
          result
        end
      end

      # Check whether the group exists or not.
      # If the group exists, this method returns a success result.
      # Otherwise it returns a failure result.
      #
      # @return RubyAem::Result
      def exists()
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
        if result.data
          @call_params[:member] = member
          @client.call(self.class, __callee__.to_s, @call_params)
        else
          result
        end
      end

      # Find the group's authorizable ID.
      #
      # @return RubyAem::Result
      def find_authorizable_id()
        @client.call(self.class, __callee__.to_s, @call_params)
      end

    end
  end
end
