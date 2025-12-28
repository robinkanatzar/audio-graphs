//
//  AppleAudioGraphView.swift
//  AudioGraphs
//
//  Created by Naren on 28/12/25.
//

import SwiftUI
import Charts
import Accessibility

struct AppleAudioGraphView: View {
  let salesData = [
    (month: "Jan", sales: 120),
    (month: "Feb", sales: 150),
    (month: "March", sales: 200),
    (month: "April", sales: 210),
    (month: "May", sales: 120),
    (month: "Jun", sales: 130),
    (month: "Jul", sales: 100),
    (month: "Aug", sales: 160),
    (month: "Sept", sales: 190)
  ]
  var body: some View {
    VStack(spacing: 20) {
      Text("Monthly Sales Chart")
        .font(.title2)
      
      Text("Enable VoiceOver and double-tap the chart to hear the audio graph")
        .font(.caption)
        .foregroundColor(.secondary)
        .multilineTextAlignment(.center)
        .padding()
      
      Chart(salesData, id: \.month) { item in
        BarMark(
          x: .value("Month", item.month),
          y: .value("Sales", item.sales)
        )
      }
      .frame(height: 200)
    }
  }
}

#Preview {
  AppleAudioGraphView()
}
