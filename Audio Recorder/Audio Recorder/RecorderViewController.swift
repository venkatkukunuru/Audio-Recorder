//
//  RecorderViewController.swift
//  Audio Recorder
//
//  Created by Venkat Kukunuru on 01/01/17.
//  Copyright © 2017 Venkat Kukunuru. All rights reserved.
//

import Foundation
import UIKit

protocol RecorderViewDelegate : class {
    func didFinishRecording(_ recorderViewController: RecorderViewController)
}

class RecorderViewController: UIViewController , RecorderDelegate {
    open weak var delegate: RecorderViewDelegate?
    var recording: Recording!
    var recordDuration = 0

    @IBOutlet weak var tapToFinishBtn: UIButton!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var voiceRecordHUD: VoiceRecordHUD!

    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createRecorder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        voiceRecordHUD.update(0.0)
        voiceRecordHUD.fillColor = UIColor.green
        durationLabel.text = ""

    }
    
    open func createRecorder() {
        recording = Recording(to: "recording.m4a")
        recording.delegate = self
        
        // Optionally, you can prepare the recording in the background to
        // make it start recording faster when you hit `record()`.
        
        DispatchQueue.global().async {
            // Background thread
            do {
                try self.recording.prepare()
            } catch {
                print(error)
            }
        }
    }

    open func startRecording() {
        recordDuration = 0
        do {
            try recording.record()
        } catch {
            print(error)
        }
    }

    @IBAction func stop() {
        
        delegate?.didFinishRecording(self)
        dismiss(animated: true, completion: nil)
        
        recordDuration = 0
        recording.stop()
        voiceRecordHUD.update(0.0)
        
    }
    
    func audioMeterDidUpdate(_ db: Float) {
        print("db level: %f", db)
        
        self.recording.recorder?.updateMeters()
        let ALPHA = 0.05
        let peakPower = pow(10, (ALPHA * Double((self.recording.recorder?.peakPower(forChannel: 0))!)))
        var rate: Double = 0.0
        if (peakPower <= 0.2) {
            rate = 0.2
        } else if (peakPower > 0.9) {
            rate = 1.0
        } else {
            rate = peakPower
        }
        
        voiceRecordHUD.update(CGFloat(rate))
        voiceRecordHUD.fillColor = UIColor.green
        recordDuration += 1
        durationLabel.text = String(recordDuration)
    }

}
