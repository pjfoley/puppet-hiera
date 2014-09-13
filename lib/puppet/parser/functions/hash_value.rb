require File.expand_path('../../../util/hash_value', __FILE__)

module Puppet::Parser::Functions
  newfunction(:hash_value, :type => :rvalue, :doc => <<-EOS
              Returns an array of unique datadirs found from the passed in hash.
              EOS
             ) do |arguments|

               raise(Puppet::ParseError, "datadirs(): Wrong number of arguments " +
                     "given (#{arguments.size} for 2)") if arguments.size < 2

               backends = arguments[0]
               key = arguments[1]

               unless backends.is_a?(Hash)
                 raise(Puppet::ParseError, 'datadirs(): Requires a hash to work with')
               end

               backends.hash_value(key).uniq
  end
end
