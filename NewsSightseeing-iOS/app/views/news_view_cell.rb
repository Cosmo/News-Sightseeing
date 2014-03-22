class NewsViewCell < UICollectionViewCell
  attr_accessor :heroView
  def initWithFrame(frame)
    super
    
    self.heroView = UIImageView.alloc.initWithFrame(CGRectZero).tap do |imageView|
      imageView.image = UIImage.imageNamed("Dummy-Images/News-Hero-1.jpg")
      imageView.contentMode   = UIViewContentModeScaleAspectFill
      imageView.clipsToBounds = true
      self.addSubview(imageView)
    end
    
    self
  end
  
  def layoutSubviews
    self.heroView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
  end
end