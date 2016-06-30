class Bundle

  def initialize(client, name)
    @client = client
    @info = {
      name: name
    }
  end

  def start
    @client.call(self.class, 'start', @info)
  end

  def stop
    @client.call(self.class, 'stop', @info)
  end

end
