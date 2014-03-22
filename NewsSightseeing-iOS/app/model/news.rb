class News
  PROPERTIES = [:url, :lat, :lng, :title, :body, :imageUrl]
  PROPERTIES.each { |property| attr_accessor property }
  
  def initialize(hash = {})
    hash.each { |key, value|
      if PROPERTIES.member? key.to_sym
        self.send((key.to_s + "=").to_s, value)
      end
    }
  end
end