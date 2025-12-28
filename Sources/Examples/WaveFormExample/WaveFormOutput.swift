//
//  WaveFormPlayer.swift
//  AudioGraphs
//
//  Created by Naren on 27/12/25.
//

import Foundation

protocol WaveFormPlayer: AnyObject {
  func getWaveFormSample(amplitudes: [Float])
}
