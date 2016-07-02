module RubyAem
  class User

    def initialize(client, path, name)
      @client = client
      @info = {
        path: path,
        name: name
      }
    end

    def create(password)
      @info[:password] = password
      if !@info[:path].match(/^\//)
        @info[:path] = "/#{@info[:path]}"
      end
      @client.call(self.class, __callee__.to_s, @info)
    end

    def delete()
      result = find_authorizable_id
      if result.data
        @info[:path] = @info[:path].gsub(/^\//, '').gsub(/\/$/, '')
        @client.call(self.class, __callee__.to_s, @info)
      else
        result
      end
    end

    def exists()
      @info[:path] = @info[:path].gsub(/^\//, '').gsub(/\/$/, '')
      @client.call(self.class, __callee__.to_s, @info)
    end

    def find_authorizable_id()
      @client.call(self.class, __callee__.to_s, @info)
    end

  end
end
