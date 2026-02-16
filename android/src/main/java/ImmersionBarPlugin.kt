package com.tauri.immersionbar

import android.app.Activity
import app.tauri.annotation.Command
import app.tauri.annotation.InvokeArg
import app.tauri.annotation.TauriPlugin
import app.tauri.plugin.Invoke
import app.tauri.plugin.Plugin
import android.util.Log
import com.gyf.immersionbar.ImmersionBar

@InvokeArg
class SetBarArgs {
    var transparentStatusBar: Boolean? = null
    var transparentNavigationBar: Boolean? = null
    var transparentBar: Boolean? = null
    // Colors - Supported formats:
    // - Hexadecimal: "#RGB", "#ARGB", "#RRGGBB", "#AARRGGBB"
    // - Named colors: "red", "blue", "green", "black", "white", "gray", "cyan", "magenta", "yellow",
    //   "darkgray", "lightgray", "aqua", "fuchsia", "lime", "maroon", "navy", "olive", "purple", "silver", "teal"
    var statusBarColor: String? = null
    var navigationBarColor: String? = null
    var barColor: String? = null
    var statusBarAlpha: Float? = null
    var navigationBarAlpha: Float? = null
    var barAlpha: Float? = null
    var statusBarDarkFont: Boolean? = null
    var navigationBarDarkIcon: Boolean? = null
    var autoDarkModeEnable: Boolean? = null
    var autoStatusBarDarkModeEnable: Boolean? = null
    var autoStatusBarDarkModeThreshold: Float? = null
    var autoNavigationBarDarkModeEnable: Boolean? = null
    var autoNavigationBarDarkModeThreshold: Float? = null
    var fullScreen: Boolean? = null
    var fitsSystemWindows: Boolean? = null
    var hideStatusBar: Boolean? = null
    var hideNavigationBar: Boolean? = null
    var navigationBarEnable: Boolean? = null
    var keyboardEnable: Boolean? = null
    var reset: Boolean? = null
}

@TauriPlugin
class ImmersionBarPlugin(private val activity: Activity) : Plugin(activity) {
    
    @Command
    fun setImmersionBar(invoke: Invoke) {
        try {
            val args = invoke.parseArgs(SetBarArgs::class.java)
            
            activity.runOnUiThread {
                val bar = ImmersionBar.with(activity)
                
                if (args.reset == true) {
                    bar.reset()
                        .transparentStatusBar()
                        .statusBarDarkFont(true)
                        .init()
                    invoke.resolve()
                    return@runOnUiThread
                }
                
                args.transparentStatusBar?.let { if (it) bar.transparentStatusBar() }
                args.transparentNavigationBar?.let { if (it) bar.transparentNavigationBar() }
                args.transparentBar?.let { if (it) bar.transparentBar() }
                
                args.statusBarColor?.let { bar.statusBarColor(it) }
                args.navigationBarColor?.let { bar.navigationBarColor(it) }
                args.barColor?.let { bar.barColor(it) }
                
                args.statusBarAlpha?.let { bar.statusBarAlpha(it) }
                args.navigationBarAlpha?.let { bar.navigationBarAlpha(it) }
                args.barAlpha?.let { bar.barAlpha(it) }
                
                args.statusBarDarkFont?.let { bar.statusBarDarkFont(it) }
                args.navigationBarDarkIcon?.let { bar.navigationBarDarkIcon(it) }
                args.autoDarkModeEnable?.let { bar.autoDarkModeEnable(it) }
                args.autoStatusBarDarkModeEnable?.let { 
                    bar.autoStatusBarDarkModeEnable(it, args.autoStatusBarDarkModeThreshold ?: 0.2f)
                }
                args.autoNavigationBarDarkModeEnable?.let {
                    bar.autoNavigationBarDarkModeEnable(it, args.autoNavigationBarDarkModeThreshold ?: 0.2f)
                }
                
                args.fullScreen?.let { bar.fullScreen(it) }
                args.fitsSystemWindows?.let { bar.fitsSystemWindows(it) }
                
                if (args.hideStatusBar == true && args.hideNavigationBar == true) {
                    bar.hideBar(com.gyf.immersionbar.BarHide.FLAG_HIDE_BAR)
                } else {
                    args.hideStatusBar?.let { if (it) bar.hideBar(com.gyf.immersionbar.BarHide.FLAG_HIDE_STATUS_BAR) }
                    args.hideNavigationBar?.let { if (it) bar.hideBar(com.gyf.immersionbar.BarHide.FLAG_HIDE_NAVIGATION_BAR) }
                }
                
                args.navigationBarEnable?.let { bar.navigationBarEnable(it) }
                args.keyboardEnable?.let { bar.keyboardEnable(it) }
                
                bar.init()
                invoke.resolve()
            }
        } catch (e: Exception) {
            Log.e("ImmersionBarPlugin", "Error setting immersion bar", e)
            invoke.reject(e.message ?: "Unknown error")
        }
    }
}
