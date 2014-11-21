require File.expand_path('../../../util/hashextensions', __FILE__)

module Puppet::Parser::Functions
  newfunction(:extract_hashvalues, :type => :rvalue, :doc => <<-EOS
              Returns an array of values that match the user provided key.
              EOS
             ) do |arguments|

               raise(Puppet::ParseError, "extract_hashvalues(): Wrong number of arguments " +
                     "given (#{arguments.size} for 2)") if arguments.size != 2

               backends = arguments[0]
               key = arguments[1]

               unless backends.is_a?(Hash)
                 raise(Puppet::ParseError, 'extract_hashvalues(): Requires the first argument to be a hash')
               end

               unless key.is_a?(String) || (key.is_a?(Array) && arr_all_strings?(key))
                 raise(Puppet::ParseError, 'extract_hashvalues(): Requires the second argument to be a string or array of strings')
               end

               backends.extract_hashvalues(key).uniq
  end
end
