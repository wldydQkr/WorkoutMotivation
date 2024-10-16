//
//  HomeViewModel.swift
//  WorkoutMotivation
//
//  Created by 박지용 on 6/2/24.
//

import Foundation
import Combine

final class HomeViewModel: ObservableObject {
    @Published var selectedTab: Tab
    
    init(selectedTab: Tab = .motivation) {
        self.selectedTab = selectedTab
    }
    
}

extension HomeViewModel {
    func changeSelectedTab(_ tab: Tab) {
        selectedTab = tab
    }
    
}
