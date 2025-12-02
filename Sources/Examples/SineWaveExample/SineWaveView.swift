//
//  SineWaveView.swift
//  AudioGraphs
//
//  Created by Naren on 02/12/25.
//

import SwiftUI

struct SineWaveView: View {
  @StateObject private var viewModel = SineWaveViewModel()
  
  var body: some View {
    Form {
      Section(header: Text("Playback")) {
        Toggle(isOn: $viewModel.isPlaying) {
          Text(viewModel.isPlaying ? "Playing" : "Stopped")
        }
      }
    }
  }
}

#Preview {
  SineWaveView()
}
