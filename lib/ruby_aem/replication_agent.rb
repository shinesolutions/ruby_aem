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
  class ReplicationAgent

    def initialize(client, run_mode, name)
      @client = client
      @info = {
        run_mode: run_mode,
        name: name
      }
    end

    def create_update(title, description, dest_base_url)
      @info[:title] = title
      @info[:description] = description
      @info[:dest_base_url] = dest_base_url
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
