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
      
      self.addSubview(collection)
    end
    
    # self.shadowFromLeft = UIImageView.alloc.initWithFrame(CGRectZero).tap do |imageView|
    #   imageView.image       = UIImage.imageNamed("News-Shadow-From-Left.png")
    #   imageView.alpha       = 0.5
    #   imageView.contentMode = UIViewContentModeScaleToFill
    #   self.addSubview(imageView)
    # end
    
    # self.sectionLabel = UITextView.alloc.init.tap do |label|
    #   label.editable                = false
    #   label.selectable              = false
    #   label.textAlignment           = NSTextAlignmentRight
    #   label.textContainerInset      = UIEdgeInsetsMake(10, 0, 0, 10) # top, left, bottom, right
    #   label.textColor               = UIColor.whiteColor
    #   label.backgroundColor         = UIColor.blackColor
    #   label.font                    = UIFont.boldSystemFontOfSize(16)
    #   label.alpha                   = 0.8
    #   label.userInteractionEnabled  = false
    #   label.layer.cornerRadius      = 6
    #   label.layer.masksToBounds     = true
    #   self.addSubview(label)
    # end
    
    self
  end
  
  def layoutSubviews
    super
    
    # self.shadowFromLeft.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
    # self.sectionLabel.frame   = CGRectMake(-10, self.frame.size.height-50, 170, 40)
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
    
    cell
  end
  
  def collectionView(collectionView, didSelectItemAtIndexPath:indexPath)
    viewController = MHDNavigationController.alloc.initWithRootViewController(DetailViewController.alloc.initWithNews(self.data[indexPath.row]))
    self.navigationController.presentViewController(viewController, animated:true, completion:lambda { })
  end
end