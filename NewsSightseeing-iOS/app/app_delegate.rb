class AppDelegate
  attr_accessor :window
  
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    self.window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    self.window.rootViewController = UINavigationController.alloc.initWithRootViewController(MainViewController.alloc.init)
    self.window.makeKeyAndVisible
    
    true
  end
end
