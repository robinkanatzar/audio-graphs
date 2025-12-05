//
//  SineWaveViewModel.swift
//  AudioGraphs
//
//  Created by Naren on 02/12/25.
//

import Foundation

final class SineWaveViewModel: ObservableObject {
  private var isInitializing = true
  @Published var isPlaying: Bool {
    didSet {
      guard !isInitializing else { return }
      isPlaying ? player.start() : player.stop()
    }
  }
  @Published var frequency: Double {
    didSet {
      guard !isInitializing else { return }
      player.frequency = frequency
    }
  }
  @Published var amplitude: Double {
    didSet {
      guard !isInitializing else { return }
      player.amplitude = amplitude
    }
  }
  private let player: SineWavePlayer
  let frequencyRange: ClosedRange<Double> = 220...880
  let amplitudeRange: ClosedRange<Double> = 0...1
  
  init(player: SineWavePlayer) {
    self.player = player
    self.isPlaying = player.isPlaying
    self.frequency = player.frequency
    self.amplitude = player.amplitude
    self.isInitializing = false
  }
}
