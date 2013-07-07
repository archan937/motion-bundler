class AppDelegate

  def buildWindow
    @mainWindow = NSWindow.alloc.initWithContentRect(
      [[240, 180], [480, 360]],
      styleMask: NSTitledWindowMask | NSClosableWindowMask | NSMiniaturizableWindowMask | NSResizableWindowMask,
      backing: NSBackingStoreBuffered,
      defer: false
    )
    @mainWindow.title = NSBundle.mainBundle.infoDictionary["CFBundleName"]
    @mainWindow.orderFrontRegardless
  end

end