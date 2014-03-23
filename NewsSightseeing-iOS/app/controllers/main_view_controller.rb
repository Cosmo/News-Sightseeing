class MainViewController < UIViewController # UITableViewController
  attr_accessor :data
  attr_accessor :tableView
  attr_accessor :leftView
  
  def viewDidLoad
    super
    
    paper = PaperFoldView.alloc.initWithFrame(CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height))
    paper.backgroundColor   = UIColor.blackColor
    paper.autoresizingMask  = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight
    self.view.addSubview(paper)
    
    self.leftView = UIView.alloc.initWithFrame(CGRectMake(0, 0, 100, self.view.frame.size.height)).tap do |left|
      left.backgroundColor      = UIColor.colorWithRed(255/255.0, green:203/255.0, blue:0/255.0, alpha:1.0)
      # paper.leftFoldContentView = left
      paper.setLeftFoldContentView(left, foldCount:3, pullFactor:1.0)
    end
    
    self.tableView = UITableView.alloc.initWithFrame(CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)).tap do |center|
      center.backgroundColor  = UIColor.blackColor
      paper.centerContentView = center
      center.delegate         = self
      center.dataSource       = self
    end
    
    paper.delegate                = self
    paper.enableRightFoldDragging = false
    # paper.paperFoldState          = PaperFoldStateLeftUnfolded
    
    self.view.backgroundColor             = UIColor.colorWithWhite(0.1, alpha:1.0)
    self.tableView.delegate               = self
    self.tableView.dataSource             = self
    self.tableView.separatorStyle         = UITableViewCellSeparatorStyleNone
    
    self.data = []
    
    self.tableView.registerClass(AreaSectionViewCell, forCellReuseIdentifier:"AreaSectionViewCell")
    
    self.loadData
  end
  
  def preferredStatusBarStyle
    UIStatusBarStyleLightContent
  end
  
  def viewWillAppear(animated)
    self.navigationController.setNavigationBarHidden(true, animated:animated)
  end
  
  def loadData
    BW::HTTP.get("http://newssightseeing.cloudapp.net/api/discover/?lng=13.466630&lat=52.499850") do |response|
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
          else
            icon = UIImage.imageNamed("SourceLogos/no.png")
          end
          
          data << News.new(:url => news["url"], :lat => news["location"][1], :lng => news["location"][0], :title => news["title"], :body => news["body"], :imageUrl => news["imageUrl"], :icon => icon)
        end
        self.data << { section: value, data: data }
      end
      
      self.tableView.reloadData
    end
    
  end
  
  def numberOfSectionsInTableView(tableView)
    self.data.count
  end
  
  def tableView(tableView, numberOfRowsInSection:section)
    1
  end
  
  def tableView(tableView, cellForRowAtIndexPath:indexPath)
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
  end
  
  def tableView(tableView, willDisplayCell:cell, forRowAtIndexPath:indexPath)
  end
  
  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
  end
  
  def tableView(tableView, heightForRowAtIndexPath:indexPath)
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
  end
  
  def tableView(tableView, titleForHeaderInSection:section)
    self.data[section][:section]
  end
  
  def tableView(tableView, heightForHeaderInSection:section)
    50
  end
  
  
  
  def tableView(tableView, viewForHeaderInSection:section)
    UIView.alloc.init.tap do |header|
      # header.backgroundColor = UIColor.blackColor
      UILabel.alloc.initWithFrame(CGRectMake(20, 10, self.view.frame.size.width, 40)).tap do |label|
        label.text                    = self.data[section][:section]
        label.textColor               = UIColor.colorWithRed(255/255.0, green:203/255.0, blue:0/255.0, alpha:1.0)
        label.font                    = UIFont.boldSystemFontOfSize(30)
        label.userInteractionEnabled  = false
        header.addSubview(label)
      end
    end
  end
end