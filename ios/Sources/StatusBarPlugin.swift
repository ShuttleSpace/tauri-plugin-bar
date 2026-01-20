
import OSLog
import SwiftRs
import Tauri
import UIKit
import WebKit

let log = OSLog(subsystem: "com.tauri.dev", category: "plugin.immersionbar")

class SetImmersionBarArgs: Decodable {
  let paddingStatusBar: Bool?
  let paddingNavigationBar: Bool?
  let darkStatusBar: Bool?
  let showStatusBar: Bool?
  let showNavigationBar: Bool?
}

class ImmersionBarPlugin: Plugin {
  private var paddingStatusBar: Bool = false
  private var paddingNavigationBar: Bool = false
  private var darkStatusBar: Bool = false
  private var showStatusBar: Bool = true
  private var showNavigationBar: Bool = false
  private var statusBarWindow: UIWindow?

  @objc public func setImmersionBar(_ invoke: Invoke) throws {
    let args = try invoke.parseArgs(SetImmersionBarArgs.self)
    os_log(.debug, log: log, "setImmersionBar-args: paddingStatusBar-%{public}@, paddingNavigationBar-%{public}@, darkStatusBar-%{public}@, showStatusBar-%{public}@, showNavigationBar-%{public}@", 
           String(describing: args.paddingStatusBar), 
           String(describing: args.paddingNavigationBar), 
           String(describing: args.darkStatusBar), 
           String(describing: args.showStatusBar), 
           String(describing: args.showNavigationBar))

    if let paddingStatusBar = args.paddingStatusBar {
      self.paddingStatusBar = paddingStatusBar
    }
    if let paddingNavigationBar = args.paddingNavigationBar {
      self.paddingNavigationBar = paddingNavigationBar
    }
    if let darkStatusBar = args.darkStatusBar {
      self.darkStatusBar = darkStatusBar
      // 设置状态栏样式，需要通过ViewController来处理
      DispatchQueue.main.async {
        if let viewController = self.manager?.viewController {
          viewController.setNeedsStatusBarAppearanceUpdate()
        }
      }
    }
    if let showStatusBar = args.showStatusBar {
      self.showStatusBar = showStatusBar
      DispatchQueue.main.async {
        if #available(iOS 13.0, *) {
          if self.statusBarWindow != nil {
            self.statusBarWindow!.isHidden = !showStatusBar
          } else if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            if let statusBarFrame = windowScene.statusBarManager?.statusBarFrame {
              let window = UIWindow(frame: statusBarFrame)
              window.backgroundColor = .clear
              window.windowLevel = .statusBar + 1
              window.isHidden = !showStatusBar
              self.statusBarWindow = window
            }
          }
        } else {
          // iOS 13 以下使用旧方法
          UIApplication.shared.isStatusBarHidden = !showStatusBar
        }
      }
    }
    if let showNavigationBar = args.showNavigationBar {
      self.showNavigationBar = showNavigationBar
      // 注意：导航栏的显示/隐藏通常由导航控制器处理
      os_log(.debug, log: log, "Navigation bar visibility change requested, but native implementation may be needed separately")
    }
    
    invoke.resolve()
  }

  @objc public func enable(_ invoke: Invoke) throws {
    os_log(.debug, log: log, "enable immersion bar")
    
    // 重置为默认显示状态
    self.showStatusBar = true
    
    DispatchQueue.main.async {
      if #available(iOS 13.0, *) {
        if let window = self.statusBarWindow {
          window.isHidden = false
        } else if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
          if let statusBarFrame = windowScene.statusBarManager?.statusBarFrame {
            let window = UIWindow(frame: statusBarFrame)
            window.backgroundColor = .clear
            window.windowLevel = .statusBar + 1
            window.isHidden = false
            self.statusBarWindow = window
          }
        }
      } else {
        // iOS 13 以下使用旧方法
        UIApplication.shared.isStatusBarHidden = false
      }
      
      if let viewController = self.manager?.viewController {
        viewController.setNeedsStatusBarAppearanceUpdate()
      }
    }
    
    invoke.resolve()
  }

  @objc public func disable(_ invoke: Invoke) throws {
    os_log(.debug, log: log, "disable immersion bar")
    
    // 隐藏状态栏
    self.showStatusBar = false
    
    DispatchQueue.main.async {
      if #available(iOS 13.0, *) {
        if let window = self.statusBarWindow {
          window.isHidden = true
        } else if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
          if let statusBarFrame = windowScene.statusBarManager?.statusBarFrame {
            let window = UIWindow(frame: statusBarFrame)
            window.backgroundColor = .clear
            window.windowLevel = .statusBar + 1
            window.isHidden = true
            self.statusBarWindow = window
          }
        }
      } else {
        // iOS 13 以下使用旧方法
        UIApplication.shared.isStatusBarHidden = true
      }
    }
    
    invoke.resolve()
  }
  
  // 实现 preferredStatusBarStyle 方法，需要在扩展或子类中处理
  public override var isStatusBarHidden: Bool {
    return !self.showStatusBar
  }
  
  public override var preferredStatusBarStyle: UIStatusBarStyle {
    return self.darkStatusBar ? .default : .lightContent
  }

  override func load(webview: WKWebView) {
    super.load(webview: webview)

    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
      if let statusBarFrame = windowScene.statusBarManager?.statusBarFrame {
        let window = UIWindow(frame: statusBarFrame)
        statusBarWindow = window
        os_log("statusBarWindow == nil? %{public}@", statusBarWindow == nil)
      }
    }

    if let statusBarFrame = UIApplication.shared.windows.first?.windowScene?.statusBarManager?.statusBarFrame {
      let statusBarView = UIView(frame: statusBarFrame)
      if let backgroundColor = statusBarView.backgroundColor {
        os_log(.debug, log: log, "backgroundColor：%{public}@", backgroundColor)
      } else {
        os_log(.debug, log: log, "backgroundColor not setting or transparent")
      }
    }

    let style = UITraitCollection.current.userInterfaceStyle
    if style == .dark {
      os_log(.debug, log: log, "style light text color")
    } else {
      os_log(.debug, log: log, "style dark text color")
    }

    if let window = UIApplication.shared.windows.first {
      let statusBarHeight = window.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
      if webview.frame.origin.y <= statusBarHeight {
        os_log(.debug, log: log, "overlay true")
      } else {
        os_log(.debug, log: log, "overlay false")
      }
    }
  }

  @objc public func isVisible(_ invoke: Invoke) throws {
    let _visible = visible()
    os_log(.debug, log: log, "isVisible： %{public}@", _visible)
    invoke.resolve(_visible)
  }

  @objc public func hide(_ invoke: Invoke) throws {
    if #available(iOS 13.0, *) {
      if statusBarWindow != nil {
        statusBarWindow!.backgroundColor = .clear
        statusBarWindow!.windowLevel = .statusBar + 1
        statusBarWindow!.isHidden = false
      } else if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
        if let statusBarFrame = windowScene.statusBarManager?.statusBarFrame {
          let window = UIWindow(frame: statusBarFrame)
          window.backgroundColor = .clear
          window.windowLevel = .statusBar + 1
          window.isHidden = false
          statusBarWindow = window
        }
      }
    } else {
      UIApplication.shared.isStatusBarHidden = true
    }
  }

  func visible() -> Bool {
    if #available(iOS 13.0, *) {
      if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
        return !(windowScene.statusBarManager!.isStatusBarHidden)
      }
      return true
    } else {
      return !UIApplication.shared.isStatusBarHidden
    }
  }
}

@_cdecl("init_plugin_immersionbar")
func initPlugin() -> Plugin {
  return ImmersionBarPlugin()
}