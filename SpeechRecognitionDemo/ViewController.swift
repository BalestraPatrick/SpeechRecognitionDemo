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
    @IBOutlet weak var transcriptionTextView: UITextView!
    @IBOutlet weak var tableView: UITableView!

    var preRecordedAudioURL: URL = {
        return Bundle.main.url(forResource: "LX40", withExtension: "m4a")!
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        applyStyle()

        if SFSpeechRecognizer.authorizationStatus() == .notDetermined {
            askSpeechPermission()
        } else {
            self.setUI(status: SFSpeechRecognizer.authorizationStatus())
        }

        recognizeFile(url: preRecordedAudioURL)
    }

    func setUI(status: SFSpeechRecognizerAuthorizationStatus) {
        switch status {
        case .authorized:
            microphoneButton.setImage(#imageLiteral(resourceName: "available"), for: .normal)
        default:
            microphoneButton.setImage(#imageLiteral(resourceName: "unavailable"), for: .normal)
        }
    }

    func askSpeechPermission() {
        // The closure is not returned on the main thread, so we have to switch to it to update the UI.
        SFSpeechRecognizer.requestAuthorization { status in
            OperationQueue.main.addOperation {
                self.setUI(status: status)
            }
        }
    }

    private func recognizeFile(url: URL) {
        guard let recognizer = SFSpeechRecognizer(), recognizer.isAvailable else {
            return
        }

        let request = SFSpeechURLRecognitionRequest(url: url)
        recognizer.recognitionTask(with: request) { result, error in
            if let result = result {
                print(result.bestTranscription.formattedString)
            } else if let error = error {
                print(error)
            }
        }
    }

    // MARK: IBActions

    @IBAction func microphonePressed(_ sender: Any) {
    }
}
