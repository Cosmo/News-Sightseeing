class MHDNavigationController < UINavigationController
  def viewDidLoad
    super
    
    self.navigationBar.setBackgroundImage(UIImage.imageNamed("NavigationBar-Background.png"), forBarMetrics:UIBarMetricsDefault)
    self.navigationBar.shadowImage      = UIImage.new
    self.navigationBar.translucent      = true
    self.navigationBar.tintColor        = UIColor.whiteColor
    self.navigationBar.barStyle         = UIBarStyleBlack
    self.navigationBar.backgroundColor  = UIColor.clearColor
    
    # self.view.backgroundColor = UIColor.colorWithRed(16/255.0, green:16/255.0, blue:16/255.0, alpha:1.0)
  end
end