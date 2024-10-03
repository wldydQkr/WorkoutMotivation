//
//  Path.swift
//  WorkoutMotivation
//
//  Created by 박지용 on 6/1/24.
//

import Foundation

class PathModel: ObservableObject {
  @Published var paths: [PathType]
  
  init(paths: [PathType] = []) {
    self.paths = paths
  }
}
