module RubyAem
  module Handlers

    def Handlers.file_download(data, status_code, headers, response_spec, info)

      FileUtils.cp(data.path, "#{info[:file_path]}/#{info[:package_name]}-#{info[:package_version]}.zip")
      data.delete

      message = response_spec['message'] % info

      RubyAem::Result.new('success', message)
    end

  end
end
