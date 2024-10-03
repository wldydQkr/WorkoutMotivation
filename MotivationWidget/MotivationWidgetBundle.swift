//
//  MotivationWidgetBundle.swift
//  MotivationWidget
//
//  Created by 박지용 on 6/12/24.
//

import WidgetKit
import SwiftUI

@main
struct MotivationWidgetBundle: WidgetBundle {
    @WidgetBundleBuilder
    var body: some Widget {
        MotivationWidget()
        MotivationWidgetLiveActivity()
    }
}
