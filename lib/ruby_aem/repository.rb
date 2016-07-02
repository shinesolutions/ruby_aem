module RubyAem
  class Repository

    def initialize(client)
      @client = client
      @info = {}
    end

    def block_writes
      @client.call(self.class, __callee__.to_s, @info)
    end

    def unblock_writes
      @client.call(self.class, __callee__.to_s, @info)
    end

  end
end
