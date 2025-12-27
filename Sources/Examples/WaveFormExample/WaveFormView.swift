//
//  WaveFormView.swift
//  AudioGraphs
//
//  Created by Naren on 17/12/25.
//

import SwiftUI

struct WaveFormView: View {
  @StateObject private var viewModel = WaveFormViewModel()
  
  var body: some View {
    VStack {
      Canvas { context, size in
        guard !viewModel.amplitudes.isEmpty else { return }
        
        let barWidth = size.width / CGFloat(viewModel.amplitudes.count)
        
        for (index, amplitude) in viewModel.amplitudes.enumerated() {
          let height = size.height * CGFloat(amplitude)
          let x = CGFloat(index) * barWidth
          let y = size.height - height
          
          let rect = CGRect(x: x, y: y, width: barWidth, height: height)
          context.fill(Path(rect), with: .color(.blue))
        }
      }
      .frame(height: 150)
      .onAppear {
        viewModel.generateSampleData()
      }
      .accessibilityElement(children: .ignore)
      .accessibilityLabel("Waveform visualization")
      .accessibilityHint("Represents the audio signal over time")
    }
    .padding()
  }
}

#Preview {
  WaveFormView()
}
