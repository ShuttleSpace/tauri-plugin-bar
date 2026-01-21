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
    var paddingStatusBar: Boolean? = null
    var paddingNavigationBar: Boolean? = null
    var darkStatusBar: Boolean? = null
    var showStatusBar: Boolean? = null
    var showNavigationBar: Boolean? = null
}

@TauriPlugin
class ImmersionBarPlugin(private val activity: Activity) : Plugin(activity) {
    @Command
    fun setImmersionBar(invoke: Invoke) {
        val args: SetBarArgs = invoke.parseArgs(SetBarArgs::javaClass as Class<SetBarArgs>)
        Log.d("ImmersionBarPlugin", "setImmersionBar: Received args: $args")
        val immersionBar = ImmersionBar.with(activity)
            .reset()
            .autoDarkModeEnable(args.darkStatusBar == true)
        if (args.showStatusBar == true) {
            immersionBar.transparentStatusBar()
        }
        if (args.showNavigationBar == true) {
            immersionBar.transparentNavigationBar()
        }
        immersionBar.init()
        invoke.resolve()
    }
}
