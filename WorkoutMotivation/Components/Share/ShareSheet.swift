//
//  ShareSheet.swift
//  WorkoutMotivation
//
//  Created by 박지용 on 6/7/24.
//

import SwiftUI

struct ShareSheet: UIViewControllerRepresentable {
    var activityItems: [Any] // 공유할 항목
//    var items: [Any]
    var applicationActivities: [UIActivity]? = nil // 추가 활동(선택 사항)

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
        return controller
    }
    
//    func makeUIViewController(context: Context) -> UIActivityViewController {
//        return UIActivityViewController(activityItems: items, applicationActivities: nil)
//    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
