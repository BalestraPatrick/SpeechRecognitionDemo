//
//  ViewController.swift
//  SpeechRecognitionDemo
//
//  Created by Patrick Balestra on 1/6/17.
//  Copyright © 2017 Patrick Balestra. All rights reserved.
//

import UIKit
import Speech

class ViewController: UIViewController {

    @IBOutlet weak var microphoneButton: UIButton!
    @IBOutlet weak var flightTextView: UITextView!
    @IBOutlet weak var tableView: UITableView!

    var status = SpeechStatus.ready {
        didSet {
            self.setUI(status: status)
        }
    }

    let audioEngine = AVAudioEngine()
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?

    override func viewDidLoad() {
        super.viewDidLoad()
        applyStyle()

        switch SFSpeechRecognizer.authorizationStatus() {
        case .notDetermined:
            askSpeechPermission()
        case .authorized:
            self.status = .ready
        case .denied, .restricted:
            self.status = .unavailable
        }

    }

    /// Ask permission to the user to access their speech data.
    func askSpeechPermission() {
        SFSpeechRecognizer.requestAuthorization { status in
            OperationQueue.main.addOperation {
                switch status {
                case .authorized:
                    self.status = .ready
                default:
                    self.status = .unavailable
                }
            }
        }
    }

    /// Start streaming the microphone data to the speech recognizer to recognize it live.
    func startRecording() {
        // Setup audio engine and speech recognizer
        guard let node = audioEngine.inputNode else { return }
        let recordingFormat = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.request.append(buffer)
        }

        // Prepare and start recording
        audioEngine.prepare()
        do {
            try audioEngine.start()
            self.status = .recognizing
        } catch {
            return print(error)
        }

        // Analyze the speech
        recognitionTask = speechRecognizer?.recognitionTask(with: request, resultHandler: { result, error in
            if let result = result {
                self.flightTextView.text = result.bestTranscription.formattedString
                self.searchFlight(number: result.bestTranscription.formattedString)
            } else if let error = error {
                print(error)
            }
        })
    }

    /// Stops and cancels the speech recognition.
    func cancelRecording() {
        audioEngine.stop()
        if let node = audioEngine.inputNode {
            node.removeTap(onBus: 0)
        }
        recognitionTask?.cancel()
    }

    @IBAction func microphonePressed() {
        switch status {
        case .ready:
            startRecording()
            status = .recognizing
        case .recognizing:
            cancelRecording()
            status = .ready
        default:
            break
        }
    }
}
