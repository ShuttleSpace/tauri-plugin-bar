import { invoke } from "@tauri-apps/api/core";

export interface SetImmersionBarArgs {
  // Transparency
  transparentStatusBar?: boolean;
  transparentNavigationBar?: boolean;
  transparentBar?: boolean;
  
  // Colors
  // Supported formats:
  // - Hexadecimal: "#RGB", "#ARGB", "#RRGGBB", "#AARRGGBB"
  // - Named colors: "red", "blue", "green", "black", "white", "gray", "cyan", "magenta", "yellow"
  // - Android also supports: "darkgray", "lightgray", "aqua", "fuchsia", "lime", "maroon", "navy", "olive", "purple", "silver", "teal"
  // - iOS supports hex formats and will convert named colors
  statusBarColor?: string;
  navigationBarColor?: string;
  barColor?: string;
  
  // Alpha (0.0 - 1.0)
  statusBarAlpha?: number;
  navigationBarAlpha?: number;
  barAlpha?: number;
  
  // Dark mode
  statusBarDarkFont?: boolean;
  navigationBarDarkIcon?: boolean;
  autoDarkModeEnable?: boolean;
  autoStatusBarDarkModeEnable?: boolean;
  autoStatusBarDarkModeThreshold?: number;
  autoNavigationBarDarkModeEnable?: boolean;
  autoNavigationBarDarkModeThreshold?: number;
  
  // Layout
  fullScreen?: boolean;
  fitsSystemWindows?: boolean;
  
  // Visibility
  hideStatusBar?: boolean;
  hideNavigationBar?: boolean;
  
  // Enable flags
  navigationBarEnable?: boolean;
  keyboardEnable?: boolean;
  
  // Reset
  reset?: boolean;
}

export async function setImmersionBar(args?: SetImmersionBarArgs): Promise<void> {
  await invoke("plugin:immersionbar|set_immersionbar", {
    payload: args,
  });
}
