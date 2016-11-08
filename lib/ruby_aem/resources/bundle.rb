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
    # Bundle class contains API calls related to managing an AEM bundle.
    class Bundle

      # Initialise a bundle.
      #
      # @param client RubyAem::Client
      # @param name the bundle's name, e.g. com.adobe.cq.social.cq-social-forum
      # @return new RubyAem::Resources::Bundle instance
      def initialize(client, name)
        @client = client
        @call_params = {
          name: name
        }
      end

      # Start a bundle.
      #
      # @return RubyAem::Result
      def start
        @client.call(self.class, __callee__.to_s, @call_params)
      end

      # Stop a bundle.
      #
      # @return RubyAem::Result
      def stop
        @client.call(self.class, __callee__.to_s, @call_params)
      end

    end
  end
end
