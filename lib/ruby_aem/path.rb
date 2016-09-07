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
  class Path

    # Initialise a path
    #
    # @param client RubyAem::Client
    # @param name the name of the path, e.g. /etc/designs
    def initialize(client, name)
      @client = client
      @info = {
        name: name
      }
    end

    def activate(ignore_deactivated, only_modified)
      @info[:ignoredeactivated] = ignore_deactivated
      @info[:onlymodified] = only_modified

      @client.call(self.class, __callee__.to_s, @info)
    end

  end
end
