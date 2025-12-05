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
  
  /// Configures the audio graph used to generate a continuous sine wave.
  ///
  /// The graph consists of:
  /// - `AVAudioEngine` as the main processing graph
  /// - `AVAudioSourceNode` which supplies PCM samples in real time
  ///
  /// How it works:
  /// - The engine repeatedly calls the source node’s render block,
  ///   requesting `frameCount` audio samples.
  /// - For each frame, we compute:
  ///       sample = sin(phase) * amplitude
  /// - `phase` is advanced based on the desired frequency:
  ///       phase += (2π * frequency) / sampleRate
  /// - When the engine is running, these samples are streamed to the
  ///   output, producing a smooth sine wave.
  ///
  /// Important:
  /// - This callback must be real-time safe (no allocations, no locks).
  /// - Audio is mono (1 channel) and uses Float32 PCM samples.
  /// - `phase` wraps at 2π to avoid overflow.
  private func configureGraph() {
    let audioFormat = AVAudioFormat(
      commonFormat: .pcmFormatFloat32,
      sampleRate: sampleRate,
      channels: 1,
      interleaved: false)
    
    let node = AVAudioSourceNode { _ , _, frameCount, audioBufferList -> OSStatus in
      let audioBufferListPointer = UnsafeMutableAudioBufferListPointer(audioBufferList)
      
      for buffer in audioBufferListPointer {
        let data = UnsafeMutableBufferPointer<Float>(buffer)
        
        for frame in 0..<Int(frameCount) {
          let sample = sin(self.phase) * self.amplitude
          data[frame] = Float(sample)
          
          self.phase += (2 * .pi * self.frequency) / self.sampleRate
          if self.phase >= 2 * .pi { self.phase -= 2 * .pi}
        }
      }
      return noErr
    }
    
    engine.attach(node)
    engine.connect(node, to: engine.mainMixerNode, format: audioFormat)
    self.sourceNode = node
    engine.prepare()
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
