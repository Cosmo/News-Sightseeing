class MHDAnnotation
  def initialize(coordinate = nil, title=nil, subtitle=nil)
    @coordinate ||= coordinate
    @title = title
    @subtitle = subtitle
  end
  
  def coordinate
    @coordinate
  end

  def title
    @title
  end

  def subtitle
    @subtitle
  end
end