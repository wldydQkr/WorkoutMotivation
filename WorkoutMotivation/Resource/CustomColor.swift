//
//  CustomColor.swift
//  WorkoutMotivation
//
//  Created by 박지용 on 6/9/24.
//

import UIKit
import SwiftUI

enum CustomColor {
    
}

extension CustomColor {
    enum UIKit {
        static let customBackground: UIColor = UIColor (named: "customBackground")!
        static let customGreen: UIColor = UIColor (named: "customGreen")!
        static let customGreen2: UIColor = UIColor (named: "customGreen2")!
        static let customGreen3: UIColor = UIColor (named: "customGreen3")!
        static let customWhite: UIColor = UIColor (named: "customWhite")!
        static let customBlack: UIColor = UIColor (named: "customBlack")!
        static let customBlack2: UIColor = UIColor (named: "customBlack2")!
        static let customBlack3: UIColor = UIColor (named: "customBlack3")!
    }
}

extension CustomColor {
    enum SwiftUI {
        static let customBackgrond: Color = .init("customBackground")
        static let customGreen: Color = .init("customGreen")
        static let customGreen2: Color = .init("customGreen2")
        static let customGreen3: Color = .init("customGreen3")
        static let customGreen4: Color = .init("customGreen4")
        static let customWhite: Color = .init("customWhite")
        static let customBlack: Color = .init("customBlack")
        static let customBlack2: Color = .init("customBlack2")
        static let customBlack3: Color = .init("customBlack3")
    }
}
