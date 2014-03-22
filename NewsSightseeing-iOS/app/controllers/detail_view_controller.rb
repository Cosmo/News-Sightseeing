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

class DetailViewController < UIViewController
  attr_accessor :news
  
  attr_accessor :closeButton
  
  attr_accessor :scrollView
  attr_accessor :mapView
  attr_accessor :heroView
  attr_accessor :shadowFromTop
  attr_accessor :headlineLabel
  
  def initWithNews(news)
    self.init
    
    self.news = news
    
    self
  end
  
  def viewDidLoad
    super
    
    self.view.backgroundColor = UIColor.whiteColor
    
    # self.automaticallyAdjustsScrollViewInsets = true
    
    # doneButton = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemDone, target:self, action:"hideDetailView:")
    # self.navigationItem.title               = "News Title ..."
    # self.navigationItem.rightBarButtonItems = [doneButton]
    
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
      placeholder = UIImage.imageNamed("Dummy-Images/News-Hero-#{rand(5)}.jpg")
      imageView.url = { url: self.news.imageUrl, placeholder: placeholder }
      imageView.contentMode = UIViewContentModeScaleAspectFill
      self.scrollView.addSubview(imageView)
    end
    
    self.shadowFromTop = UIImageView.alloc.initWithFrame(CGRectZero).tap do |imageView|
      imageView.image       = UIImage.imageNamed("News-Shadow-From-Top.png")
      imageView.alpha       = 0.5
      imageView.contentMode = UIViewContentModeScaleToFill
      self.scrollView.addSubview(imageView)
    end
    
    self.headlineLabel = UILabel.alloc.init.tap do |label|
      label.text                    = self.news.title
      label.textColor               = UIColor.whiteColor
      label.font                    = UIFont.boldSystemFontOfSize(16)
      label.userInteractionEnabled  = false
      self.scrollView.addSubview(label)
    end
    
    self.closeButton = UIButton.alloc.initWithFrame(CGRectZero).tap do |button|
      button.titleLabel.font = UIFont.systemFontOfSize(16)
      button.setTitle("Close", forState:UIControlStateNormal)
      button.addTarget(self, action:"hideDetailView:", forControlEvents:UIControlEventTouchUpInside)
      
      button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight
      button.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
      
      self.view.addSubview(button)
    end
    
  end
  
  def preferredStatusBarStyle
    UIStatusBarStyleLightContent
  end
  
  def viewWillLayoutSubviews
    self.scrollView.frame     = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
    self.heroView.frame       = CGRectMake(0, 0, self.view.frame.size.width, 240)
    self.shadowFromTop.frame  = CGRectMake(0, 0, self.view.frame.size.width, 200)
    self.mapView.frame        = CGRectMake(0, self.heroView.frame.size.height, self.view.frame.size.width, 140)
    
    self.headlineLabel.frame  = CGRectMake(20, 30, self.view.frame.size.width, 20)
    self.closeButton.frame    = CGRectMake(self.view.frame.size.width-20-50, 30, 50, 20)
  end
  
  def hideDetailView(sender)
    self.dismissViewControllerAnimated(true, completion:lambda {})
  end
end