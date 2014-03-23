class DetailViewController < UIViewController
  attr_accessor :news
  
  attr_accessor :scrollView
  attr_accessor :mapView
  attr_accessor :heroView
  attr_accessor :shadowFromTop
  attr_accessor :shadowFromBottom
  attr_accessor :headlineLabel
  attr_accessor :bodyLabel
  
  def initWithNews(news)
    self.init
    
    self.news = news
    
    self
  end
  
  def viewDidLoad
    super
    
    self.view.backgroundColor = UIColor.blackColor
    
    self.navigationController.navigationBar.setBackgroundImage(UIImage.new, forBarMetrics:UIBarMetricsDefault)
    
    self.automaticallyAdjustsScrollViewInsets = false
    
    self.scrollView = UIScrollView.alloc.initWithFrame(CGRectZero).tap do |scroll|
      scroll.contentSize = CGSizeMake(self.view.frame.size.width, 1000)
      self.view.addSubview(scroll)
    end
    
    self.mapView = MKMapView.alloc.init.tap do |map|
      map.centerCoordinate = CLLocationCoordinate2DMake(self.news.lat, self.news.lng)
      # map.mapType = MKMapTypeHybrid
      map.showsUserLocation = true
      
      annotation = MHDAnnotation.new(CLLocationCoordinate2DMake(self.news.lat, self.news.lng), "here", "yup!")
      
      map.addAnnotation(annotation)
      self.scrollView.addSubview(map)
    end
    
    self.heroView = UIImageView.alloc.initWithFrame(CGRectZero).tap do |imageView|
      placeholder = UIImage.imageNamed("NewsPoster.png")
      imageView.url             = { url: self.news.imageUrl, placeholder: placeholder }
      imageView.contentMode     = UIViewContentModeScaleAspectFill
      imageView.clipsToBounds  = true
      self.scrollView.addSubview(imageView)
    end
    
    self.shadowFromTop = UIImageView.alloc.initWithFrame(CGRectZero).tap do |imageView|
      imageView.image       = UIImage.imageNamed("News-Shadow-From-Top.png")
      imageView.alpha       = 0.5
      imageView.contentMode = UIViewContentModeScaleToFill
      self.scrollView.addSubview(imageView)
    end
    
    self.shadowFromBottom = UIImageView.alloc.initWithFrame(CGRectZero).tap do |imageView|
      imageView.image       = UIImage.imageNamed("News-Shadow-From-Bottom.png")
      imageView.alpha       = 0.7
      imageView.contentMode = UIViewContentModeScaleToFill
      self.scrollView.addSubview(imageView)
    end
    
    self.headlineLabel = UILabel.alloc.init.tap do |label|
      label.text                    = self.news.title
      label.textColor               = UIColor.whiteColor
      label.font                    = UIFont.boldSystemFontOfSize(26)
      label.userInteractionEnabled  = false
      self.scrollView.addSubview(label)
    end
    
    self.bodyLabel = UITextView.alloc.init.tap do |label|
      if self.news.body
        options = {
          NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
          NSCharacterEncodingDocumentAttribute: NSUTF8StringEncoding
        }
        bodyString = NSAttributedString.alloc.initWithData(("<html><meta charset='utf-8' />" + self.news.body + "</html>").dataUsingEncoding(NSUTF8StringEncoding), options:options, documentAttributes:nil, error:nil)
        label.attributedText  = bodyString
      else
        label.text            = ""
      end
      
      label.editable                = false
      label.selectable              = true
      label.textAlignment           = NSTextAlignmentLeft
      label.textContainerInset      = UIEdgeInsetsMake(30, 20, 10, 20) # top, left, bottom, right
      label.textColor               = UIColor.whiteColor
      label.backgroundColor         = UIColor.blackColor
      label.font                    = UIFont.systemFontOfSize(16)
      label.userInteractionEnabled  = true
      self.scrollView.addSubview(label)
    end
    
  end
  
  def viewWillAppear(animated)
    self.navigationController.setNavigationBarHidden(false, animated:animated)
  end
  
  def preferredStatusBarStyle
    UIStatusBarStyleLightContent
  end
  
  def viewWillLayoutSubviews
    multiplicator = (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad ? 2 : 1)
    
    self.scrollView.frame         = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
    self.heroView.frame           = CGRectMake(0, 0, self.view.frame.size.width, 240 * multiplicator)
    self.shadowFromTop.frame      = CGRectMake(0, 0, self.view.frame.size.width, 200)
    self.shadowFromBottom.frame   = CGRectMake(0, self.heroView.frame.size.height / 2, self.view.frame.size.width, self.heroView.frame.size.height / 2)
    self.mapView.frame            = CGRectMake(0, self.heroView.frame.size.height, self.view.frame.size.width, 140 * multiplicator)
    
    self.headlineLabel.frame      = CGRectMake(20, self.heroView.frame.size.height-40, self.view.frame.size.width-20-20, 30)
    self.bodyLabel.frame          = CGRectMake(0, self.heroView.frame.size.height+self.mapView.frame.size.height, self.view.frame.size.width, 400)
  end
end