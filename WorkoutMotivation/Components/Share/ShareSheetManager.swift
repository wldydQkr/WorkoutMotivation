//
//  ShareSheetManager.swift
//  WorkoutMotivation
//
//  Created by 박지용 on 10/25/24.
//

import SwiftUI
import UIKit

class ShareSheetManager {
    static let shared = ShareSheetManager()

    init() {}

    func presentShareSheet(activityItems: [Any]) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else { return }

        let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        rootViewController.present(activityViewController, animated: true, completion: nil)
    }
}
