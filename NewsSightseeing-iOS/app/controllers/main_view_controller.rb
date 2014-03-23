class MainViewController < UIViewController # UITableViewController
  attr_accessor :data
  attr_accessor :timelineData
  attr_accessor :centerView
  attr_accessor :leftView
  
  def viewDidLoad
    super
    
    self.automaticallyAdjustsScrollViewInsets = false
    
    paper = PaperFoldView.alloc.initWithFrame(CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height))
    paper.backgroundColor   = UIColor.blackColor
    paper.autoresizingMask  = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight
    self.view.addSubview(paper)
    
    self.timelineData = (1900..2014).to_a.map{ |y| y.to_s }.reverse
    
    layout = UICollectionViewFlowLayout.alloc.init
    layout.scrollDirection          = UICollectionViewScrollDirectionVertical
    layout.sectionInset             = UIEdgeInsetsMake(20, 0, 0, 0) # top, left, bottom, right
    layout.minimumInteritemSpacing  = 0.0
    layout.minimumLineSpacing       = 0.0
    self.leftView = UICollectionView.alloc.initWithFrame(CGRectMake(0, 0, 140, self.view.frame.size.height), collectionViewLayout:layout).tap do |left|
      left.registerClass(TimeViewCell, forCellWithReuseIdentifier:"TimeViewCell")
      left.delegate               = self
      left.dataSource             = self
      left.directionalLockEnabled = false
      left.backgroundColor        = UIColor.colorWithWhite(0.3, alpha:1.0)
      paper.setLeftFoldContentView(left, foldCount:3, pullFactor:1.0)
    end
    
    # self.leftView = UITableView.alloc.initWithFrame(CGRectMake(0, 0, 100, self.view.frame.size.height)).tap do |left|
    #   left.backgroundColor  = UIColor.blackColor
    #   left.delegate         = self
    #   left.dataSource       = self
    #   paper.setLeftFoldContentView(left, foldCount:3, pullFactor:1.0)
    # end
    
    self.centerView = UITableView.alloc.initWithFrame(CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)).tap do |center|
      center.backgroundColor  = UIColor.blackColor
      paper.centerContentView = center
      center.delegate         = self
      center.dataSource       = self
    end
    
    paper.delegate                = self
    paper.enableRightFoldDragging = false
    # paper.paperFoldState          = PaperFoldStateLeftUnfolded
    
    self.view.backgroundColor             = UIColor.colorWithWhite(0.1, alpha:1.0)
    # self.centerView.delegate               = self
    # self.centerView.dataSource             = self
    self.centerView.separatorStyle         = UITableViewCellSeparatorStyleNone
    
    self.data         = []
    # self.timelineData = (1900..2014).to_a.map { |y| y.to_s }
    
    self.centerView.registerClass(AreaSectionViewCell, forCellReuseIdentifier:"AreaSectionViewCell")
    
    self.loadData
  end
  
  def preferredStatusBarStyle
    UIStatusBarStyleLightContent
  end
  
  def viewWillAppear(animated)
    self.navigationController.setNavigationBarHidden(true, animated:animated)
  end
  
  def loadData
    BW::HTTP.get("http://newssightseeing.cloudapp.net/api/discover/?lng=13.3949&lat=52.50524") do |response|
      json      = BW::JSON.parse(response.body.to_str)
      self.data = []
      sections  = { here: "Here", veryClose: "Close", aroundYou: "Around you", thisCity: "In this city" }
      sections.each do |key, value|
        data = []
        json[key.to_s].each do |news|
          
          if news["id"].match(/wikidata/)
            icon = UIImage.imageNamed("SourceLogos/wikidata.png")
          elsif news["id"].match(/storyful/)
            icon = UIImage.imageNamed("SourceLogos/storyful.png")
          elsif news["id"].match(/axelspringer/)
            icon = UIImage.imageNamed("SourceLogos/axelspringer.png")
          elsif news["id"].match(/bankomat/)
            icon = UIImage.imageNamed("SourceLogos/berlinermorgenpost.png")
          elsif news["id"].match(/ad/)
            icon = UIImage.imageNamed("SourceLogos/ad.png")
          else
            icon = UIImage.imageNamed("SourceLogos/no.png")
          end
          
          data << News.new(:id => news["id"], :url => news["url"], :lat => news["location"][1], :lng => news["location"][0], :title => news["title"], :body => news["body"], :imageUrl => news["imageUrl"], :icon => icon)
        end
        
        self.data << { section: value, data: data }
      end
      
      self.centerView.reloadData
    end
  end
  
  def numberOfSectionsInTableView(tableView)
    if tableView == self.centerView
      self.data.count
    else
      1
    end
  end
  
  def tableView(tableView, numberOfRowsInSection:section)
    if tableView == self.centerView
      1
    else
      self.timelineData.count
    end
  end
  
  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    if tableView == self.centerView
      cell = tableView.dequeueReusableCellWithIdentifier("AreaSectionViewCell")

      # cell.sectionLabel.text = self.data[indexPath.section][:section].upcase
      cell.navigationController = self.navigationController
      cell.data = self.data[indexPath.section][:data]

      cell.size = (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad ? 2 : 1) * case indexPath.section
      when 0
        230
      when 1
        170
      when 2
        120
      else
        100
      end
      cell
    else
      @reuseIdentifier = "MenuItem"
      cell = tableView.dequeueReusableCellWithIdentifier(@reuseIdentifier) || begin
        UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:@reuseIdentifier)
      end
      cell.textLabel.text   = self.timelineData[indexPath.row]
      cell.textLabel.color  = UIColor.blackColor
      cell.accessoryType    = UITableViewCellAccessoryDisclosureIndicator
      cell
    end
  end
  
  # def tableView(tableView, willDisplayCell:cell, forRowAtIndexPath:indexPath)
  # end
  # 
  # def tableView(tableView, didSelectRowAtIndexPath:indexPath)
  # end
  
  def tableView(tableView, heightForRowAtIndexPath:indexPath)
    if tableView == self.centerView
      (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad ? 2 : 1) * case indexPath.section
      when 0
        220
      when 1
        160
      when 2
        140
      else
        140
      end
    else
      44
    end
  end
  
  def tableView(tableView, titleForHeaderInSection:section)
    if tableView == self.centerView
      self.data[section][:section]
    end
  end
  
  def tableView(tableView, heightForHeaderInSection:section)
    if tableView == self.centerView
      60
    end
  end
  
  
  
  def tableView(tableView, viewForHeaderInSection:section)
    if tableView == self.centerView
      UIView.alloc.init.tap do |header|
        # header.backgroundColor = UIColor.blackColor
        UILabel.alloc.initWithFrame(CGRectMake(20, 20, self.view.frame.size.width, 40)).tap do |label|
          label.text                    = self.data[section][:section]
          label.textColor               = UIColor.colorWithRed(255/255.0, green:203/255.0, blue:0/255.0, alpha:1.0)
          label.font                    = UIFont.boldSystemFontOfSize(30)
          label.userInteractionEnabled  = false
          header.addSubview(label)
        end
      end
    end
  end
  
  
  
  
  
  def collectionView(collectionView, layout:collectionViewLayout, sizeForItemAtIndexPath:indexPath)
    CGSizeMake(self.view.frame.size.width-10-10, 60)
  end
  
  def numberOfSectionsInCollectionView(collectionView)
    1
  end

  def collectionView(collectionView, numberOfItemsInSection:section)
    self.timelineData.count
  end
  
  def collectionView(collectionView, cellForItemAtIndexPath:indexPath)
    cell = collectionView.dequeueReusableCellWithReuseIdentifier("TimeViewCell", forIndexPath:indexPath)
    cell.yearLabel.text = self.timelineData[indexPath.row]
    cell
  end
  
  
  
  def collectionView(collectionView, didSelectItemAtIndexPath:indexPath)
    # TODO!
  end
end