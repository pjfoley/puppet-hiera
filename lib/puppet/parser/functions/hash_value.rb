class Hash
  def find_all_values_for(key)
    result = []
    [key, ":"+key].each do |x|
      result << self[x]
    end

    self.values.each do |hash_value|
      values = [hash_value] unless hash_value.is_a? Array
      values.each do |value|
        result += value.find_all_values_for(key) if value.is_a? Hash
      end
    end
    result.compact
  end
end

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

               backends.find_all_values_for(key).uniq
  end
end
