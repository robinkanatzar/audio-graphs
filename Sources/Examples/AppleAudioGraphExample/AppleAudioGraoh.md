# Apple Audio Graph Example – Behaviour Specification

## Feature Overview
The Apple Audio Graph example demonstrates iOS's built-in accessibility feature for making charts accessible to VoiceOver users.  
Users can interact with a visual chart and experience its audio representation through VoiceOver's audio graph feature.

---

## User Goals
- Understand how Apple's `AXChartDescriptor` API works
- Experience how VoiceOver converts visual data into sound
- Learn the relationship between chart data and audio representation
- Explore iOS's standard approach to accessible data visualization

---

## Scenarios

### Scenario 1 – Display Accessible Chart
**Given** the user is on the Apple Audio Graph Example screen  
**When** the screen loads  
**Then** a visual bar chart should be displayed showing sample data  
**And** the chart should be properly configured with accessibility descriptors  
**And** instructions for VoiceOver usage should be visible  

---

### Scenario 2 – VoiceOver Audio Graph Playback
**Given** VoiceOver is enabled  
**And** the user is on the Apple Audio Graph Example screen  
**When** the user focuses on the chart  
**And** performs the audio graph gesture (two-finger swipe up)  
**Then** VoiceOver should play the audio representation of the chart data  
**And** higher data values should produce higher pitched tones  
**And** the audio should play sequentially through each data point  

---

### Scenario 3 – Chart Data Description
**Given** VoiceOver is enabled  
**When** the user focuses on the chart  
**Then** VoiceOver should announce the chart title  
**And** VoiceOver should provide a summary of the data  
**And** axis information should be available through exploration  

---

### Scenario 4 – Interactive Data Point Exploration
**Given** VoiceOver is enabled  
**And** the audio graph is active  
**When** the user scrubs through the audio graph  
**Then** VoiceOver should announce individual data point values  
**And** the corresponding visual element should be highlighted  
**And** the tone should change to match the data value  

---

### Scenario 5 – Chart Without VoiceOver
**Given** VoiceOver is disabled  
**When** the user views the chart  
**Then** the visual chart should display normally  
**And** standard chart interactions should work  
**And** no audio feedback should occur  
**And** instructions should indicate VoiceOver is required for audio features  

---

## Constraints
- Must use iOS 15+ `AXChartDescriptor` API
- Chart data must be representable as numeric or categorical axes
- Audio representation is controlled by VoiceOver, not the app
- The implementation must follow Apple's accessibility guidelines
- Visual chart must remain fully functional without VoiceOver
- Data must be structured to support both visual and audio representation

---

## Accessibility Requirements
- Chart must implement `AXChartDescriptorRepresentable` protocol
- X-axis and Y-axis must be properly described
- Data series must include descriptive labels
- Chart summary must provide context
- Individual data points must be explorable

---

## Data Requirements
- Sample data should be simple and easy to understand audibly
- Data range should produce distinguishable pitch differences
- Minimum of 5-10 data points for meaningful sonification
- Data should tell a clear story (e.g., sales over time, temperature trends)

---

## Notes
This document describes **behaviour**, not implementation.  
Implementation will follow in incremental PRs.

The audio playback is handled entirely by VoiceOver - the app provides the data structure and accessibility descriptors, but does not generate audio directly.

This example focuses on Apple's standard approach. Custom sonification will be explored in separate examples.