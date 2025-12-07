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
      
      guard !isPlaying else { return }
      feedbackPlayer?.playFrequencyFeedback(frequency)
    }
  }
  @Published var amplitude: Double {
    didSet {
      guard !isInitializing else { return }
      player.amplitude = amplitude
      
      guard !isPlaying else { return }
      feedbackPlayer?.playAmplitudeFeedback(amplitude)
    }
  }
  private let player: SineWavePlayer
  let frequencyRange: ClosedRange<Double> = 220...880
  let amplitudeRange: ClosedRange<Double> = 0...1
  
  private let feedbackPlayer: AudioFeedbackPlayer?
  
  init(player: SineWavePlayer, feedbackPlayer: AudioFeedbackPlayer? = nil) {
    self.player = player
    self.feedbackPlayer = feedbackPlayer
    self.isPlaying = player.isPlaying
    self.frequency = player.frequency
    self.amplitude = player.amplitude
    self.isInitializing = false
  }
}
