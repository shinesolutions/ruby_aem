module RubyAem
  class FlushAgent

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
