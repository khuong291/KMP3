//
//  PlayerViewController.swift
//  KMP3
//
//  Created by KhuongPham on 1/27/18.
//

import Foundation
import UIKit

final class PlayerViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func minimizeButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
