//
//  SineWaveView.swift
//  AudioGraphs
//
//  Created by Naren on 02/12/25.
//

import SwiftUI

/// A simple example view demonstrating adjustable sine-wave controls.
///
/// This view exposes:
/// - Playback toggle
/// - Frequency slider
/// - Amplitude slider
///
/// It is intended as a basic example for exploring Audio Graph–based
/// sonification and accessibility behaviours.
struct SineWaveView: View {
  @StateObject private var viewModel = SineWaveViewModel(player: AVSineWavePlayer())
  
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
  /// Displays the playback toggle section.
  ///
  /// VoiceOver reads:
  /// - "Playback toggle"
  /// - Current status ("Playing" / "Stopped")
  ///
  /// The dynamic status text is hidden from accessibility because the toggle
  /// already provides an equivalent accessibility value.
    var playbackSection: some View {
      VStack(alignment: .leading, spacing: Layout.innerSpacing) {
        Text("Playback")
          .font(.headline)
          .accessibilityHidden(true)
        
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
  
  /// Reusable slider section used for frequency and amplitude controls.
  ///
  /// - Parameters:
  ///   - title: The section title shown visually and used as an accessibility label.
  ///   - value: A binding to the numeric value controlled by the slider.
  ///   - range: Allowed range for the slider.
  ///   - format: Closure that converts the numeric value into a display string.
  ///
  /// VoiceOver:
  /// - Announces the title
  /// - Announces the formatted value
  /// - Supports adjustable actions (swipe up/down)
  ///
  /// The value text is hidden from accessibility because the slider
  /// already exposes its accessibility value.
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
          .accessibilityHidden(true)
        
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
  
  /// Internal layout constants used for spacing.
  /// Keeping spacing centralized makes the view easier to update or
  /// adapt for dynamic type or accessibility in the future.
  private enum Layout {
    static let sectionSpacing: CGFloat = 32
    static let innerSpacing: CGFloat = 12
  }
  
  #Preview {
    SineWaveView()
  }
