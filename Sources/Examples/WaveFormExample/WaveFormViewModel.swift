//
//  WaveFormViewModel.swift
//  AudioGraphs
//
//  Created by Naren on 17/12/25.
//
import Foundation

@MainActor
final class WaveFormViewModel: ObservableObject, WaveFormOutput {
  
  @Published private(set) var amplitudes: [Float] = []
  let sineWavePlayer: AVSineWavePlayer?
  
  init(_ player: AVSineWavePlayer = AVSineWavePlayer(enableModulation: true)) {
    self.sineWavePlayer = player
  }
  
  nonisolated func didReceiveWaveform(_ amplitudeValues: [Float]) {
    Task { @MainActor in
      self.amplitudes = amplitudeValues
    }
  }
  
  func startPlayer() {
    sineWavePlayer?.lfoFrequency = 3.0
    sineWavePlayer?.lfoDepth = 0.5
    sineWavePlayer?.waveformOutput = self
    sineWavePlayer?.start()
  }
  
  func stopPlayer() {
    sineWavePlayer?.stop()
  }
}
