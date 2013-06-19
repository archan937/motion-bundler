module REXML
  class Child; end
end

class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.rootViewController = AppController.alloc.init
    @window.makeKeyAndVisible
    true
  end
end