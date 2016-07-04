module RubyAem
  class Package

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

    def delete()
      @client.call(self.class, __callee__.to_s, @info)
    end

  end
end
