module Puppet::Parser::Functions
  newfunction(:keysdir, :type => :rvalue, :doc => <<-EOS
              Returns the directory name for a file.  If the directory path contains a keys subdirectory remove it from the path.
              EOS
             ) do |arguments|

               raise(Puppet::ParseError, "keysdir(): Wrong number of arguments " +
                     "given (#{arguments.size} for 1)") if arguments.size != 1

               key = arguments[0]

               unless key.is_a?(String)
                 raise(Puppet::ParseError, 'keysdir(): Requires a string to work with')
               end

               dir = File.dirname(key)
               if File.basename(dir) == 'keys'
                 File.dirname(dir)
               else
                 dir
               end
  end
end

