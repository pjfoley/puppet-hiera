class Hash
  def extract_hashvalues(key)
    result = []
    Array(key).each do |v|
      [v, ":"+v].each do |x|
        result << self[x]
      end
    end

    self.values.each do |hv|
      values = [hv] unless hv.is_a? Array
      values.each do |value|
        result += value.extract_hashvalues(key) if value.is_a? Hash
      end
    end
    result.compact
  end

  def extract_subhash(*extract)
    self.select { |k| Array(extract).include?(k) }
  end
end

