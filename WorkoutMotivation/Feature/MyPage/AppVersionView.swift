//
//  AppVersionView.swift
//  WorkoutMotivation
//
//  Created by 박지용 on 8/21/24.
//

import SwiftUI

struct AppVersionView: View {
    private var appVersion: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "null"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "Version \(version) (\(build))"
    }
    
    var body: some View {
        NavigationView {
            Text(appVersion)
                .font(.footnote)
                .foregroundColor(.gray)
                .padding()
        }
        .navigationBarBackButtonHidden(false)
    }
}

struct ContentView: View {
    var body: some View {
        VStack {
            
            Spacer()
            
            AppVersionView()
        }
        .padding()
    }
}

#Preview {
    AppVersionView()
}
