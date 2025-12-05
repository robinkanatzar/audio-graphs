//
//  SineWavePlayer.swift
//  AudioGraphs
//
//  Created by Naren on 05/12/25.
//

import Foundation

/// Abstraction for a sine-wave audio player.
///
/// This allows the UI/ViewModel to depend on a protocol instead of AVFoundation,
/// making it easier to test and to swap implementations later.
protocol SineWavePlayer: AnyObject {
  var isPlaying: Bool { get }
  var frequency: Double { get set }
  var amplitude: Double { get set }
  
  func start()
  func stop()
}
