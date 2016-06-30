class Repository

  def initialize(client)
    @client = client
    @info = {}
  end

  def block_writes
    @client.call(self.class, 'block_writes', @info)
  end

  def unblock_writes
    @client.call(self.class, 'unblock_writes', @info)
  end

end
