//
//  AudioFeedbackPlayer.swift
//  AudioGraphs
//
//  Created by Naren on 07/12/25.
//

import Foundation

protocol AudioFeedbackPlayer: AnyObject {
  func playFrequencyFeedback(_ frequency: Double)
  func playAmplitudeFeedback(_ amplitude: Double)
}
