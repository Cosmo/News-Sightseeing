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
          section: "This city",
          data: thisCityData
        }
      ]
      
      self.tableView.reloadData
    end
    
    # self.data = [
    #   {
    #     section: "Here",
    #     data: [
    #       News.new(:url => "http://google.com", :lat => "23.99", :lng => "34.8", :title => "I'm awesome.", :body => "period.", :imageUrl => "https://secure.gravatar.com/avatar/53c2fe1e43b6eee5b7d2abc2eb738b1c?s=160&d=retro"),
    #       News.new(:url => "http://google.com", :lat => "23.99", :lng => "34.8", :title => "I'm awesome.", :body => "period.", :imageUrl => "https://secure.gravatar.com/avatar/53c2fe1e43b6eee5b7d2abc2eb738b1c?s=160&d=retro"),
    #       News.new(:url => "http://google.com", :lat => "23.99", :lng => "34.8", :title => "I'm awesome.", :body => "period.", :imageUrl => "https://secure.gravatar.com/avatar/53c2fe1e43b6eee5b7d2abc2eb738b1c?s=160&d=retro"),
    #       News.new(:url => "http://google.com", :lat => "23.99", :lng => "34.8", :title => "I'm awesome.", :body => "period.", :imageUrl => "https://secure.gravatar.com/avatar/53c2fe1e43b6eee5b7d2abc2eb738b1c?s=160&d=retro"),
    #       News.new(:url => "http://google.com", :lat => "23.99", :lng => "34.8", :title => "I'm awesome.", :body => "period.", :imageUrl => "https://secure.gravatar.com/avatar/53c2fe1e43b6eee5b7d2abc2eb738b1c?s=160&d=retro"),
    #       News.new(:url => "http://google.com", :lat => "23.99", :lng => "34.8", :title => "I'm awesome.", :body => "period.", :imageUrl => "https://secure.gravatar.com/avatar/53c2fe1e43b6eee5b7d2abc2eb738b1c?s=160&d=retro"),
    #       News.new(:url => "http://google.com", :lat => "23.99", :lng => "34.8", :title => "I'm awesome.", :body => "period.", :imageUrl => "https://secure.gravatar.com/avatar/53c2fe1e43b6eee5b7d2abc2eb738b1c?s=160&d=retro"),
    #       News.new(:url => "http://google.com", :lat => "23.99", :lng => "34.8", :title => "I'm awesome.", :body => "period.", :imageUrl => "https://secure.gravatar.com/avatar/53c2fe1e43b6eee5b7d2abc2eb738b1c?s=160&d=retro"),
    #       News.new(:url => "http://google.com", :lat => "23.99", :lng => "34.8", :title => "I'm awesome.", :body => "period.", :imageUrl => "https://secure.gravatar.com/avatar/53c2fe1e43b6eee5b7d2abc2eb738b1c?s=160&d=retro"),
    #       News.new(:url => "http://google.com", :lat => "23.99", :lng => "34.8", :title => "I'm awesome.", :body => "period.", :imageUrl => "https://secure.gravatar.com/avatar/53c2fe1e43b6eee5b7d2abc2eb738b1c?s=160&d=retro"),
    #       News.new(:url => "http://google.com", :lat => "23.99", :lng => "34.8", :title => "I'm awesome.", :body => "period.", :imageUrl => "https://secure.gravatar.com/avatar/53c2fe1e43b6eee5b7d2abc2eb738b1c?s=160&d=retro"),
    #       News.new(:url => "http://google.com", :lat => "23.99", :lng => "34.8", :title => "I'm awesome.", :body => "period.", :imageUrl => "https://secure.gravatar.com/avatar/53c2fe1e43b6eee5b7d2abc2eb738b1c?s=160&d=retro")
    #     ]
    #   },
    #   {
    #     section: "Very close",
    #     data: [
    #       News.new(:url => "http://google.com", :lat => "23.99", :lng => "34.8", :title => "I'm awesome.", :body => "period.", :imageUrl => "https://secure.gravatar.com/avatar/53c2fe1e43b6eee5b7d2abc2eb738b1c?s=160&d=retro"),
    #       News.new(:url => "http://google.com", :lat => "23.99", :lng => "34.8", :title => "I'm awesome.", :body => "period.", :imageUrl => "https://secure.gravatar.com/avatar/53c2fe1e43b6eee5b7d2abc2eb738b1c?s=160&d=retro"),
    #       News.new(:url => "http://google.com", :lat => "23.99", :lng => "34.8", :title => "I'm awesome.", :body => "period.", :imageUrl => "https://secure.gravatar.com/avatar/53c2fe1e43b6eee5b7d2abc2eb738b1c?s=160&d=retro"),
    #       News.new(:url => "http://google.com", :lat => "23.99", :lng => "34.8", :title => "I'm awesome.", :body => "period.", :imageUrl => "https://secure.gravatar.com/avatar/53c2fe1e43b6eee5b7d2abc2eb738b1c?s=160&d=retro"),
    #       News.new(:url => "http://google.com", :lat => "23.99", :lng => "34.8", :title => "I'm awesome.", :body => "period.", :imageUrl => "https://secure.gravatar.com/avatar/53c2fe1e43b6eee5b7d2abc2eb738b1c?s=160&d=retro"),
    #       News.new(:url => "http://google.com", :lat => "23.99", :lng => "34.8", :title => "I'm awesome.", :body => "period.", :imageUrl => "https://secure.gravatar.com/avatar/53c2fe1e43b6eee5b7d2abc2eb738b1c?s=160&d=retro"),
    #       News.new(:url => "http://google.com", :lat => "23.99", :lng => "34.8", :title => "I'm awesome.", :body => "period.", :imageUrl => "https://secure.gravatar.com/avatar/53c2fe1e43b6eee5b7d2abc2eb738b1c?s=160&d=retro"),
    #       News.new(:url => "http://google.com", :lat => "23.99", :lng => "34.8", :title => "I'm awesome.", :body => "period.", :imageUrl => "https://secure.gravatar.com/avatar/53c2fe1e43b6eee5b7d2abc2eb738b1c?s=160&d=retro"),
    #       News.new(:url => "http://google.com", :lat => "23.99", :lng => "34.8", :title => "I'm awesome.", :body => "period.", :imageUrl => "https://secure.gravatar.com/avatar/53c2fe1e43b6eee5b7d2abc2eb738b1c?s=160&d=retro"),
    #       News.new(:url => "http://google.com", :lat => "23.99", :lng => "34.8", :title => "I'm awesome.", :body => "period.", :imageUrl => "https://secure.gravatar.com/avatar/53c2fe1e43b6eee5b7d2abc2eb738b1c?s=160&d=retro"),
    #       News.new(:url => "http://google.com", :lat => "23.99", :lng => "34.8", :title => "I'm awesome.", :body => "period.", :imageUrl => "https://secure.gravatar.com/avatar/53c2fe1e43b6eee5b7d2abc2eb738b1c?s=160&d=retro"),
    #       News.new(:url => "http://google.com", :lat => "23.99", :lng => "34.8", :title => "I'm awesome.", :body => "period.", :imageUrl => "https://secure.gravatar.com/avatar/53c2fe1e43b6eee5b7d2abc2eb738b1c?s=160&d=retro")
    #     ]
    #   },
    #   {
    #     section: "Around you",
    #     data: [
    #       News.new(:url => "http://google.com", :lat => "23.99", :lng => "34.8", :title => "I'm awesome.", :body => "period.", :imageUrl => "https://secure.gravatar.com/avatar/53c2fe1e43b6eee5b7d2abc2eb738b1c?s=160&d=retro"),
    #       News.new(:url => "http://google.com", :lat => "23.99", :lng => "34.8", :title => "I'm awesome.", :body => "period.", :imageUrl => "https://secure.gravatar.com/avatar/53c2fe1e43b6eee5b7d2abc2eb738b1c?s=160&d=retro"),
    #       News.new(:url => "http://google.com", :lat => "23.99", :lng => "34.8", :title => "I'm awesome.", :body => "period.", :imageUrl => "https://secure.gravatar.com/avatar/53c2fe1e43b6eee5b7d2abc2eb738b1c?s=160&d=retro"),
    #       News.new(:url => "http://google.com", :lat => "23.99", :lng => "34.8", :title => "I'm awesome.", :body => "period.", :imageUrl => "https://secure.gravatar.com/avatar/53c2fe1e43b6eee5b7d2abc2eb738b1c?s=160&d=retro"),
    #       News.new(:url => "http://google.com", :lat => "23.99", :lng => "34.8", :title => "I'm awesome.", :body => "period.", :imageUrl => "https://secure.gravatar.com/avatar/53c2fe1e43b6eee5b7d2abc2eb738b1c?s=160&d=retro"),
    #       News.new(:url => "http://google.com", :lat => "23.99", :lng => "34.8", :title => "I'm awesome.", :body => "period.", :imageUrl => "https://secure.gravatar.com/avatar/53c2fe1e43b6eee5b7d2abc2eb738b1c?s=160&d=retro"),
    #       News.new(:url => "http://google.com", :lat => "23.99", :lng => "34.8", :title => "I'm awesome.", :body => "period.", :imageUrl => "https://secure.gravatar.com/avatar/53c2fe1e43b6eee5b7d2abc2eb738b1c?s=160&d=retro"),
    #       News.new(:url => "http://google.com", :lat => "23.99", :lng => "34.8", :title => "I'm awesome.", :body => "period.", :imageUrl => "https://secure.gravatar.com/avatar/53c2fe1e43b6eee5b7d2abc2eb738b1c?s=160&d=retro")
    #     ]
    #   },
    #   {
    #     section: "This city",
    #     data: [
    #       News.new(:url => "http://google.com", :lat => "23.99", :lng => "34.8", :title => "I'm awesome.", :body => "period.", :imageUrl => "https://secure.gravatar.com/avatar/53c2fe1e43b6eee5b7d2abc2eb738b1c?s=160&d=retro"),
    #       News.new(:url => "http://google.com", :lat => "23.99", :lng => "34.8", :title => "I'm awesome.", :body => "period.", :imageUrl => "https://secure.gravatar.com/avatar/53c2fe1e43b6eee5b7d2abc2eb738b1c?s=160&d=retro"),
    #       News.new(:url => "http://google.com", :lat => "23.99", :lng => "34.8", :title => "I'm awesome.", :body => "period.", :imageUrl => "https://secure.gravatar.com/avatar/53c2fe1e43b6eee5b7d2abc2eb738b1c?s=160&d=retro"),
    #       News.new(:url => "http://google.com", :lat => "23.99", :lng => "34.8", :title => "I'm awesome.", :body => "period.", :imageUrl => "https://secure.gravatar.com/avatar/53c2fe1e43b6eee5b7d2abc2eb738b1c?s=160&d=retro"),
    #       News.new(:url => "http://google.com", :lat => "23.99", :lng => "34.8", :title => "I'm awesome.", :body => "period.", :imageUrl => "https://secure.gravatar.com/avatar/53c2fe1e43b6eee5b7d2abc2eb738b1c?s=160&d=retro"),
    #       News.new(:url => "http://google.com", :lat => "23.99", :lng => "34.8", :title => "I'm awesome.", :body => "period.", :imageUrl => "https://secure.gravatar.com/avatar/53c2fe1e43b6eee5b7d2abc2eb738b1c?s=160&d=retro"),
    #       News.new(:url => "http://google.com", :lat => "23.99", :lng => "34.8", :title => "I'm awesome.", :body => "period.", :imageUrl => "https://secure.gravatar.com/avatar/53c2fe1e43b6eee5b7d2abc2eb738b1c?s=160&d=retro"),
    #       News.new(:url => "http://google.com", :lat => "23.99", :lng => "34.8", :title => "I'm awesome.", :body => "period.", :imageUrl => "https://secure.gravatar.com/avatar/53c2fe1e43b6eee5b7d2abc2eb738b1c?s=160&d=retro"),
    #       News.new(:url => "http://google.com", :lat => "23.99", :lng => "34.8", :title => "I'm awesome.", :body => "period.", :imageUrl => "https://secure.gravatar.com/avatar/53c2fe1e43b6eee5b7d2abc2eb738b1c?s=160&d=retro"),
    #       News.new(:url => "http://google.com", :lat => "23.99", :lng => "34.8", :title => "I'm awesome.", :body => "period.", :imageUrl => "https://secure.gravatar.com/avatar/53c2fe1e43b6eee5b7d2abc2eb738b1c?s=160&d=retro"),
    #       News.new(:url => "http://google.com", :lat => "23.99", :lng => "34.8", :title => "I'm awesome.", :body => "period.", :imageUrl => "https://secure.gravatar.com/avatar/53c2fe1e43b6eee5b7d2abc2eb738b1c?s=160&d=retro"),
    #       News.new(:url => "http://google.com", :lat => "23.99", :lng => "34.8", :title => "I'm awesome.", :body => "period.", :imageUrl => "https://secure.gravatar.com/avatar/53c2fe1e43b6eee5b7d2abc2eb738b1c?s=160&d=retro"),
    #       News.new(:url => "http://google.com", :lat => "23.99", :lng => "34.8", :title => "I'm awesome.", :body => "period.", :imageUrl => "https://secure.gravatar.com/avatar/53c2fe1e43b6eee5b7d2abc2eb738b1c?s=160&d=retro"),
    #       News.new(:url => "http://google.com", :lat => "23.99", :lng => "34.8", :title => "I'm awesome.", :body => "period.", :imageUrl => "https://secure.gravatar.com/avatar/53c2fe1e43b6eee5b7d2abc2eb738b1c?s=160&d=retro"),
    #       News.new(:url => "http://google.com", :lat => "23.99", :lng => "34.8", :title => "I'm awesome.", :body => "period.", :imageUrl => "https://secure.gravatar.com/avatar/53c2fe1e43b6eee5b7d2abc2eb738b1c?s=160&d=retro")
    #     ]
    #   }
    # ]
    
  end
  
  def numberOfSectionsInTableView(tableView)
    1
  end
  
  def tableView(tableView, numberOfRowsInSection:section)
    self.data.count
  end
  
  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier("AreaSectionViewCell")
    
    cell.sectionLabel.text = self.data[indexPath.row][:section]
    cell.navigationController = self.navigationController
    cell.data = self.data[indexPath.row][:data]
    
    cell.size = case indexPath.row
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
    case indexPath.row
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
end