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

    def set_permission(permission_path, permission_csv)
      @info[:permission_path] = permission_path
      @info[:permission_csv] = permission_csv
      @client.call(self.class, __callee__.to_s, @info)
    end

    def add_to_group(group_path, group_name)
      group_info = @info.dup
      group_info[:name] = group_name
      group_info[:path] = group_path
      result = @client.call(self.class, 'find_authorizable_id', group_info)
      if result.data
        @info[:group_path] = group_path
        @info[:group_authorizable_id] = result.data
        @client.call(self.class, __callee__.to_s, @info)
      else
        result
      end
    end

    def change_password(old_password, new_password)
      @info[:old_password] = old_password
      @info[:new_password] = new_password
      @client.call(self.class, __callee__.to_s, @info)
    end

    def find_authorizable_id()
      @client.call(self.class, __callee__.to_s, @info)
    end

  end
end
