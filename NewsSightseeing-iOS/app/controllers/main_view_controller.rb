class MainViewController < UITableViewController
  attr_accessor :data
  
  def viewDidLoad
    super
    
    self.view.backgroundColor       = UIColor.blackColor
    
    self.tableView.delegate         = self
    self.tableView.dataSource       = self
    self.tableView.separatorStyle   = UITableViewCellSeparatorStyleNone
    
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
    
    BW::HTTP.get("http://newssightseeing.cloudapp.net/api/discover/?lng=13.38289&lat=52.5201122&distance=3") do |response|
      json = BW::JSON.parse(response.body.to_str)
      
      # REFACTOR ME!!11 - please :(
      
      hereData = []
      json['here'].each do |news|
        hereData << News.new(:url => news["url"], :lat => news["location"][1], :lng => news["location"][0], :title => news["title"], :body => news["body"], :imageUrl => news["imageUrl"])
      end
      
      veryCloseData = []
      json['veryClose'].each do |news|
        veryCloseData << News.new(:url => news["url"], :lat => news["location"][1], :lng => news["location"][0], :title => news["title"], :body => news["body"], :imageUrl => news["imageUrl"])
      end
      
      aroundYouData = []
      json['aroundYou'].each do |news|
        aroundYouData << News.new(:url => news["url"], :lat => news["location"][1], :lng => news["location"][0], :title => news["title"], :body => news["body"], :imageUrl => news["imageUrl"])
      end
      
      thisCityData = []
      json['thisCity'].each do |news|
        thisCityData << News.new(:url => news["url"], :lat => news["location"][1], :lng => news["location"][0], :title => news["title"], :body => news["body"], :imageUrl => news["imageUrl"])
      end
      
      self.data = [
        {
          section: "Here",
          data: hereData
        },
        {
          section: "Very close",
          data: veryCloseData
        },
        {
          section: "Around you",
          data: aroundYouData
        },
        {
          section: "In this city",
          data: thisCityData
        }
      ]
      
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
    
    cell.size = case indexPath.section
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
    case indexPath.section
    when 0
      220
    when 1
      160
    when 2
      130
    else
      100
    end
  end
  
  def tableView(tableView, titleForHeaderInSection:section)
    self.data[section][:section]
  end
  
  def tableView(tableView, heightForHeaderInSection:section)
    34
  end
  
  def tableView(tableView, viewForHeaderInSection:section)
    UIView.alloc.init.tap do |header|
      header.backgroundColor = UIColor.colorWithRed(255/255.0, green:203/255.0, blue:0/255.0, alpha:1.0)
      UILabel.alloc.initWithFrame(CGRectMake(10, 0, self.view.frame.size.width, 34)).tap do |label|
        label.text                    = self.data[section][:section].upcase
        label.textColor               = UIColor.blackColor
        label.font                    = UIFont.systemFontOfSize(16)
        label.userInteractionEnabled  = false
        header.addSubview(label)
      end
    end
  end
end