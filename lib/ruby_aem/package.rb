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
  class Package

    # Initialise a package
    #
    # @param client RubyAem::Client
    # @param group_name the group name of the package, e.g. somepackagegroup
    # @param package_name the name of the package, e.g. somepackage
    # @param package_version the version of the package, e.g. 1.2.3
    def initialize(client, group_name, package_name, package_version)
      @client = client
      @info = {
        group_name: group_name,
        package_name: package_name,
        package_version: package_version
      }
    end

    def create()
      @client.call(self.class, __callee__.to_s, @info)
    end

    def update(filter)
      @info[:filter] = filter
      @client.call(self.class, __callee__.to_s, @info)
    end

    def delete()
      @client.call(self.class, __callee__.to_s, @info)
    end

    def build()
      @client.call(self.class, __callee__.to_s, @info)
    end

    def install()
      @client.call(self.class, __callee__.to_s, @info)
    end

    def replicate()
      @client.call(self.class, __callee__.to_s, @info)
    end

    def download(file_path)
      @info[:file_path] = file_path
      @client.call(self.class, __callee__.to_s, @info)
    end

    def upload(file_path, force)
      @info[:file_path] = file_path
      @info[:force] = force
      @client.call(self.class, __callee__.to_s, @info)
    end

    def get_filter()
      @client.call(self.class, __callee__.to_s, @info)
    end

    def activate_filter(ignore_deactivated, modified_only)
      result = get_filter()

      results = [result]
      result.data.each { |filter_path|
        path = RubyAem::Path.new(@client, filter_path)
        results.push(path.activate(ignore_deactivated, modified_only))
      }
      results
    end

    def list_all()
      @client.call(self.class, __callee__.to_s, @info)
    end

    def is_uploaded()
      result = list_all()

      if result.is_success?
        packages = result.data
        package = packages.xpath("//packages/package[group=\"#{@info[:group_name]}\" and name=\"#{@info[:package_name]}\" and version=\"#{@info[:package_version]}\"]")

        if package.to_s != ''
          status = 'success'
          message = "Package #{@info[:group_name]}/#{@info[:package_name]}-#{@info[:package_version]} is uploaded"
        else
          status = 'failure'
          message = "Package #{@info[:group_name]}/#{@info[:package_name]}-#{@info[:package_version]} is not uploaded"
        end
        result = RubyAem::Result.new(status, message)
        result.data = package
      end

      result
    end

    def is_installed()
      result = is_uploaded()

      if result.is_success?
        package = result.data
        last_unpacked_by = package.xpath('lastUnpackedBy')

        if not ['<lastUnpackedBy/>', '<lastUnpackedBy>null</lastUnpackedBy>'].include? last_unpacked_by.to_s
          status = 'success'
          message = "Package #{@info[:group_name]}/#{@info[:package_name]}-#{@info[:package_version]} is installed"
        else
          status = 'failure'
          message = "Package #{@info[:group_name]}/#{@info[:package_name]}-#{@info[:package_version]} is not installed"
        end
        result = RubyAem::Result.new(status, message)
      end

      result
    end

  end
end
