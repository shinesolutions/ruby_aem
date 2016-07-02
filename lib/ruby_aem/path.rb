module RubyAem
  class Path

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
