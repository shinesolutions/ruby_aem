class Node

  def initialize(client, path, name)
    @client = client
    @info = {
      path: path,
      name: name
    }

    @info[:path] = @info[:path].gsub(/^\//, '').gsub(/\/$/, '')
  end

  def create(type)
    @info[:type] = type
    @client.call(self.class, __callee__.to_s, @info)
  end

  def delete()
    @client.call(self.class, __callee__.to_s, @info)
  end

  def exists()
    @client.call(self.class, __callee__.to_s, @info)
  end

end
