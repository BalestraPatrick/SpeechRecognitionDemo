//
//  ViewController.swift
//  SpeechRecognitionDemo
//
//  Created by Patrick Balestra on 1/6/17.
//  Copyright © 2017 Patrick Balestra. All rights reserved.
//

import UIKit
import Speech

enum SpeechStatus {
    case ready
    case recognizing
    case unavailable
}

class ViewController: UIViewController {

    @IBOutlet weak var microphoneButton: UIButton!
    @IBOutlet weak var transcriptionTextView: UITextView!
    @IBOutlet weak var tableView: UITableView!

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
            self.setUI(status: .ready)
        default:
            break
        }
    }

    func askSpeechPermission() {
        // The closure is not returned on the main thread, so we have to switch to it to update the UI.
        SFSpeechRecognizer.requestAuthorization { status in
            OperationQueue.main.addOperation {
                switch status {
                case .authorized:
                    self.setUI(status: .ready)
                default:
                    self.setUI(status: .unavailable)
                }
            }
        }
    }

    private func recognizeFile(url: URL) {
        guard let recognizer = SFSpeechRecognizer(), recognizer.isAvailable else {
            return
        }

        let request = SFSpeechURLRecognitionRequest(url: url)
        recognizer.recognitionTask(with: request) { result, error in
            guard let result = result else {
                return
            }
            self.transcriptionTextView.text = result.bestTranscription.formattedString
            if result.isFinal {
                print(result.bestTranscription.formattedString)
            } else if let error = error {
                print(error)
            }
        }
    }

    // MARK: IBActions

    @IBAction func microphonePressed(_ sender: Any) {
        recognizeFile(url: preRecordedAudioURL)
    }
}
