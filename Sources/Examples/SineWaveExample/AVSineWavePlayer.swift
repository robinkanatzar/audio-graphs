//
//  AVSineWavePlayer.swift
//  AudioGraphs
//
//  Created by Naren on 05/12/25.
//

import Foundation
import AVFoundation

class AVSineWavePlayer: SineWavePlayer {
  var engine = AVAudioEngine()
  private var sourceNode: AVAudioSourceNode?
  private var phase: Double = 0.0
  private var lfoPhase: Double = 0.0
  private var sampleRate: Double = 0.0
  var waveformOutput: WaveFormOutput?
  
  // MARK: - Public API (SineWavePlayer)
  var isPlaying: Bool {
    engine.isRunning
  }
  var frequency: Double = 440
  var amplitude: Double = 0.5
  
  var enableModulation: Bool = false
  var lfoFrequency: Double = 2.0
  var lfoDepth: Double = 0.3
  
  init(enableModulation: Bool = false) {
    self.enableModulation = enableModulation
    self.sampleRate = engine.mainMixerNode.outputFormat(forBus: 0).sampleRate
    configureGraph()
    installWaveformTap()
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
          var finalAmplitude = self.amplitude
          
          if self.enableModulation {
            let ampMod = (sin(self.lfoPhase) + 1.0) / 2.0
            finalAmplitude = self.amplitude * (1.0 - self.lfoDepth + (ampMod * self.lfoDepth))
            
            self.lfoPhase += (2 * .pi * self.lfoFrequency) / self.sampleRate
            if self.lfoPhase >= 2 * .pi { self.lfoPhase -= 2 * .pi }
          }
          let sample = sin(self.phase) * finalAmplitude
          data[frame] = Float(sample)
          
          self.phase += (2 * .pi * self.frequency) / self.sampleRate
          if self.phase >= 2 * .pi { self.phase -= 2 * .pi }
        }
      }
      return noErr
    }
    
    engine.attach(node)
    engine.connect(node, to: engine.mainMixerNode, format: audioFormat)
    self.sourceNode = node
    engine.prepare()
  }
  
  private func installWaveformTap() {
    guard enableModulation else { return }
    
    let mixer = engine.mainMixerNode
    let bus: AVAudioNodeBus = 0
    let format = mixer.outputFormat(forBus: bus)
    
    mixer.installTap(
      onBus: bus,
      bufferSize: 512,
      format: format
    ) { [weak self] buffer, _ in
      guard let channelData = buffer.floatChannelData?[0]
      else { return }
      
      let frameCount = Int(buffer.frameLength)
      guard frameCount > 0 else { return }
      var samples = [Float](repeating: 0, count: frameCount)
      for i in 0..<frameCount {
        samples[i] = abs(channelData[i])
      }
      
      let maxValue = samples.max() ?? 1
      let normalized = samples.map { $0 / max(maxValue, 0.0001) }
      
      self?.waveformOutput?.didReceiveWaveform(normalized)
    }
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
