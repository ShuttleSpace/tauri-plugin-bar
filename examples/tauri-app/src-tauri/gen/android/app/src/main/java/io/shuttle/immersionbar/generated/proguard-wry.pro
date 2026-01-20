# THIS FILE IS AUTO-GENERATED. DO NOT MODIFY!!

# Copyright 2020-2023 Tauri Programme within The Commons Conservancy
# SPDX-License-Identifier: Apache-2.0
# SPDX-License-Identifier: MIT

-keep class io.shuttle.immersionbar.* {
  native <methods>;
}

-keep class io.shuttle.immersionbar.WryActivity {
  public <init>(...);

  void setWebView(io.shuttle.immersionbar.RustWebView);
  java.lang.Class getAppClass(...);
  java.lang.String getVersion();
}

-keep class io.shuttle.immersionbar.Ipc {
  public <init>(...);

  @android.webkit.JavascriptInterface public <methods>;
}

-keep class io.shuttle.immersionbar.RustWebView {
  public <init>(...);

  void loadUrlMainThread(...);
  void loadHTMLMainThread(...);
  void evalScript(...);
}

-keep class io.shuttle.immersionbar.RustWebChromeClient,io.shuttle.immersionbar.RustWebViewClient {
  public <init>(...);
}
