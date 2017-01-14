//
//  ViewController.swift
//  SpeechRecognitionDemo
//
//  Created by Patrick Balestra on 1/6/17.
//  Copyright © 2017 Patrick Balestra. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var microphoneButton: UIButton!
    @IBOutlet weak var flightTextView: UITextView!
    @IBOutlet weak var tableView: UITableView!

    var status = SpeechStatus.ready {
        didSet {
            self.setUI(status: status)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        applyStyle()

    }

    // TODO

    @IBAction func microphonePressed() {

    }
}
