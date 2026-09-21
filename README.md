# Messenger Hemanth iOS
A native iOS messaging application built with Swift and SwiftUI that integrates directly with a locally hosted Gemma 4 model via Ollama following MVVM architecture, complete with unit tests for the ViewModel.

## Pre-requisites
- Xcode:  Download Xcode directly by searching "Xcode" in Mac App Store, click Get, and the download will start immediately.
- iOS simulator: Open *Xcode -> Settings -> Components* and Get your preferred simulator platform
- gemma4: Download and install [Ollama](https://ollama.com/download/mac) on your Mac
  - Pull gemma4: `ollama pull gemma4` (approximately 9.6GB)

## Run Instructions
- Clone this repository.
- `cd messenger_hemanth_ios/`  into the repository directory in your terminal.
- Open the project in Xcode by running `open messenger.xcodeproj`.
- Select your preferred iOS simulator from the top scheme toolbar in Xcode.
- Press `Cmd + R` (or click the Play button in the top-left corner) to build and run the application.


### Test Instructions
- To run the tests in xcode, press `Cmd + u` to run all the tests.
