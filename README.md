# Audio-Recorder

The sample is build with swift 3.0

To integrate Audio Recorder into your project 

Drag the following files

1. RecorderViewController.swift
2. Recording.swift
3. VoiceRecordHUD.swift

use the RecorderViewController scene in your storyboard and create an instance in your viewcontroller and use the below to Start voice recording

self.present(recorderView, animated: true, completion: nil)
recorderView.startRecording()


to play the recorded voice use

do {
    try recorderView.recording.play()
} catch {
    print(error)
}

