//
//  AppleAudioGraphView.swift
//  AudioGraphs
//
//  Created by Naren on 28/12/25.
//

import SwiftUI
import Charts
import Accessibility

/// Demonstrates Apple's built-in Audio Graph accessibility feature.
///
/// This example shows how to make charts accessible to VoiceOver users by implementing
/// the AXChartDescriptor API
struct AppleAudioGraphView: View {
  let salesData = [
    (month: "Jan", sales: 120),
    (month: "Feb", sales: 150),
    (month: "Mar", sales: 200),
    (month: "Apr", sales: 210),
    (month: "May", sales: 120),
    (month: "Jun", sales: 130),
    (month: "Jul", sales: 100),
    (month: "Aug", sales: 160),
    (month: "Sep", sales: 50)
  ]
  var body: some View {
    VStack(spacing: 20) {
      Text("Monthly Sales Chart")
        .font(.title2)
      
      Text("Enable VoiceOver and double-tap the chart to hear the audio graph")
        .font(.caption)
        .foregroundColor(.secondary)
        .multilineTextAlignment(.center)
        .padding()
      
      Chart(salesData, id: \.month) { item in
        BarMark(
          x: .value("Month", item.month),
          y: .value("Sales", item.sales)
        )
      }
      .frame(height: 200)
      .accessibilityChartDescriptor(self)
      .accessibilityElement(children: .contain)
      Spacer()
    }
    .padding()
    .navigationTitle("Apple Audio Graph")
  }
}

#Preview {
  AppleAudioGraphView()
}

// MARK: - Chart Descriptor

extension AppleAudioGraphView: AXChartDescriptorRepresentable {
  /// Creates the accessibility descriptor that VoiceOver uses to generate audio graphs.
  ///
  /// This method defines how the chart data should be sonified for VoiceOver users.
  /// When a user with VoiceOver enabled interacts with the chart on a physical device,
  /// iOS converts the data values into audio tones where:
  /// - Higher sales values produce higher pitched beeps
  /// - Lower sales values produce lower pitched beeps
  /// - Each data point plays sequentially as the user navigates through months
  ///
  /// The descriptor includes:
  /// - X-axis: Categorical axis with month names
  /// - Y-axis: Numeric axis with sales value range
  /// - Data points: Individual sales values with descriptive labels
  /// - Metadata: Chart title and summary for context
  ///
  ///
  /// - Returns: An `AXChartDescriptor` containing all accessibility information for the chart.
  nonisolated func makeChartDescriptor() -> AXChartDescriptor {
    
    // Configure the X-axis with month categories
    let xAxis = AXCategoricalDataAxisDescriptor(
      title: "Month",
      categoryOrder: salesData.map { $0.month }
    )
    
    // Configure the Y-axis with the range of sales values
    let min = Double(salesData.map({$0.sales}).min() ?? 0)
    let max = Double(salesData.map({$0.sales}).max() ?? 0)
    let yAxis = AXNumericDataAxisDescriptor(
      title: "Sales",
      range: min...max,
      gridlinePositions: []) { value in
        "\(value) units"
      }
    
    // Create data points with accessible labels for each month's sales
    let dataPoints = salesData.map { item in
      AXDataPoint(
        x: item.month,
        y: Double(item.sales),
        label: "\(item.sales) units sold in \(item.month)"
      )
    }
    // Define the data series that groups all data points together
    let series = AXDataSeriesDescriptor(name: "Monthly Sales",
                                        isContinuous: false,
                                        dataPoints: dataPoints)
    
    // Return the complete chart descriptor with all accessibility information
    return AXChartDescriptor(title: "Monthly Sales Chart",
                             summary: "Bar chart showing monthly sales from January to September",
                             xAxis: xAxis,
                             yAxis: yAxis,
                             series: [series])
  }
}
