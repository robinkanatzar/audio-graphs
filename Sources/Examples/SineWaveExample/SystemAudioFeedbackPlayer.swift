//
//  SystemAudioFeedbackPlayer.swift
//  AudioGraphs
//
//  Created by Naren on 07/12/25.
//

import Foundation
import AVFoundation

class SystemAudioFeedbackPlayer: AudioFeedbackPlayer {
  
  // MARK: - Private Types & Constants
  
  /// Audio constants used for feedback tone behaviour.
  private enum Constants {
    /// Length of each feedback tone, in seconds.
    static let toneDuration: Double = 0.15
    
    /// Frequency used for amplitude feedback tones.
    static let amplitudeToneFrequency: Double = 600
    
    /// Default amplitude for frequency feedback tones.
    static let feedbackAmplitude: Double = 0.25
  }
  
  private let engine = AVAudioEngine()
  private let player = AVAudioPlayerNode()
  private var format: AVAudioFormat
  
  // MARK: - Initialization
  
  /// Creates a new audio feedback engine and prepares it for playback.
  ///
  /// The engine starts immediately, but the player only plays when needed.
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
  
  // MARK: - Public API (AudioFeedbackPlayer)
  
  /// Plays a short tone whose pitch reflects the given frequency.
  ///
  /// - Parameter frequency: Hertz value to sonify.
  ///   Values are safely clamped to 220–880 Hz.
  func playFrequencyFeedback(_ frequency: Double) {
    let clamped = max(220, min(880, frequency))
    
    guard let buffer = makeFeedbackTone(
      frequency: clamped,
      amplitude: Constants.feedbackAmplitude
    ) else {
      return
    }
    player.playIfNeeded()
    player.scheduleBuffer(buffer, at: nil, options: .interrupts, completionHandler: nil)
  }
  
  // Plays a short tone whose loudness reflects amplitude changes.
  ///
  /// - Parameter amplitude: Slider value (0.0–1.0).
  ///   Mapped to a perceptible 0.1–0.5 audio amplitude.
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
  
  // MARK: - Tone Generation
  
  /// Creates a short PCM buffer containing a sine wave tone.
  /// Feedback tones are only triggered when the main sine-wave generator is not running.
  /// This prevents audio overlap and keeps the soundscape clean.
  ///
  /// - Parameters:
  ///   - frequency: Tone frequency in Hz.
  ///   - amplitude: Output amplitude (0.0–1.0).
  ///
  /// - Returns: A PCM buffer ready for playback, or `nil` if allocation failed.
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

/// Convenience helper that ensures the audio player starts if needed.
private extension AVAudioPlayerNode {
  func playIfNeeded() {
    if !isPlaying {
      play()
    }
  }
}
