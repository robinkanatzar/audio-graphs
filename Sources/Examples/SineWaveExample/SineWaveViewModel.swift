//
//  SineWaveViewModel.swift
//  AudioGraphs
//
//  Created by Naren on 02/12/25.
//

import Foundation

final class SineWaveViewModel: ObservableObject {
  @Published var isPlaying = false
  @Published var frequency: Double = 440
  @Published var amplitude: Double = 0.5
  let frequencyRange: ClosedRange<Double> = 220...880
  let amplitudeRange: ClosedRange<Double> = 0...1
  
}
