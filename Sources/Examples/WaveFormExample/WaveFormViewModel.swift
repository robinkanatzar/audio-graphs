//
//  WaveFormViewModel.swift
//  AudioGraphs
//
//  Created by Naren on 17/12/25.
//
import Foundation

final class WaveFormViewModel: ObservableObject {
  let amplitudeRange: ClosedRange<Double> = 0.0...1.0
  
  @Published private(set) var amplitudes: [Float] = []
  
  func generateSampleData() {
    amplitudes = (0..<200).map { index in
      let phase = Double(index) / 200.0
      let sineValue = sin(phase * 2 * .pi)
      let normalized = (sineValue + 1) / 2
      return Float(normalized)
    }
  }
}
