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

require 'retries'

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
      def create
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
      def delete
        @client.call(self.class, __callee__.to_s, @call_params)
      end

      # Build the package.
      #
      # @return RubyAem::Result
      def build
        @client.call(self.class, __callee__.to_s, @call_params)
      end

      # Install the package without waiting until the package status states it is installed.
      #
      # @param opts optional parameters:
      # - recursive: if true then subpackages will also be installed, false otherwise
      # @return RubyAem::Result
      def install(opts = {
        recursive: true
      })
        @call_params = @call_params.merge(opts)
        @client.call(self.class, __callee__.to_s, @call_params)
      end

      # Uninstall the package.
      #
      # @return RubyAem::Result
      def uninstall
        @client.call(self.class, __callee__.to_s, @call_params)
      end

      # Replicate the package.
      # Package will then be added to replication agents.
      #
      # @return RubyAem::Result
      def replicate
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

      # Upload the package without waiting until the package status states it is uploaded.
      #
      # @param file_path the directory where the package file to be uploaded is
      # @param opts optional parameters:
      # - force: if false then a package file will not be uploaded when the package already exists with the same group, name, and version, default is true (will overwrite existing package file)
      # @return RubyAem::Result
      def upload(
        file_path,
        opts = {
          force: true
        }
      )
        @call_params[:file_path] = file_path
        @call_params = @call_params.merge(opts)
        @client.call(self.class, __callee__.to_s, @call_params)
      end

      # Get the package filter value.
      # Filter value is stored as result data as an array of paths.
      #
      # @return RubyAem::Result
      def get_filter
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
        result = get_filter

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
      def list_all
        @client.call(self.class, __callee__.to_s, @call_params)
      end

      # Check if this package is uploaded.
      # True result data indicates that the package is uploaded, false otherwise.
      #
      # @return RubyAem::Result
      def is_uploaded
        packages = list_all.data
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
      def is_installed
        packages = list_all.data
        package = packages.xpath("//packages/package[group=\"#{@call_params[:group_name]}\" and name=\"#{@call_params[:package_name]}\" and version=\"#{@call_params[:package_version]}\"]")
        last_unpacked_by = package.xpath('lastUnpackedBy')

        if not ['', '<lastUnpackedBy/>', '<lastUnpackedBy>null</lastUnpackedBy>'].include? last_unpacked_by.to_s
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

      # Upload the package and wait until the package status states it is uploaded.
      #
      # @param file_path the directory where the package file to be uploaded is
      # @param opts optional parameters:
      # - force: if false then a package file will not be uploaded when the package already exists with the same group, name, and version, default is true (will overwrite existing package file)
      # - _retries: retries library's options (http://www.rubydoc.info/gems/retries/0.0.5#Usage), restricted to max_trie, base_sleep_seconds, max_sleep_seconds
      # @return RubyAem::Result
      def upload_wait_until_ready(
        file_path,
        opts = {
          force: true,
          _retries: {
            max_tries: 30,
            base_sleep_seconds: 2,
            max_sleep_seconds: 2
          }
        }
      )
        opts[:force] ||= true
        opts[:_retries] ||= {}
        opts[:_retries][:max_tries] ||= 30
        opts[:_retries][:base_sleep_seconds] ||= 2
        opts[:_retries][:max_sleep_seconds] ||= 2

        # ensure integer retries setting (Puppet 3 passes numeric string)
        opts[:_retries][:max_tries] = opts[:_retries][:max_tries].to_i
        opts[:_retries][:base_sleep_seconds] = opts[:_retries][:base_sleep_seconds].to_i
        opts[:_retries][:max_sleep_seconds] = opts[:_retries][:max_sleep_seconds].to_i

        result = upload(file_path, opts)
        with_retries(max_tries: opts[:_retries][:max_tries], base_sleep_seconds: opts[:_retries][:base_sleep_seconds], max_sleep_seconds: opts[:_retries][:max_sleep_seconds]) { |retries_count|
          check_result = is_uploaded
          puts format('Upload check #%d: %s - %s', retries_count, check_result.data, check_result.message)
          if check_result.data == false
            raise StandardError.new(check_result.message)
          end
        }
        result
      end

      # Install the package and wait until the package status states it is installed.
      #
      # @param opts optional parameters:
      # - _retries: retries library's options (http://www.rubydoc.info/gems/retries/0.0.5#Usage), restricted to max_trie, base_sleep_seconds, max_sleep_seconds
      # @return RubyAem::Result
      def install_wait_until_ready(
        opts = {
          _retries: {
            max_tries: 30,
            base_sleep_seconds: 2,
            max_sleep_seconds: 2
          }
        })
        opts[:_retries] ||= {}
        opts[:_retries][:max_tries] ||= 30
        opts[:_retries][:base_sleep_seconds] ||= 2
        opts[:_retries][:max_sleep_seconds] ||= 2

        # ensure integer retries setting (Puppet 3 passes numeric string)
        opts[:_retries][:max_tries] = opts[:_retries][:max_tries].to_i
        opts[:_retries][:base_sleep_seconds] = opts[:_retries][:base_sleep_seconds].to_i
        opts[:_retries][:max_sleep_seconds] = opts[:_retries][:max_sleep_seconds].to_i

        result = install
        with_retries(max_tries: opts[:_retries][:max_tries], base_sleep_seconds: opts[:_retries][:base_sleep_seconds], max_sleep_seconds: opts[:_retries][:max_sleep_seconds]) { |retries_count|
          check_result = is_installed
          puts format('Install check #%d: %s - %s', retries_count, check_result.data, check_result.message)
          if check_result.data == false
            raise StandardError.new(check_result.message)
          end
        }
        result
      end

      # Delete the package and wait until the package status states it is not uploaded.
      #
      # @param opts optional parameters:
      # - _retries: retries library's options (http://www.rubydoc.info/gems/retries/0.0.5#Usage), restricted to max_trie, base_sleep_seconds, max_sleep_seconds
      # @return RubyAem::Result
      def delete_wait_until_ready(
        opts = {
          _retries: {
            max_tries: 30,
            base_sleep_seconds: 2,
            max_sleep_seconds: 2
          }
        })
        opts[:_retries] ||= {}
        opts[:_retries][:max_tries] ||= 30
        opts[:_retries][:base_sleep_seconds] ||= 2
        opts[:_retries][:max_sleep_seconds] ||= 2

        # ensure integer retries setting (Puppet 3 passes numeric string)
        opts[:_retries][:max_tries] = opts[:_retries][:max_tries].to_i
        opts[:_retries][:base_sleep_seconds] = opts[:_retries][:base_sleep_seconds].to_i
        opts[:_retries][:max_sleep_seconds] = opts[:_retries][:max_sleep_seconds].to_i

        result = delete
        with_retries(max_tries: opts[:_retries][:max_tries], base_sleep_seconds: opts[:_retries][:base_sleep_seconds], max_sleep_seconds: opts[:_retries][:max_sleep_seconds]) { |retries_count|
          check_result = is_uploaded
          puts format('Delete check #%d: %s - %s', retries_count, !check_result.data, check_result.message)
          if check_result.data == true
            raise StandardError.new(check_result.message)
          end
        }
        result
      end
    end
  end
end
