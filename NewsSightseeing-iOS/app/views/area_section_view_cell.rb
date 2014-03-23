class AreaSectionViewCell < UITableViewCell
  attr_accessor :navigationController
  attr_accessor :size
  attr_accessor :collectionView
  attr_accessor :data
  
  # attr_accessor :shadowFromLeft
  # attr_accessor :sectionLabel
  
  def initWithStyle(style, reuseIdentifier:reuseIdentifier)
    super
    
    self.backgroundColor = UIColor.clearColor
    
    layout = UICollectionViewFlowLayout.alloc.init
    layout.scrollDirection          = UICollectionViewScrollDirectionHorizontal
    layout.sectionInset             = UIEdgeInsetsMake(10, 10, 10, 10) # top, left, bottom, right
    layout.minimumInteritemSpacing  = 0.0
    layout.minimumLineSpacing       = 10.0
    
    
    self.collectionView = UICollectionView.alloc.initWithFrame(CGRectZero, collectionViewLayout:layout).tap do |collection|
      collection.backgroundColor = UIColor.clearColor
      collection.registerClass(NewsViewCell, forCellWithReuseIdentifier:"NewsViewCell")
      collection.delegate   = self
      collection.dataSource = self
      collection.directionalLockEnabled = false
      
      self.addSubview(collection)
    end
    
    self
  end
  
  def layoutSubviews
    super
    
    self.collectionView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
  end
  
  def collectionView(collectionView, layout:collectionViewLayout, sizeForItemAtIndexPath:indexPath)
    CGSizeMake(self.size, self.frame.size.height-10-10)
  end
  
  def numberOfSectionsInCollectionView(collectionView)
    1
  end

  def collectionView(collectionView, numberOfItemsInSection:section)
    self.data.count
  end
  
  def collectionView(collectionView, cellForItemAtIndexPath:indexPath)
    cell = collectionView.dequeueReusableCellWithReuseIdentifier("NewsViewCell", forIndexPath:indexPath)
    cell.headlineLabel.text = self.data[indexPath.row].title
    
    placeholder = UIImage.imageNamed("NewsPoster.png")
    cell.heroView.url = { url: self.data[indexPath.row].imageUrl, placeholder: placeholder }
    cell.sourceLogoView.image = self.data[indexPath.row].icon
    
    case self.size / (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad ? 2 : 1)
    when 230
      cell.headlineLabel.font = UIFont.boldSystemFontOfSize(22)
    when 170
      cell.headlineLabel.font = UIFont.boldSystemFontOfSize(20)
    when 120
      cell.headlineLabel.font = UIFont.boldSystemFontOfSize(18)
    end
    
    # if self.size == (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad ? 2 : 1) * 230
    #   cell.headlineLabel.font = UIFont.boldSystemFontOfSize(22)
    # end
    
    cell
  end
  
  
  
  def collectionView(collectionView, didSelectItemAtIndexPath:indexPath)
    # viewController = MHDNavigationController.alloc.initWithRootViewController()
    # self.navigationController.presentViewController(viewController, animated:true, completion:lambda { })
    viewController = DetailViewController.alloc.initWithNews(self.data[indexPath.row])
    self.navigationController.pushViewController(viewController, animated:true)
  end
end