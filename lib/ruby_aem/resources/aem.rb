# Copyright 2016-2019 Shine Solutions
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

require 'nori'
require 'retries'
require 'ruby_aem/error'

module RubyAem
  #  AEM resources
  module Resources
    # AEM class contains API calls related to managing the AEM instance itself.
    class Aem
      # Initialise an AEM instance.
      #
      # @param client RubyAem::Client
      # @return new RubyAem::Resources::Aem instance
      def initialize(client)
        @client = client
        @call_params = {
        }
      end

      # Retrieve AEM login page.
      #
      # @return RubyAem::Result
      def get_login_page
        @client.call(self.class, __callee__.to_s, @call_params)
      end

      # Retrieve AEM CRXDE Status
      #
      # @return RubyAem::Result
      def get_crxde_status
        @client.call(self.class, __callee__.to_s, @call_params)
      end

      # Retrieve AEM Health Check.
      # This is a custom API and requires
      # https://github.com/shinesolutions/aem-healthcheck
      # to be installed.
      #
      # @param opts optional parameters:
      # - tags: comma separated tags of AEM Health Check tags
      # - combine_tags_or: if true, the check needs to only pass one of the check tags in order to get the health check pass,
      #   if false, all check tags need to pass in order to get the health check pass.
      # @return RubyAem::Result
      def get_aem_health_check(opts = {})
        @call_params = @call_params.merge(opts)
        @client.call(self.class, __callee__.to_s, @call_params)
      end

      # Retrieve AEM CRX Package Manager Servlet service state.
      #
      # @return RubyAem::Result
      def get_package_manager_servlet_state
        @client.call(self.class, __callee__.to_s, @call_params)
      end

      # Retrieve AEM login page with retries until it is successful.
      #
      # @param opts optional parameters:
      # - _retries: retries library's options (http://www.rubydoc.info/gems/retries/0.0.5#Usage), restricted to max_trie, base_sleep_seconds, max_sleep_seconds
      # @return RubyAem::Result
      def get_login_page_wait_until_ready(
        opts = {
          _retries: {
            max_tries: 30,
            base_sleep_seconds: 2,
            max_sleep_seconds: 2
          }
        }
      )
        opts[:_retries] ||= {}
        opts[:_retries][:max_tries] ||= 30
        opts[:_retries][:base_sleep_seconds] ||= 2
        opts[:_retries][:max_sleep_seconds] ||= 2

        # ensure integer retries setting (Puppet 3 passes numeric string)
        opts[:_retries][:max_tries] = opts[:_retries][:max_tries].to_i
        opts[:_retries][:base_sleep_seconds] = opts[:_retries][:base_sleep_seconds].to_i
        opts[:_retries][:max_sleep_seconds] = opts[:_retries][:max_sleep_seconds].to_i

        result = nil
        with_retries(max_tries: opts[:_retries][:max_tries], base_sleep_seconds: opts[:_retries][:base_sleep_seconds], max_sleep_seconds: opts[:_retries][:max_sleep_seconds]) { |retries_count|
          begin
            result = get_login_page
            if result.response.body !~ /QUICKSTART_HOMEPAGE/
              puts format('Retrieve login page attempt #%<retries_count>d: %<message>s but not ready yet', retries_count: retries_count, message: result.message)
              raise StandardError.new(result.message)
            else
              puts format('Retrieve login page attempt #%<retries_count>d: %<message>s and ready', retries_count: retries_count, message: result.message)
            end
          rescue RubyAem::Error => err
            puts format('Retrieve login page attempt #%<retries_count>d: %<message>s', retries_count: retries_count, message: err.message)
            raise StandardError.new(err.message)
          end
        }
        result
      end

      # Retrieve AEM health check with retries until its status is OK.
      #
      # @param opts optional parameters:
      # - _retries: retries library's options (http://www.rubydoc.info/gems/retries/0.0.5#Usage), restricted to max_trie, base_sleep_seconds, max_sleep_seconds
      # @return RubyAem::Result
      def get_aem_health_check_wait_until_ok(
        opts = {
          _retries: {
            max_tries: 30,
            base_sleep_seconds: 2,
            max_sleep_seconds: 2
          }
        }
      )
        opts[:_retries] ||= {}
        opts[:_retries][:max_tries] ||= 30
        opts[:_retries][:base_sleep_seconds] ||= 2
        opts[:_retries][:max_sleep_seconds] ||= 2

        # ensure integer retries setting (Puppet 3 passes numeric string)
        opts[:_retries][:max_tries] = opts[:_retries][:max_tries].to_i
        opts[:_retries][:base_sleep_seconds] = opts[:_retries][:base_sleep_seconds].to_i
        opts[:_retries][:max_sleep_seconds] = opts[:_retries][:max_sleep_seconds].to_i

        result = nil
        with_retries(max_tries: opts[:_retries][:max_tries], base_sleep_seconds: opts[:_retries][:base_sleep_seconds], max_sleep_seconds: opts[:_retries][:max_sleep_seconds]) { |retries_count|
          begin
            result = get_aem_health_check(tags: opts[:tags], combine_tags_or: opts[:combine_tags_or])
            is_ok = true
            result.data.each { |check|
              if check['status'] != 'OK'
                is_ok = false
                break
              end
            }
            if is_ok == false
              puts format('Retrieve AEM Health Check attempt #%<retries_count>d: %<message>s but not ok yet', retries_count: retries_count, message: result.message)
              raise StandardError.new(result.message)
            else
              puts format('Retrieve AEM Health Check attempt #%<retries_count>d: %<message>s and ok', retries_count: retries_count, message: result.message)
            end
          rescue RubyAem::Error => err
            puts format('Retrieve AEM Health Check attempt #%<retries_count>d: %<message>s', retries_count: retries_count, message: err.message)
            raise StandardError.new(err.message)
          end
        }
        result
      end

      # Retrieve AEM CRX Package Manager Servlet service state. with retries until its status is OK.
      #
      # @param opts optional parameters:
      # - _retries: retries library's options (http://www.rubydoc.info/gems/retries/0.0.5#Usage), restricted to max_trie, base_sleep_seconds, max_sleep_seconds
      # @return RubyAem::Result
      def get_package_manager_servlet_state_wait_until_ready(
        opts = {
          _retries: {
            max_tries: 30,
            base_sleep_seconds: 2,
            max_sleep_seconds: 2
          }
        }
      )
        opts[:_retries] ||= {}
        opts[:_retries][:max_tries] ||= 30
        opts[:_retries][:base_sleep_seconds] ||= 2
        opts[:_retries][:max_sleep_seconds] ||= 2

        # ensure integer retries setting (Puppet 3 passes numeric string)
        opts[:_retries][:max_tries] = opts[:_retries][:max_tries].to_i
        opts[:_retries][:base_sleep_seconds] = opts[:_retries][:base_sleep_seconds].to_i
        opts[:_retries][:max_sleep_seconds] = opts[:_retries][:max_sleep_seconds].to_i

        result = nil
        with_retries(max_tries: opts[:_retries][:max_tries], base_sleep_seconds: opts[:_retries][:base_sleep_seconds], max_sleep_seconds: opts[:_retries][:max_sleep_seconds]) { |retries_count|
          result = get_package_manager_servlet_state
          puts format('Check CRX Package Manager service attempt #%<retries_count>d: %<result_message>s', retries_count: retries_count, result_message: result.message)
          raise StandardError.new(result.message) if result.data == false
        }
        result
      end

      # List the name of all agents under /etc/replication.
      #
      # @param run_mode AEM run mode: author or publish
      # @return RubyAem::Result
      def get_agents(run_mode)
        @call_params[:run_mode] = run_mode
        @client.call(self.class, __callee__.to_s, @call_params)
      end

      # Retrieve AEM install status.
      #
      # @return RubyAem::Result
      def get_install_status
        @client.call(self.class, __callee__.to_s, @call_params)
      end

      # Retrieve AEM install status with retries until its status is finished
      #
      # @param opts optional parameters:
      # - _retries: retries library's options (http://www.rubydoc.info/gems/retries/0.0.5#Usage), restricted to max_trie, base_sleep_seconds, max_sleep_seconds
      # @return RubyAem::Result
      def get_install_status_wait_until_finished(
        opts = {
          _retries: {
            max_tries: 30,
            base_sleep_seconds: 2,
            max_sleep_seconds: 2
          }
        }
      )
        opts[:_retries] ||= {}
        opts[:_retries][:max_tries] ||= 30
        opts[:_retries][:base_sleep_seconds] ||= 2
        opts[:_retries][:max_sleep_seconds] ||= 2

        # ensure integer retries setting (Puppet 3 passes numeric string)
        opts[:_retries][:max_tries] = opts[:_retries][:max_tries].to_i
        opts[:_retries][:base_sleep_seconds] = opts[:_retries][:base_sleep_seconds].to_i
        opts[:_retries][:max_sleep_seconds] = opts[:_retries][:max_sleep_seconds].to_i

        result = nil
        with_retries(max_tries: opts[:_retries][:max_tries], base_sleep_seconds: opts[:_retries][:base_sleep_seconds], max_sleep_seconds: opts[:_retries][:max_sleep_seconds]) { |retries_count|
          begin
            result = get_install_status
            item_count = result.response.body.status.item_count
            if result.response.body.status.finished == true && item_count.zero?
              puts format('Retrieve AEM install status attempt #%<retries_count>d: %<message>s and finished', retries_count: retries_count, message: result.message)
            else
              puts format('Retrieve AEM install status attempt #%<retries_count>d: %<message>s but not finished yet, still installing %<item_count>d package(s)', retries_count: retries_count, message: result.message, item_count: item_count)
              raise StandardError.new(result.message)
            end
          rescue RubyAem::Error => err
            puts format('Retrieve AEM install status attempt #%<retries_count>d: %<message>s', retries_count: retries_count, message: err.message)
            raise StandardError.new(err.message)
          end
        }
        result
      end

      # Get a list of all packages available on AEM instance.
      # The list of packages are returned as result data.
      # Example:
      # {
      #    "group"          => "shinesolutions",
      #    "name"           => "aem-password-reset-content",
      #    "version"        => "1.0.1",
      #    "downloadName"   => "aem-password-reset-content-1.0.1.zip",
      #    "size"           => "23579",
      #    "created"        => "Tue, 4   Apr 2017 13:38:35   +1000",
      #    "createdBy"      => "root",
      #    "lastModified"   => nil,
      #    "lastModifiedBy" => "null",
      #    "lastUnpacked"   => "Wed, 18   Apr 2018 22:57:01   +1000",
      #    "lastUnpackedBy" => "admin"
      # }
      #
      # @return RubyAem::Result
      def get_packages
        result = @client.call(self.class, __callee__.to_s, @call_params)
        packages = Nori.new.parse(result.data.to_s)['packages']['package']
        result_copy = RubyAem::Result.new(result.message, result.response)
        result_copy.data = packages
        result_copy
      end

      # Retrieve AEM Product informations
      #
      # @return RubyAem::Result
      def get_product_info
        @client.call(self.class, __callee__.to_s, @call_params)
      end
    end
  end
end
