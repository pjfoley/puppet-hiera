require File.expand_path('../../../util/hash_value', __FILE__)

module Puppet::Parser::Functions
  newfunction(:datadirs, :type => :rvalue, :doc => <<-EOS
              Returns an array of unique datadirs found from the passed in hash.
              EOS
             ) do |arguments|
               Puppet::Parser::Functions.autoloader.loadall

               raise(Puppet::ParseError, "datadirs(): Wrong number of arguments " +
                     "given (#{arguments.size} for 1)") if arguments.size < 1

               backends = arguments[0]

               unless backends.is_a?(Hash)
                 raise(Puppet::ParseError, 'datadirs(): Requires a hash to work with')
               end

               backends.hash_value('datadir').uniq
  end
end
