class NewsViewCell < UICollectionViewCell
  attr_accessor :sourceLogoView
  attr_accessor :backgroundView
  attr_accessor :heroView
  attr_accessor :shadowFromTop
  attr_accessor :headlineLabel
  
  def initWithFrame(frame)
    super
    
    self.backgroundView = UIView.alloc.initWithFrame(CGRectZero).tap do |background|
      # background.clipsToBounds       = true
      background.layer.cornerRadius  = 6
      background.layer.masksToBounds = true
      
      background.layer.borderColor = UIColor.colorWithWhite(1.0, alpha:0.3).CGColor
      background.layer.borderWidth = 1.0
      
      self.addSubview(background)
    end
    
    self.heroView = UIImageView.alloc.initWithFrame(CGRectZero).tap do |imageView|
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
      label.numberOfLines           = 2
      label.userInteractionEnabled  = false
      self.addSubview(label)
    end
    
    self.sourceLogoView = UIImageView.alloc.initWithFrame(CGRectZero).tap do |imageView|
      imageView.contentMode = UIViewContentModeScaleAspectFill
      
      imageView.layer.borderColor = UIColor.colorWithWhite(1.0, alpha:0.3).CGColor
      imageView.layer.borderWidth = 1.0
      
      self.addSubview(imageView)
    end
    
    self
  end
  
  def layoutSubviews
    self.backgroundView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
    self.heroView.frame       = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
    self.shadowFromTop.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height/2)
    self.headlineLabel.frame  = CGRectMake(10, 10, self.frame.size.width-20-20, 40)
    
    self.sourceLogoView.frame  = CGRectMake(self.frame.size.width-40-10, self.frame.size.height-40-10, 40, 40)
  end
end