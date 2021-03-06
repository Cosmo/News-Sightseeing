class News
  PROPERTIES = [:id, :url, :lat, :lng, :title, :body, :imageUrl, :icon]
  PROPERTIES.each { |property| attr_accessor property }
  
  def initialize(hash = {})
    hash.each { |key, value|
      if PROPERTIES.member? key.to_sym
        self.send((key.to_s + "=").to_s, value)
      end
    }
  end
end