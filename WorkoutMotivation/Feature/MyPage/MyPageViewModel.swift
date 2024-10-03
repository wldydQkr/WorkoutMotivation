//
//  MyPageViewModel.swift
//  WorkoutMotivation
//
//  Created by 박지용 on 6/9/24.
//

import Foundation
import MessageUI
import StoreKit

final class MyPageViewModel: ObservableObject {
    @Published var items: [MyPageItem] = []
    @Published var isShowingPushSettingView = false
    @Published var isShowingAppVersionView = false
    @Published var isShowingMailView = false
    @Published var isShowingShareSheet = false  // 공유 시트를 표시하는 상태
    @Published var mailResult: Result<MFMailComposeResult, Error>? = nil
    
    var activityItems: [Any] = []  // 공유할 아이템 (앱 스토어 링크)

    init() {
        items = [
            MyPageItem(title: "알림 설정", action: pushSetting),
            MyPageItem(title: "앱 평가하기", action: rateApp),
            MyPageItem(title: "앱 공유", action: shareApp),
            MyPageItem(title: "피드백", action: giveFeedback),
            MyPageItem(title: "앱 버전", action: showAppVersion)
        ]
    }
    
    func pushSetting() {
        print("알림 설정")
        isShowingPushSettingView = true
    }
    
    @objc func requestReview() {
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        } else {
            let appStoreLink = "https://apps.apple.com/app/idXXXXXXXXX"
            if let url = URL(string: appStoreLink) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    func rateApp() {
        requestReview()
        print("앱 평가하기 클릭됨")
    }

    func shareApp() {
        let appStoreLink = "https://apps.apple.com/app/idXXXXXXXXX"  // 앱 스토어 링크 설정
        activityItems = [appStoreLink]  // 공유할 항목 설정
        isShowingShareSheet = true
        print("앱 공유 클릭됨")
    }

    func giveFeedback() {
        if MFMailComposeViewController.canSendMail() {
            isShowingMailView = true
        } else {
            print("메일 서비스를 사용할 수 없습니다.")
        }
    }

    func showAppVersion() {
        isShowingAppVersionView = true
        print("앱 버전 클릭됨")
    }
}
