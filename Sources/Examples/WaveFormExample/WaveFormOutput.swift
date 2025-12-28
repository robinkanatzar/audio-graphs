//
//  WaveFormOutput.swift
//  AudioGraphs
//
//  Created by Naren on 27/12/25.
//

import Foundation

protocol WaveFormOutput: AnyObject {
  func didReceiveWaveform(_ amplitudeValues: [Float])
}
