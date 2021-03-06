# README.md

## 2020 / 6 / 6 審退資訊

#### Guideline 2.1 - Performance - App Completeness

```
1. Your app or its metadata does not appear to include final content. 

油价公告
Before you submit your app to the App Store, all of its content and metadata must be final. Your app must not include placeholder or incomplete information. For example, an app with “lorem ipsum” text in the app description field will be rejected. Likewise, an app with placeholder screenshots, such as “screenshot coming soon,” will be rejected. Instead, you should only submit an app with complete information and content throughout.
```

解決方案：

APPLE 認為開發完整性不夠，並且不該使用占位字符（lorem ipsum）
移除該問題後，並加上 API Loading 中的 loadingView
```
2. Your app crashed on iPad running iOS 13.5 on WiFi when we:

1: launch the app
2: tap on 所有区域
3: app crash 

We have attached detailed crash logs to help troubleshoot this issue.
```

解決方案：

此為閃退問題，主要為點擊"所有區域"時，action 需調用 bannerView，但該時間序尚未建構 bannerView，造成 nil 閃退
已調整bannerView 生成以及使用時機。

#### Guideline 5.1.1 - Legal - Privacy - Data Collection and Storage

```
2. We noticed that your app requests the user’s consent to access their location but does not clarify the use of the location in the applicable purpose string.
```

解決方案：

主要為 APPLE 認為欲取得使用者定位權限，在 info.plist 中未描述清楚。
故調整 info.plist
key: Privacy - Location When In Use Usage Description
value: 點選「允許」：使用 App 期間，將可取得您目前座標來呈現該區域的天氣。
(請益過前輩，通常建議語意上必須讓使用者知道，點擊『允許』或『不允許』所產生的狀況或效果。)



## 2020 / 6 / 11 審退資訊
#### Guideline 2.1 - Information Needed

```
We have started the review of your app, but we are not able to continue because we need access to a video that demonstrates the current version of your app in use on a physical iOS device.

Please only include footage in your demo video of your app running on a physical iOS device, and not on a simulator. It is acceptable to use a screen recorder to capture footage of your app in use. Make sure all relevant app features, services, and permissions are clearly documented in the demo video.
```
解決方案：

主要為，此 APP 目前僅適合台灣使用，但審查團隊並未定位在台灣座標，將造成 APP 操作問題，
或為審查人員不清楚該 APP 如何操作時會要求提供 Demo Video
（建議未來如有定位功能，送審的 Metadata 一律要提供 Demo Video）
