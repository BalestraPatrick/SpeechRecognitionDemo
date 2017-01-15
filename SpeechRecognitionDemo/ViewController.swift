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

    var preRecordedAudioURL: URL = {
        return Bundle.main.url(forResource: "LX40", withExtension: "m4a")!
    }()

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

    func recognizeFile(url: URL) {
        guard let recognizer = SFSpeechRecognizer(), recognizer.isAvailable else {
            return
        }

        let request = SFSpeechURLRecognitionRequest(url: url)
        recognizer.recognitionTask(with: request) { result, error in
            guard let recognizer = SFSpeechRecognizer(), recognizer.isAvailable else {
                return self.status = .unavailable
            }
            if let result = result {
                self.flightTextView.text = result.bestTranscription.formattedString
                if result.isFinal {
                    self.searchFlight(number: result.bestTranscription.formattedString)
                }
            } else if let error = error {
                print(error)
            }
        }
    }

    @IBAction func microphonePressed(_ sender: Any) {
        recognizeFile(url: preRecordedAudioURL)
    }
}
