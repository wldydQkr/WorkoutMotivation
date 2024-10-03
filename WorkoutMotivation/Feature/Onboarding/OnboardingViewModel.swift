//
//  OnboardingViewModel.swift
//  WorkoutMotivation
//
//  Created by 박지용 on 6/1/24.
//

import Foundation

final class OnboardingViewModel: ObservableObject {
    @Published var onboardingContents: [OnboardingContent]
    
    init(onboardingContents: [OnboardingContent] = [
        .init(
            imageFileName: "onboardingLottie",
            content:
                """
                반가워요!
                워크아웃모티베이션은
                운동에 대한
                동기부여를 줍니다.
                우리 모두 열심히
                운동하고 득근해요!
                """)
    ]) {
        self.onboardingContents = onboardingContents
    }
}
