//
//  WaveformSource.swift
//  AudioGraphs
//
//  Created by Naren on 27/12/25.
//

@MainActor
protocol WaveformSource: AnyObject {
  var waveformOutput: WaveFormOutput? { get set }
}
