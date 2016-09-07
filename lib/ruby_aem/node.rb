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
  class Node

    # Initialise a node
    #
    # @param client RubyAem::Client
    # @param path the path to the node, e.g. /apps/system/
    # @param name the node name, e.g. somenode
    def initialize(client, path, name)
      @client = client
      @info = {
        path: path,
        name: name
      }

      @info[:path] = RubyAem::Swagger.path(@info[:path])
    end

    def create(type)
      @info[:type] = type
      @client.call(self.class, __callee__.to_s, @info)
    end

    def delete()
      @client.call(self.class, __callee__.to_s, @info)
    end

    def exists()
      @client.call(self.class, __callee__.to_s, @info)
    end

  end
end
