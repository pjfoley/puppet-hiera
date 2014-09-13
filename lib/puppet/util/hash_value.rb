class Hash
  def hash_value(key)
    result = []
    Array(key).each do |v|
      [v, ":"+v].each do |x|
        result << self[x]
      end
    end

    self.values.each do |hv|
      values = [hv] unless hv.is_a? Array
      values.each do |value|
        result += value.hash_value(key) if value.is_a? Hash
      end
    end
    result.compact
  end
end

