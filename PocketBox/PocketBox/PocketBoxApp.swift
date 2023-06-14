//
//  PocketBoxApp.swift
//  PocketBox
//
//  Created by MBSoo on 2023/06/10.
//

import SwiftUI
import KakaoSDKAuth
import KakaoSDKCommon

@main
struct PocketBoxApp: App {
    init() {
        KakaoSDK.initSDK(appKey: "05f3ea82d4f8c131434d01a67bbd194f") // 네이티브 앱 키
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL { url in
                    if(AuthApi.isKakaoTalkLoginUrl(url)) {
                        _ = AuthController.handleOpenUrl(url: url)
                    }
                }
        }
    }
}
