class Hash
  def find_datadirs
    result = []
    result << self['datadir']
    result << self[':datadir']
    result << self['datadir:']
    result << self[':datadir:']
    self.values.each do |hash_value|
      values = [hash_value] unless hash_value.is_a? Array
      values.each do |value|
        result += value.find_datadirs if value.is_a? Hash
      end
    end
    result.compact
  end
end

module Puppet::Parser::Functions
  newfunction(:datadirs, :type => :rvalue, :doc => <<-EOS
              Returns an array of unique datadirs found from the passed in hash.
              EOS
             ) do |arguments|

               raise(Puppet::ParseError, "datadirs(): Wrong number of arguments " +
                     "given (#{arguments.size} for 1)") if arguments.size < 1

               backends = arguments[0]

               unless backends.is_a?(Hash)
                 raise(Puppet::ParseError, 'datadirs(): Requires a hash to work with')
               end

               backends.find_datadirs.uniq
  end
end
