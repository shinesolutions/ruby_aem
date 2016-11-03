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
    # Package class contains API calls related to managing an AEM package.
    class Package

      # Initialise a package.
      # Package name and version will then be used to construct the package file in the filesystem.
      # E.g. package name 'somepackage' with version '1.2.3' will translate to somepackage-1.2.3.zip in the filesystem.
      #
      # @param client RubyAem::Client
      # @param group_name the group name of the package, e.g. somepackagegroup
      # @param package_name the name of the package, e.g. somepackage
      # @param package_version the version of the package, e.g. 1.2.3
      # @return new RubyAem::Resources::Package instance
      def initialize(client, group_name, package_name, package_version)
        @client = client
        @info = {
          group_name: group_name,
          package_name: package_name,
          package_version: package_version
        }
      end

      # Create the package.
      #
      # @return RubyAem::Result
      def create()
        @client.call(self.class, __callee__.to_s, @info)
      end

      # Update the package with specific filter.
      #
      # @param filter package filter JSON string
      # @return RubyAem::Result
      def update(filter)
        @info[:filter] = filter
        @client.call(self.class, __callee__.to_s, @info)
      end

      # Delete the package.
      #
      # @return RubyAem::Result
      def delete()
        @client.call(self.class, __callee__.to_s, @info)
      end

      # Build the package.
      #
      # @return RubyAem::Result
      def build()
        @client.call(self.class, __callee__.to_s, @info)
      end

      # Install the package.
      #
      # @return RubyAem::Result
      def install()
        @client.call(self.class, __callee__.to_s, @info)
      end

      # Replicate the package.
      # Package will then be added to replication agents.
      #
      # @return RubyAem::Result
      def replicate()
        @client.call(self.class, __callee__.to_s, @info)
      end

      # Download the package to a specified directory.
      #
      # @param file_path the directory where the package will be downloaded to
      # @return RubyAem::Result
      def download(file_path)
        @info[:file_path] = file_path
        @client.call(self.class, __callee__.to_s, @info)
      end

      # Upload the package.
      #
      # @param file_path the directory where the package file to be uploaded is
      # @param force if true, then overwrite if the package already exists
      # @return RubyAem::Result
      def upload(file_path, force)
        @info[:file_path] = file_path
        @info[:force] = force
        @client.call(self.class, __callee__.to_s, @info)
      end

      # Get the package filter value.
      # Filter value is stored in result's data.
      #
      # @return RubyAem::Result
      def get_filter()
        @client.call(self.class, __callee__.to_s, @info)
      end

      # Activate all paths within a package filter.
      #
      # @param ignore_deactivated if true, then deactivated items in the path will not be activated
      # @param modified_only if true, then only modified items in the path will be activated
      # @return RubyAem::Result
      def activate_filter(ignore_deactivated, modified_only)
        result = get_filter()

        results = [result]
        result.data.each { |filter_path|
          path = RubyAem::Resources::Path.new(@client, filter_path)
          results.push(path.activate(ignore_deactivated, modified_only))
        }
        results
      end

      # List all packages available in AEM instance.
      #
      # @return RubyAem::Result
      def list_all()
        @client.call(self.class, __callee__.to_s, @info)
      end

      # Check if this package is uploaded.
      # Success result indicates that the package is uploaded.
      # Otherwise a failure result indicates that package is not uploaded.
      #
      # @return RubyAem::Result
      def is_uploaded()
        result = list_all()

        begin
          packages = result.data
          package = packages.xpath("//packages/package[group=\"#{@info[:group_name]}\" and name=\"#{@info[:package_name]}\" and version=\"#{@info[:package_version]}\"]")

          if package.to_s != ''
            message = "Package #{@info[:group_name]}/#{@info[:package_name]}-#{@info[:package_version]} is uploaded"
          else
            message = "Package #{@info[:group_name]}/#{@info[:package_name]}-#{@info[:package_version]} is not uploaded"
          end
          result = RubyAem::Result.new(message, nil)
          result.data = package
        rescue RubyAem::Error => err
        end

        result
      end

      # Check if this package is installed.
      # Success result indicates that the package is installed.
      # Otherwise a failure result indicates that package is not installed.
      #
      # @return RubyAem::Result
      def is_installed()
        result = is_uploaded()

        begin
          package = result.data
          last_unpacked_by = package.xpath('lastUnpackedBy')

          if not ['<lastUnpackedBy/>', '<lastUnpackedBy>null</lastUnpackedBy>'].include? last_unpacked_by.to_s
            message = "Package #{@info[:group_name]}/#{@info[:package_name]}-#{@info[:package_version]} is installed"
          else
            message = "Package #{@info[:group_name]}/#{@info[:package_name]}-#{@info[:package_version]} is not installed"
          end
          result = RubyAem::Result.new(message, nil)
        rescue RubyAem::Error => err
        end

        result
      end

    end
  end
end
