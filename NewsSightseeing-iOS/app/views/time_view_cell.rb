class TimeViewCell < UICollectionViewCell
  attr_accessor :yearLabel
  
  def initWithFrame(frame)
    super
    
    self.yearLabel = UILabel.alloc.init.tap do |label|
      label.textColor               = UIColor.colorWithRed(255/255.0, green:203/255.0, blue:0/255.0, alpha:1.0)
      label.font                    = UIFont.boldSystemFontOfSize(26)
      label.textAlignment           = NSTextAlignmentCenter
      self.addSubview(label)
    end
    
    self
  end
  
  def layoutSubviews
    self.yearLabel.frame  = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
  end
end