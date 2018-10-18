# Returns the contents of a file - or nil
# if the file does not exist. based on file.rb from puppet.

require 'base64'

Puppet::Functions.create_function(:'dehydrated::file') do
  dispatch :getfile do
    required_param 'String', :files
    optional_repeated_param 'String', :more_files
  end

  def getfile(files, *more_files)
    ret = nil
    files = [files] + more_files
    files.each do |file|
      unless Puppet::Util.absolute_path?(file)
        raise(Puppet::ParseError, 'Files must be fully qualified')
      end
      next unless File.exist?(file)
      ret = if file =~ %r{.*\.ocsp$}
              Base64.strict_encode64(File.read(file))
            else
              File.read(file)
            end
    end
    ret
  end
end
