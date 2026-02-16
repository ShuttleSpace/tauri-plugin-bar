import OSLog
import SwiftRs
import Tauri
import UIKit
import WebKit

let log = OSLog(subsystem: "com.tauri.dev", category: "plugin.immersionbar")

class SetImmersionBarArgs: Decodable {
  let transparentStatusBar: Bool?
  let transparentNavigationBar: Bool?
  let transparentBar: Bool?
  // Colors - Supported formats:
  // - Hexadecimal: "#RGB", "#ARGB", "#RRGGBB", "#AARRGGBB"
  // - Named colors will be converted (iOS supports hex formats primarily)
  let statusBarColor: String?
  let navigationBarColor: String?
  let barColor: String?
  let statusBarAlpha: Double?
  let navigationBarAlpha: Double?
  let barAlpha: Double?
  let statusBarDarkFont: Bool?
  let navigationBarDarkIcon: Bool?
  let autoDarkModeEnable: Bool?
  let autoStatusBarDarkModeEnable: Bool?
  let autoStatusBarDarkModeThreshold: Double?
  let autoNavigationBarDarkModeEnable: Bool?
  let autoNavigationBarDarkModeThreshold: Double?
  let fullScreen: Bool?
  let fitsSystemWindows: Bool?
  let hideStatusBar: Bool?
  let hideNavigationBar: Bool?
  let navigationBarEnable: Bool?
  let keyboardEnable: Bool?
  let reset: Bool?
}

class ImmersionBarPlugin: Plugin {
  private var statusBarColor: UIColor?
  private var statusBarAlpha: CGFloat = 1.0
  private var statusBarDarkFont: Bool = false
  private var hideStatusBar: Bool = false
  private var statusBarWindow: UIWindow?

  @objc public func setImmersionBar(_ invoke: Invoke) throws {
    do {
      let args = try invoke.parseArgs(SetImmersionBarArgs.self)
      
      if args.reset == true {
        statusBarColor = nil
        statusBarAlpha = 1.0
        statusBarDarkFont = false
        hideStatusBar = false
      }
      
      // Handle transparency
      if args.transparentStatusBar == true || args.transparentBar == true {
        statusBarColor = .clear
        statusBarAlpha = 0.0
      }
      
      // Handle colors
      if let colorHex = args.statusBarColor ?? args.barColor {
        statusBarColor = hexToUIColor(colorHex)
      }
      
      // Handle alpha
      if let alpha = args.statusBarAlpha ?? args.barAlpha {
        statusBarAlpha = CGFloat(alpha)
      }
      
      // Handle dark mode
      if let darkFont = args.statusBarDarkFont ?? args.autoDarkModeEnable ?? args.autoStatusBarDarkModeEnable {
        statusBarDarkFont = darkFont
      }
      
      // Handle visibility
      if let hide = args.hideStatusBar {
        hideStatusBar = hide
      }
      
      // Apply changes
      DispatchQueue.main.async {
        self.updateStatusBar()
        if let viewController = self.manager?.viewController {
          viewController.setNeedsStatusBarAppearanceUpdate()
        }
      }
      
      invoke.resolve()
    } catch {
      invoke.reject(error.localizedDescription)
    }
  }
  
  private func updateStatusBar() {
    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
    
    if let statusBarFrame = windowScene.statusBarManager?.statusBarFrame {
      if statusBarWindow == nil {
        let window = UIWindow(frame: statusBarFrame)
        window.windowLevel = .statusBar + 1
        statusBarWindow = window
      }
      
      statusBarWindow?.backgroundColor = statusBarColor?.withAlphaComponent(statusBarAlpha)
      statusBarWindow?.isHidden = hideStatusBar
    }
  }
  
  private func hexToUIColor(_ hex: String) -> UIColor {
    var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
    hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
    
    var rgb: UInt64 = 0
    Scanner(string: hexSanitized).scanHexInt64(&rgb)
    
    let length = hexSanitized.count
    let r, g, b, a: CGFloat
    
    if length == 8 {
      a = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
      r = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
      g = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
      b = CGFloat(rgb & 0x000000FF) / 255.0
    } else {
      r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
      g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
      b = CGFloat(rgb & 0x0000FF) / 255.0
      a = 1.0
    }
    
    return UIColor(red: r, green: g, blue: b, alpha: a)
  }

  public override var isStatusBarHidden: Bool {
    return hideStatusBar
  }

  public override var preferredStatusBarStyle: UIStatusBarStyle {
    return statusBarDarkFont ? .darkContent : .lightContent
  }

  override func load(webview: WKWebView) {
    super.load(webview: webview)
    
    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
       let statusBarFrame = windowScene.statusBarManager?.statusBarFrame {
      let window = UIWindow(frame: statusBarFrame)
      statusBarWindow = window
    }
  }

  @objc public func isVisible(_ invoke: Invoke) throws {
    let _visible = visible()
    invoke.resolve(_visible)
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
