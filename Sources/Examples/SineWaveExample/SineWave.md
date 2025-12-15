# Sine Wave Example – Behaviour Specification

## Feature Overview
The Sine Wave example demonstrates how to generate a continuous audio tone using Apple's Audio Graph framework.  
The user can start, stop, and control the properties of the generated sine wave.

---

## User Goals
- Understand how a basic audio graph is constructed.
- Hear a generated tone whose frequency and amplitude can be adjusted.
- Explore audio accessibility concepts through simple sonification.

---

## Scenarios

### Scenario 1 – Start and Stop Tone
**Given** the user is on the Sine Wave Example screen  
**When** the user enables the “Play” toggle  
**Then** the sine wave tone should begin playing  
**And** the UI should reflect the updated state  

**When** the user disables the “Play” toggle  
**Then** the tone should stop  
**And** audio resources should be released safely  

---

### Scenario 2 – Adjust Frequency
**Given** the tone is playing  
**When** the user moves the “Frequency” slider  
**Then** the generated sine wave should immediately adjust to the new frequency  
**And** the UI should display the updated value in Hertz  

---

### Scenario 3 – Adjust Amplitude
**Given** the tone is playing  
**When** the user adjusts the amplitude slider  
**Then** the output volume of the sine wave should reflect the new amplitude  
**And** values should remain in the safe 0.0 – 1.0 range  

---

### Scenario 4 – Lifecycle & Navigation Handling

**Given** the sine wave is playing
**When** the app moves to the background
**Then** audio playback should stop safely
**And** when the user navigates away from the Sine Wave screen
**Then** the audio engine should stop
**And** audio resources should be released


## Constraints
- The UI must not block audio rendering.
- Rendering must occur in a real-time safe callback.
- The View must not contain audio logic.
- The ViewModel must not block the main thread.
- The Audio Engine must be isolated for testability.

---

## Notes
This document describes **behaviour**, not implementation.
Implementation will follow in incremental PRs.
