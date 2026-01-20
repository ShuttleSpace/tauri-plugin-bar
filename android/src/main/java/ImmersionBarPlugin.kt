package com.tauri.immersionbar

import android.app.Activity
import android.graphics.Color
import android.os.Build
import android.view.View
import android.view.Window
import android.view.WindowInsets
import android.view.WindowInsetsController
import android.view.WindowManager
import app.tauri.annotation.Command
import app.tauri.annotation.InvokeArg
import app.tauri.annotation.TauriPlugin
import app.tauri.plugin.Invoke
import app.tauri.plugin.Plugin
import com.yzq.immersionbar.ImmersionBar


@InvokeArg
class SetBarArgs {
  var paddingStatusBar: Boolean? = null
  var paddingNavigationBar: Boolean? = null
  var darkStatusBar: Boolean? = null
  var showStatusBar: Boolean? = null
  var showNavigationBar: Boolean? = null
}

@TauriPlugin
class ImmersionBarPlugin(private val activity: Activity) : Plugin(activity) {
  @Command
  fun enable(invoke: Invoke) {
    activity.runOnUiThread {
      val args = invoke.parseArgs<SetBarArgs>(SetBarArgs::class::java)
      ImmersionBar.enable(
        activity = activity,
        paddingStatusBar = args.paddingStatusBar,
        paddingNavigationBar = args.paddingNavigationBar,
        darkStatusBarText = args.darkStatusBar,
        showStatusBar = args.showStatusBar,
        showNavigationBar = args.showNavigationBar
      )
      invoke.resolve()
    }
  }

  @Command
  fun setImmersionBar(invoke: Invoke) {
    activity.runOnUiThread {
      val args = invoke.parseArgs<SetBarArgs>(SetBarArgs::class::java)
      ImmersionBar.updateSystemBars(
        activity = activity,
        paddingStatusBar = args.paddingStatusBar,
        paddingNavigationBar = args.paddingNavigationBar,
        darkStatusBarText = args.darkStatusBar,
        showStatusBar = args.showStatusBar,
        showNavigationBar = args.showNavigationBar
      )
      invoke.resolve()
    }
  }

  @Command
  fun disable(invoke: Invoke) {
    activity.runOnUiThread {
      val args = invoke.parseArgs<SetBarArgs>(SetBarArgs::class::java)
      ImmersionBar.disable(activity)
      ImmersionBar.updateSystemBars(
        activity = activity,
        paddingStatusBar = args.paddingStatusBar,
        paddingNavigationBar = args.paddingNavigationBar,
        darkStatusBarText = args.darkStatusBar,
        showStatusBar = args.showStatusBar,
        showNavigationBar = args.showNavigationBar
      )
      invoke.resolve()
    }
  }
}
