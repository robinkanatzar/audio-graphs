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
        
        for (index, amp) in viewModel.amplitudes.enumerated() {
          let height = size.height * CGFloat(amp)
          let rect = CGRect(
            x: CGFloat(index) * barWidth,
            y: size.height - height,
            width: barWidth,
            height: height
          )
          context.fill(Path(rect), with: .color(.blue))
        }
      }
      .frame(height: 150)
    }
    .onAppear {
      viewModel.startPlayer()
    }
    .onDisappear {
      viewModel.stopPlayer()
    }
  }
}

#Preview {
  WaveFormView()
}
