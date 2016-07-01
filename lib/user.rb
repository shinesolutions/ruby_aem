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
    @client.call(self.class, __callee__.to_s, @info)
  end

  def delete()
    @client.call(self.class, __callee__.to_s, @info)
  end

  def exists()
    @client.call(self.class, __callee__.to_s, @info)
  end

end
