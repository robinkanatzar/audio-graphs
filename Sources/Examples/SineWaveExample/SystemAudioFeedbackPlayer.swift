//
//  SystemAudioFeedbackPlayer.swift
//  AudioGraphs
//
//  Created by Naren on 07/12/25.
//

import Foundation
import AVFoundation

class SystemAudioFeedbackPlayer: AudioFeedbackPlayer {
  private let engine = AVAudioEngine()
  private let player = AVAudioPlayerNode()
  private var format: AVAudioFormat
  var targetFrequency: Double = 440
  
  private enum Constants {
    static let toneDuration: Double = 0.15
    static let amplitudeToneFrequency: Double = 600
    static let feedbackAmplitude: Double = 0.25
  }
  
  init() {
    let session = AVAudioSession.sharedInstance()
    try? session.setCategory(.playback, mode: .default, options: [])
    try? session.setActive(true)
    
    let mixerFormat = engine.mainMixerNode.outputFormat(forBus: 0)
    self.format = AVAudioFormat(
      commonFormat: .pcmFormatFloat32,
      sampleRate: mixerFormat.sampleRate,
      channels: 1, interleaved: false)!
    
    engine.attach(player)
    engine.connect(player, to: engine.mainMixerNode, format: self.format)
    try? engine.start()
  }
  
  func playFrequencyFeedback(_ frequency: Double) {    
    let clamped = max(220, min(2000, frequency))
    
    guard let buffer = makeFeedbackTone(
      frequency: clamped,
      amplitude: Constants.feedbackAmplitude
    ) else {
      return
    }
    player.playIfNeeded()
    player.scheduleBuffer(buffer, at: nil, options: .interrupts, completionHandler: nil)
  }
  
  func playAmplitudeFeedback(_ amplitude: Double) {
    // Clamp 0...1 and map to a subtle 0.1...0.5 amplitude
    let clamped = max(0.0, min(1.0, amplitude))
    let mappedAmplitude = 0.1 + 0.4 * clamped
    
    guard let buffer = makeFeedbackTone(
      frequency: Constants.amplitudeToneFrequency,
      amplitude: mappedAmplitude
    ) else {
      return
    }
    player.playIfNeeded()
    player.scheduleBuffer(buffer, at: nil, options: .interrupts, completionHandler: nil)
  }
  
  private func makeFeedbackTone(frequency: Double, amplitude: Double) -> AVAudioPCMBuffer? {
    let sampleRate = format.sampleRate
    let frameCount = AVAudioFrameCount(sampleRate * Constants.toneDuration)
    
    guard let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCount) else {
      return nil
    }
    buffer.frameLength = frameCount
    
    let channelData = buffer.floatChannelData?[0]
    var phase: Double = 0
    let phaseStep = (2.0 * .pi * frequency) / sampleRate
    
    for frame in 0..<Int(frameCount) {
      channelData?[frame] = Float(sin(phase) * amplitude)
      phase += phaseStep
    }
    
    return buffer
  }
}

private extension AVAudioPlayerNode {
  func playIfNeeded() {
    if !isPlaying {
      play()
    }
  }
}
