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
        @call_params = {
          group_name: group_name,
          package_name: package_name,
          package_version: package_version
        }
      end

      # Create the package.
      #
      # @return RubyAem::Result
      def create()
        @client.call(self.class, __callee__.to_s, @call_params)
      end

      # Update the package with specific filter.
      #
      # @param filter package filter JSON string
      # example: [{"root":"/apps/geometrixx","rules":[]},{"root":"/apps/geometrixx-common","rules":[]}]
      # @return RubyAem::Result
      def update(filter)
        @call_params[:filter] = filter
        @client.call(self.class, __callee__.to_s, @call_params)
      end

      # Delete the package.
      #
      # @return RubyAem::Result
      def delete()
        @client.call(self.class, __callee__.to_s, @call_params)
      end

      # Build the package.
      #
      # @return RubyAem::Result
      def build()
        @client.call(self.class, __callee__.to_s, @call_params)
      end

      # Install the package.
      #
      # @return RubyAem::Result
      def install()
        @client.call(self.class, __callee__.to_s, @call_params)
      end

      # Replicate the package.
      # Package will then be added to replication agents.
      #
      # @return RubyAem::Result
      def replicate()
        @client.call(self.class, __callee__.to_s, @call_params)
      end

      # Download the package to a specified directory.
      #
      # @param file_path the directory where the package will be downloaded to
      # @return RubyAem::Result
      def download(file_path)
        @call_params[:file_path] = file_path
        @client.call(self.class, __callee__.to_s, @call_params)
      end

      # Upload the package.
      #
      # @param file_path the directory where the package file to be uploaded is
      # @param force if true, then overwrite if the package already exists
      # @param opts optional parameters:
      # - force: if false then a package file will not be uploaded when the package already exists with the same group, name, and version, default is true (will overwrite existing package file)
      # @return RubyAem::Result
      def upload(file_path,
        opts = {
          force: true
        })
        @call_params[:file_path] = file_path
        @call_params = @call_params.merge(opts)
        @client.call(self.class, __callee__.to_s, @call_params)
      end

      # Get the package filter value.
      # Filter value is stored as result data as an array of paths.
      #
      # @return RubyAem::Result
      def get_filter()
        @client.call(self.class, __callee__.to_s, @call_params)
      end

      # Activate all paths within a package filter.
      # Returns an array of results:
      # - the first result is the result from retrieving filter paths
      # - the rest of the results are the results from activating the filter paths, one result for each activation
      #
      # @param ignore_deactivated if true, then deactivated items in the path will not be activated
      # @param modified_only if true, then only modified items in the path will be activated
      # @return an array of RubyAem::Result
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
        @client.call(self.class, __callee__.to_s, @call_params)
      end

      # Check if this package is uploaded.
      # True result data indicates that the package is uploaded, false otherwise.
      #
      # @return RubyAem::Result
      def is_uploaded()
        packages = list_all().data
        package = packages.xpath("//packages/package[group=\"#{@call_params[:group_name]}\" and name=\"#{@call_params[:package_name]}\" and version=\"#{@call_params[:package_version]}\"]")

        if package.to_s != ''
          message = "Package #{@call_params[:group_name]}/#{@call_params[:package_name]}-#{@call_params[:package_version]} is uploaded"
          is_uploaded = true
        else
          message = "Package #{@call_params[:group_name]}/#{@call_params[:package_name]}-#{@call_params[:package_version]} is not uploaded"
          is_uploaded = false
        end
        result = RubyAem::Result.new(message, nil)
        result.data = is_uploaded

        result
      end

      # Check if this package is installed.
      # True result data indicates that the package is installed, false otherwise.
      #
      # @return RubyAem::Result
      def is_installed()
        packages = list_all().data
        package = packages.xpath("//packages/package[group=\"#{@call_params[:group_name]}\" and name=\"#{@call_params[:package_name]}\" and version=\"#{@call_params[:package_version]}\"]")
        last_unpacked_by = package.xpath('lastUnpackedBy')

        if not ['<lastUnpackedBy/>', '<lastUnpackedBy>null</lastUnpackedBy>'].include? last_unpacked_by.to_s
          message = "Package #{@call_params[:group_name]}/#{@call_params[:package_name]}-#{@call_params[:package_version]} is installed"
          is_installed = true
        else
          message = "Package #{@call_params[:group_name]}/#{@call_params[:package_name]}-#{@call_params[:package_version]} is not installed"
          is_installed = false
        end
        result = RubyAem::Result.new(message, nil)
        result.data = is_installed

        result
      end

    end
  end
end
