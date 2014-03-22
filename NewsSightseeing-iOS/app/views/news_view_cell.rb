class NewsViewCell < UICollectionViewCell
  attr_accessor :backgroundView
  attr_accessor :heroView
  attr_accessor :shadowFromTop
  attr_accessor :headlineLabel
  
  def initWithFrame(frame)
    super
    
    self.backgroundView = UIView.alloc.initWithFrame(CGRectZero).tap do |background|
      background.clipsToBounds       = true
      background.layer.cornerRadius  = 10
      background.layer.masksToBounds = true
      self.addSubview(background)
    end
    
    self.heroView = UIImageView.alloc.initWithFrame(CGRectZero).tap do |imageView|
      imageView.image       = UIImage.imageNamed("Dummy-Images/News-Hero-#{rand(5)}.jpg")
      imageView.contentMode = UIViewContentModeScaleAspectFill
      self.backgroundView.addSubview(imageView)
    end
    
    self.shadowFromTop = UIImageView.alloc.initWithFrame(CGRectZero).tap do |imageView|
      imageView.image       = UIImage.imageNamed("News-Shadow-From-Top.png")
      imageView.alpha       = 0.7
      imageView.contentMode = UIViewContentModeScaleToFill
      self.backgroundView.addSubview(imageView)
    end
    
    self.headlineLabel = UILabel.alloc.init.tap do |label|
      label.textColor               = UIColor.whiteColor
      label.font                    = UIFont.boldSystemFontOfSize(16)
      label.userInteractionEnabled  = false
      self.addSubview(label)
    end
    
    self
  end
  
  def layoutSubviews
    self.backgroundView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
    self.heroView.frame       = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
    self.shadowFromTop.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height/2)
    self.headlineLabel.frame  = CGRectMake(10, 10, self.frame.size.width-20-20, 20)
  end
end