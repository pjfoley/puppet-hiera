require File.expand_path('../../../util/hashextensions', __FILE__)

module Puppet::Parser::Functions
  newfunction(:extract_hashvalues, :type => :rvalue, :doc => <<-EOS
              Returns an array of values that match the user provided key.
              EOS
             ) do |arguments|

               raise(Puppet::ParseError, "extract_hashvalues(): Wrong number of arguments " +
                     "given (#{arguments.size} for 2)") if arguments.size < 2

               backends = arguments[0]
               key = arguments[1]

               unless backends.is_a?(Hash)
                 raise(Puppet::ParseError, 'extract_hashvalues(): Requires a hash to work with')
               end

               backends.extract_hashvalues(key).uniq
  end
end
