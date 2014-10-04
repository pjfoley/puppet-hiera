require File.expand_path('../../../util/hashextensions', __FILE__)

module Puppet::Parser::Functions
  newfunction(:extract_subhash, :type => :rvalue, :doc => <<-EOS
              Returns a subhash from hash based on a user provided key.
              EOS
             ) do |arguments|

               raise(Puppet::ParseError, "extract_subhash(): Wrong number of arguments " +
                     "given (#{arguments.size} for 2)") if arguments.size != 2

               backends = arguments[0]
               extract = arguments[1]

               unless backends.is_a?(Hash)
                 raise(Puppet::ParseError, 'extract_subhash(): Requires the first argument to be a hash')
               end

               unless extract.is_a?(String) || (extract.is_a?(Array) && arr_all_strings?(extract))
                 raise(Puppet::ParseError, 'extract_subhash(): Requires the second argument to be a string or array of strings')
               end

               backends.extract_subhash(extract)
  end
end
