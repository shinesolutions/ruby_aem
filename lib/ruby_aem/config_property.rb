module RubyAem
  class ConfigProperty

    def initialize(client, name, type, value)
      @client = client
      @info = {
        name: name,
        type: type,
        value: value
      }
    end

    def create(run_mode)

      # map AEM property name to swagger_aem's sanitised name
      name = @info[:name].gsub(/\./, '_')

      @info[:run_mode] = run_mode
      @info["#{name}".to_sym] = @info[:value]
      @info["#{name}_type_hint".to_sym] = @info[:type]

      @client.call(self.class, __callee__.to_s, @info)
    end

  end
end
