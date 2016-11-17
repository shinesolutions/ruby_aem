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
    # User class contains API calls related to managing an AEM user.
    class User

      # Initialise a user.
      #
      # @param client RubyAem::Client
      # @param path the path to user node, e.g. /home/users/s/
      # @param name the username of the AEM user, e.g. someuser, admin, johncitizen
      # @return new RubyAem::Resources::User instance
      def initialize(client, path, name)
        @client = client
        @call_params = {
          path: path,
          name: name
        }
      end

      # Create a new user.
      #
      # @param password the password of the AEM user
      # @return RubyAem::Result
      def create(password)
        @call_params[:password] = password
        if !@call_params[:path].match(/^\//)
          @call_params[:path] = "/#{@call_params[:path]}"
        end
        @client.call(self.class, __callee__.to_s, @call_params)
      end

      # Delete the user.
      #
      # @return RubyAem::Result
      def delete()
        result = find_authorizable_id
        @call_params[:authorizable_id] = result.data
        @call_params[:path] = RubyAem::Swagger.path(@call_params[:path])
        @client.call(self.class, __callee__.to_s, @call_params)
      end

      # Check whether the user exists or not.
      # If the user exists, this method returns a true result data, false
      # otherwise.
      #
      # @return RubyAem::Result
      def exists()
        result = find_authorizable_id
        @call_params[:authorizable_id] = result.data
        @call_params[:path] = RubyAem::Swagger.path(@call_params[:path])
        @client.call(self.class, __callee__.to_s, @call_params)
      end

      # Set the user's permission.
      #
      # @param permission_path the path that the user's permission is to be set against, e.g. /etc/replication
      # @param permission_csv comma-separated-values of the user's permission, e.g. read:true,modify:true
      # @return RubyAem::Result
      def set_permission(permission_path, permission_csv)
        @call_params[:permission_path] = permission_path
        @call_params[:permission_csv] = permission_csv
        @client.call(self.class, __callee__.to_s, @call_params)
      end

      # Add user to a group.
      #
      # @param group_path the path to group node, e.g. /home/groups/s/
      # @param group_name the name of the AEM group, e.g. somegroup
      # @return RubyAem::Result
      def add_to_group(group_path, group_name)
        group = RubyAem::Resources::Group.new(@client, group_path, group_name)
        group.add_member(@call_params[:name])
      end

      # Change the user's password.
      #
      # @param old_password the user's old password to be changed from
      # @param new_password the user's new password to be changed to
      # @return RubyAem::Result
      def change_password(old_password, new_password)
        @call_params[:old_password] = old_password
        @call_params[:new_password] = new_password
        @client.call(self.class, __callee__.to_s, @call_params)
      end

      # Find the user's authorizable ID.
      # Return authorizable ID as result data, or nil if authorizable ID
      # cannot be found.
      #
      # @return RubyAem::Result
      def find_authorizable_id()
        @client.call(self.class, __callee__.to_s, @call_params)
      end

    end
  end
end
