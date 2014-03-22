class AreaSectionViewCell < UITableViewCell
  attr_accessor :navigationController
  attr_accessor :size
  attr_accessor :collectionView
  attr_accessor :data
  
  attr_accessor :sectionLabel
  
  def initWithStyle(style, reuseIdentifier:reuseIdentifier)
    super
    
    self.backgroundColor = UIColor.clearColor
    
    layout = UICollectionViewFlowLayout.alloc.init
    layout.scrollDirection          = UICollectionViewScrollDirectionHorizontal
    layout.sectionInset             = UIEdgeInsetsMake(10, 10, 0, 0) # top, left, bottom, right
    layout.minimumInteritemSpacing  = 0.0
    layout.minimumLineSpacing       = 10.0
    
    
    self.collectionView = UICollectionView.alloc.initWithFrame(CGRectZero, collectionViewLayout:layout).tap do |collection|
      collection.registerClass(NewsViewCell, forCellWithReuseIdentifier:"NewsViewCell")
      collection.delegate   = self
      collection.dataSource = self
      
      self.addSubview(collection)
    end
    
    self.sectionLabel = UILabel.alloc.init.tap do |label|
      label.textColor               = UIColor.whiteColor
      label.font                    = UIFont.boldSystemFontOfSize(30)
      label.userInteractionEnabled  = false
      self.addSubview(label)
    end
    
    self
  end
  
  def layoutSubviews
    super
    
    self.sectionLabel.frame   = CGRectMake(30, self.frame.size.height-60, self.frame.size.width, 60)
    self.collectionView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
  end
  
  def collectionView(collectionView, layout:collectionViewLayout, sizeForItemAtIndexPath:indexPath)
    CGSizeMake(self.size, self.frame.size.height-5-5)
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
    
    placeholder = UIImage.imageNamed("Dummy-Images/News-Hero-#{rand(5)}.jpg")
    cell.heroView.url = { url: self.data[indexPath.row].imageUrl, placeholder: placeholder }
    
    cell
  end
  
  def collectionView(collectionView, didSelectItemAtIndexPath:indexPath)
    # viewController = UINavigationController.alloc.initWithRootViewController(DetailViewController.alloc.init)
    viewController = DetailViewController.alloc.initWithNews(self.data[indexPath.row])
    self.navigationController.presentViewController(viewController, animated:true, completion:lambda { })
  end
end