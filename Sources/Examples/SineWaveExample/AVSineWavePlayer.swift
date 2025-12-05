//
//  AVSineWavePlayer.swift
//  AudioGraphs
//
//  Created by Naren on 05/12/25.
//

import Foundation
import AVFoundation

class AVSineWavePlayer: SineWavePlayer {
  private var engine = AVAudioEngine()
  private var sourceNode: AVAudioSourceNode?
  private var phase: Double = 0.0
  private var sampleRate: Double = 0.0
  
  // MARK: - Public API (SineWavePlayer)
  var isPlaying: Bool {
    engine.isRunning
  }
  var frequency: Double = 440
  var amplitude: Double = 0.5
  
  init() {
    self.sampleRate = engine.mainMixerNode.outputFormat(forBus: 0).sampleRate
    configureGraph()
  }
  
  private func configureGraph() {
    
  }
  
  func start() {
    guard !engine.isRunning else { return }
    do {
      try engine.start()
    } catch {
      print("Error starting engine: \(error)")
    }
  }
  
  func stop() {
    engine.stop()
  }
}
