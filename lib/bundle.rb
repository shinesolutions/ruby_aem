class Bundle

  def initialize(client, name)
    @client = client
    @info = {
      name: name
    }
  end

  def start
    @client.call(self.class, __callee__.to_s, @info)
  end

  def stop
    @client.call(self.class, __callee__.to_s, @info)
  end

end
