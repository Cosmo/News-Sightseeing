class MainViewController < UITableViewController
  attr_accessor :data
  
  def viewDidLoad
    super
    
    self.tableView.delegate         = self
    self.tableView.dataSource       = self
    self.tableView.separatorStyle   = UITableViewCellSeparatorStyleNone
    
    self.data = [
      {
        section: "Here",
        data: [
          News.new(:url => "http://google.com", :lat => "23.99", :lng => "34.8", :title => "I'm awesome.", :body => "period.", :imageUrl => "https://secure.gravatar.com/avatar/53c2fe1e43b6eee5b7d2abc2eb738b1c?s=160&d=retro"),
          News.new(:url => "http://google.com", :lat => "23.99", :lng => "34.8", :title => "I'm awesome.", :body => "period.", :imageUrl => "https://secure.gravatar.com/avatar/53c2fe1e43b6eee5b7d2abc2eb738b1c?s=160&d=retro"),
          News.new(:url => "http://google.com", :lat => "23.99", :lng => "34.8", :title => "I'm awesome.", :body => "period.", :imageUrl => "https://secure.gravatar.com/avatar/53c2fe1e43b6eee5b7d2abc2eb738b1c?s=160&d=retro"),
          News.new(:url => "http://google.com", :lat => "23.99", :lng => "34.8", :title => "I'm awesome.", :body => "period.", :imageUrl => "https://secure.gravatar.com/avatar/53c2fe1e43b6eee5b7d2abc2eb738b1c?s=160&d=retro"),
          News.new(:url => "http://google.com", :lat => "23.99", :lng => "34.8", :title => "I'm awesome.", :body => "period.", :imageUrl => "https://secure.gravatar.com/avatar/53c2fe1e43b6eee5b7d2abc2eb738b1c?s=160&d=retro"),
          News.new(:url => "http://google.com", :lat => "23.99", :lng => "34.8", :title => "I'm awesome.", :body => "period.", :imageUrl => "https://secure.gravatar.com/avatar/53c2fe1e43b6eee5b7d2abc2eb738b1c?s=160&d=retro")
        ]
      },
      {
        section: "Very close",
        data: [
          News.new(:url => "http://google.com", :lat => "23.99", :lng => "34.8", :title => "I'm awesome.", :body => "period.", :imageUrl => "https://secure.gravatar.com/avatar/53c2fe1e43b6eee5b7d2abc2eb738b1c?s=160&d=retro"),
          News.new(:url => "http://google.com", :lat => "23.99", :lng => "34.8", :title => "I'm awesome.", :body => "period.", :imageUrl => "https://secure.gravatar.com/avatar/53c2fe1e43b6eee5b7d2abc2eb738b1c?s=160&d=retro"),
          News.new(:url => "http://google.com", :lat => "23.99", :lng => "34.8", :title => "I'm awesome.", :body => "period.", :imageUrl => "https://secure.gravatar.com/avatar/53c2fe1e43b6eee5b7d2abc2eb738b1c?s=160&d=retro"),
          News.new(:url => "http://google.com", :lat => "23.99", :lng => "34.8", :title => "I'm awesome.", :body => "period.", :imageUrl => "https://secure.gravatar.com/avatar/53c2fe1e43b6eee5b7d2abc2eb738b1c?s=160&d=retro"),
          News.new(:url => "http://google.com", :lat => "23.99", :lng => "34.8", :title => "I'm awesome.", :body => "period.", :imageUrl => "https://secure.gravatar.com/avatar/53c2fe1e43b6eee5b7d2abc2eb738b1c?s=160&d=retro"),
          News.new(:url => "http://google.com", :lat => "23.99", :lng => "34.8", :title => "I'm awesome.", :body => "period.", :imageUrl => "https://secure.gravatar.com/avatar/53c2fe1e43b6eee5b7d2abc2eb738b1c?s=160&d=retro")
        ]
      },
      {
        section: "Around you",
        data: [
          News.new(:url => "http://google.com", :lat => "23.99", :lng => "34.8", :title => "I'm awesome.", :body => "period.", :imageUrl => "https://secure.gravatar.com/avatar/53c2fe1e43b6eee5b7d2abc2eb738b1c?s=160&d=retro"),
          News.new(:url => "http://google.com", :lat => "23.99", :lng => "34.8", :title => "I'm awesome.", :body => "period.", :imageUrl => "https://secure.gravatar.com/avatar/53c2fe1e43b6eee5b7d2abc2eb738b1c?s=160&d=retro"),
          News.new(:url => "http://google.com", :lat => "23.99", :lng => "34.8", :title => "I'm awesome.", :body => "period.", :imageUrl => "https://secure.gravatar.com/avatar/53c2fe1e43b6eee5b7d2abc2eb738b1c?s=160&d=retro"),
          News.new(:url => "http://google.com", :lat => "23.99", :lng => "34.8", :title => "I'm awesome.", :body => "period.", :imageUrl => "https://secure.gravatar.com/avatar/53c2fe1e43b6eee5b7d2abc2eb738b1c?s=160&d=retro"),
          News.new(:url => "http://google.com", :lat => "23.99", :lng => "34.8", :title => "I'm awesome.", :body => "period.", :imageUrl => "https://secure.gravatar.com/avatar/53c2fe1e43b6eee5b7d2abc2eb738b1c?s=160&d=retro"),
          News.new(:url => "http://google.com", :lat => "23.99", :lng => "34.8", :title => "I'm awesome.", :body => "period.", :imageUrl => "https://secure.gravatar.com/avatar/53c2fe1e43b6eee5b7d2abc2eb738b1c?s=160&d=retro")
        ]
      },
      {
        section: "This city",
        data: [
          News.new(:url => "http://google.com", :lat => "23.99", :lng => "34.8", :title => "I'm awesome.", :body => "period.", :imageUrl => "https://secure.gravatar.com/avatar/53c2fe1e43b6eee5b7d2abc2eb738b1c?s=160&d=retro"),
          News.new(:url => "http://google.com", :lat => "23.99", :lng => "34.8", :title => "I'm awesome.", :body => "period.", :imageUrl => "https://secure.gravatar.com/avatar/53c2fe1e43b6eee5b7d2abc2eb738b1c?s=160&d=retro"),
          News.new(:url => "http://google.com", :lat => "23.99", :lng => "34.8", :title => "I'm awesome.", :body => "period.", :imageUrl => "https://secure.gravatar.com/avatar/53c2fe1e43b6eee5b7d2abc2eb738b1c?s=160&d=retro"),
          News.new(:url => "http://google.com", :lat => "23.99", :lng => "34.8", :title => "I'm awesome.", :body => "period.", :imageUrl => "https://secure.gravatar.com/avatar/53c2fe1e43b6eee5b7d2abc2eb738b1c?s=160&d=retro"),
          News.new(:url => "http://google.com", :lat => "23.99", :lng => "34.8", :title => "I'm awesome.", :body => "period.", :imageUrl => "https://secure.gravatar.com/avatar/53c2fe1e43b6eee5b7d2abc2eb738b1c?s=160&d=retro"),
          News.new(:url => "http://google.com", :lat => "23.99", :lng => "34.8", :title => "I'm awesome.", :body => "period.", :imageUrl => "https://secure.gravatar.com/avatar/53c2fe1e43b6eee5b7d2abc2eb738b1c?s=160&d=retro")
        ]
      }
    ]
    
    self.tableView.registerClass(AreaSectionViewCell, forCellReuseIdentifier:"AreaSectionViewCell")
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
    
    cell.here = (indexPath.row != 0)
    
    
    
    cell
  end
  
  def tableView(tableView, willDisplayCell:cell, forRowAtIndexPath:indexPath)
  end
  
  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
  end
  
  def tableView(tableView, heightForRowAtIndexPath:indexPath)
    if indexPath.row == 0
      200
    else
      150
    end
  end
end