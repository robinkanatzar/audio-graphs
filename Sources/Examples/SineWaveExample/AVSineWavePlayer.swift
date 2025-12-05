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
