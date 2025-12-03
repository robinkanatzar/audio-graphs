//
//  ExampleRoute.swift
//  AudioGraphs
//
//  Created by Naren on 02/12/25.
//

import SwiftUI

/// Defines all available example routes in the app.
/// Add new cases here to automatically include them in the examples list.
enum ExampleRoute: String, CaseIterable, Identifiable {
  case sineWave
  
  var id: Self { self }
  
  var title: String {
    switch self {
    case .sineWave: "Sine Wave"
    }
  }
  
  @ViewBuilder
  var destination: some View {
    switch self {
    case .sineWave: SineWaveView()
    }
  }
}
