class AreaSectionViewCell < UITableViewCell
  attr_accessor :navigationController
  attr_accessor :here
  attr_accessor :collectionView
  attr_accessor :data
  
  attr_accessor :sectionLabel
  
  def initWithStyle(style, reuseIdentifier:reuseIdentifier)
    super
    
    self.backgroundColor = UIColor.clearColor
    
    layout = UICollectionViewFlowLayout.alloc.init
    layout.scrollDirection          = UICollectionViewScrollDirectionHorizontal
    layout.sectionInset             = UIEdgeInsetsMake(0, 0, 0, 0) # top, left, bottom, right
    layout.minimumInteritemSpacing  = 0.0
    layout.minimumLineSpacing       = 0.0
    
    
    self.collectionView = UICollectionView.alloc.initWithFrame(CGRectZero, collectionViewLayout:layout).tap do |collection|
      collection.registerClass(NewsViewCell, forCellWithReuseIdentifier:"NewsViewCell")
      
      collection.delegate = self
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
    
    self.sectionLabel.frame = CGRectMake(10, self.frame.size.height-86, self.frame.size.width, 86)
    self.collectionView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
    # self.collectionView.collectionViewLayout.itemSize = CGSizeMake(125, self.frame.size.height)
  end
  
  def collectionView(collectionView, layout:collectionViewLayout, sizeForItemAtIndexPath:indexPath)
    CGSizeMake((self.here ? 125 : 200), self.frame.size.height)
  end
  
  def numberOfSectionsInCollectionView(collectionView)
    1
  end

  def collectionView(collectionView, numberOfItemsInSection:section)
    self.data.count
  end
  
  def collectionView(collectionView, cellForItemAtIndexPath:indexPath)
    cell = collectionView.dequeueReusableCellWithReuseIdentifier("NewsViewCell", forIndexPath:indexPath)
    cell
  end
  
  def collectionView(collectionView, didSelectItemAtIndexPath:indexPath)
  end
end