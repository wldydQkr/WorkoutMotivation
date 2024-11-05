//
//  View+.swift
//  WorkoutMotivation
//
//  Created by 박지용 on 6/7/24.
//

import SwiftUI

extension View {
    func navigationBarColor(_ backgroundColor: UIColor?) -> some View {
        self.modifier(NavigationBarModifier(backgroundColor: backgroundColor))
    }
    
    // Helper function to hide keyboard
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
}
