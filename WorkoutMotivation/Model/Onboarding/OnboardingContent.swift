//
//  OnboardingContent.swift
//  WorkoutMotivation
//
//  Created by 박지용 on 6/1/24.
//

import Foundation

struct OnboardingContent: Hashable {
    var imageFileName: String
    var content: String
    
    init(imageFileName: String, content: String) {
        self.imageFileName = imageFileName
        self.content = content
    }
}
