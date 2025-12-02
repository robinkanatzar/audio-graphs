//
//  ContentView.swift
//  AudioGraphs
//
//  Created by Naren on 01/12/25.
//

import SwiftUI

struct ContentView: View {
  var body: some View {
    NavigationStack {
      List(ExampleRoute.allCases) { route in
        NavigationLink(route.title) {
          route.destination
        }
      }
      .navigationTitle("Audio Graph Examples")
    }
  }
}

#Preview {
  ContentView()
}
