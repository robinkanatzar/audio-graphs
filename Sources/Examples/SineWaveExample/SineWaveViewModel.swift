//
//  SineWaveViewModel.swift
//  AudioGraphs
//
//  Created by Naren on 02/12/25.
//

import Foundation

final class SineWaveViewModel: ObservableObject {
  @Published var isPlaying: Bool
  @Published var frequency: Double
  @Published var amplitude: Double
  private let player: SineWavePlayer
  let frequencyRange: ClosedRange<Double> = 220...880
  let amplitudeRange: ClosedRange<Double> = 0...1
  
  init(player: SineWavePlayer) {
    self.player = player
    self.isPlaying = player.isPlaying
    self.frequency = player.frequency
    self.amplitude = player.amplitude
  }
}
