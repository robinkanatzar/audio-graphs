//
//  SineWaveView.swift
//  AudioGraphs
//
//  Created by Naren on 02/12/25.
//

import SwiftUI

struct SineWaveView: View {
  @StateObject private var viewModel = SineWaveViewModel()
  
  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: Layout.sectionSpacing) {
        
        playbackSection
        
        sliderSection(
          "Frequency",
          value: $viewModel.frequency,
          range: viewModel.frequencyRange,
          format: { "\(Int($0)) Hz" }
        )
        
        sliderSection(
          "Amplitude",
          value: $viewModel.amplitude,
          range: viewModel.amplitudeRange,
          format: { String(format: "%.2f", $0) }
        )
      }
      .padding()
    }
  }
  
  // MARK: - Subviews
  var playbackSection: some View {
    VStack(alignment: .leading, spacing: Layout.innerSpacing) {
      Text("Playback")
        .font(.headline)
      
      Toggle(isOn: $viewModel.isPlaying) {
        Text(viewModel.isPlaying ? "Playing" : "Stopped")
          .accessibilityHidden(true)
      }
      .accessibilityLabel("Playback toggle")
      .accessibilityValue(viewModel.isPlaying ? "Playing" : "Stopped")
    }
  }
}

// MARK: - Slider Section
extension SineWaveView {
  @ViewBuilder
  func sliderSection(
    _ title: String,
    value: Binding<Double>,
    range: ClosedRange<Double>,
    format: @escaping (Double) -> String
  ) -> some View {
    
    VStack(alignment: .leading, spacing: Layout.innerSpacing) {
      Text(title)
        .font(.headline)
      
      Slider(value: value, in: range)
        .accessibilityLabel(title)
        .accessibilityValue(format(value.wrappedValue))
        .accessibilityAdjustableAction { adjustmentDirection in
          let step = (range.upperBound - range.lowerBound)/20
          switch adjustmentDirection {
          case .increment:
            value.wrappedValue = min(value.wrappedValue + step, range.upperBound)
          case .decrement:
            value.wrappedValue = max(value.wrappedValue - step, range.lowerBound)
          default: break
          }
        }
      
      Text(format(value.wrappedValue))
        .font(.caption)
        .foregroundColor(.secondary)
        .accessibilityHidden(true)
    }
  }
}

private enum Layout {
  static let sectionSpacing: CGFloat = 32
  static let innerSpacing: CGFloat = 12
}

#Preview {
  SineWaveView()
}
