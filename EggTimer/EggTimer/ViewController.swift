//
//  ViewController.swift
//  EggTimer
//
//  Created by Angela Yu on 08/07/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import AVFoundation
import UIKit

class ViewController: UIViewController {
    // Contraints for egg boiling
    let softTimer = 5 * 60 // 5 mins
    let mediumTimer = 8 * 60 // 8 mins
    let hardTimer = 12 * 60 // 12 mins
    
    // Outlets
    @IBOutlet weak var mainTitle: UILabel!
    
    @IBOutlet weak var progressBar: UIProgressView!
    
    @IBOutlet weak var resetButton: UIButton!
    
    @IBOutlet weak var percentageLabel: UILabel!
    
    // Constraints to track percentage of time
    var timeElapsed = 0.0 // in seconds
    var totalTime: Int! // in seconds
    var timer = Timer()
    
    // Player to play alert when boiling is completed
    var player: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ViewDidLoad")
        resetView()
    }
    
    @IBAction func eggTapped(_ sender: Any) {
        let button = sender as! UIButton
        
        // Initializing timer to update time elapsed in every seconds
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        
        print("Button tapped: \(String(describing: button.titleLabel))")
        
        mainTitle.text = button.currentTitle
        timeElapsed = 0
        progressBar.progress = 0
        switch button.tag {
        case 0: totalTime = softTimer
        case 1: totalTime = mediumTimer
        case 2: totalTime = hardTimer
        default: break
        }
    }
    
    @objc func updateTime() {
        timeElapsed += 0.1
        let percentage = Float(timeElapsed)/Float(totalTime)
        print("Updating percentage: \(Int(percentage * 100))%")
        progressBar.setProgress(percentage, animated: true)
        percentageLabel.text = "\(Int(percentage * 100))%"
        if percentage == 1.0 {
            mainTitle.text = "সেদ্ধ হয়েছে!!!"
            playAlarm()
            timer.invalidate()
        }
    }
    
    @IBAction func resetAction(_ sender: Any) {
        print("Reset tapped")
        resetView()
    }
    
    func resetView() {
        mainTitle.text = "কেমন ডিম চান?"
        progressBar.progress = 0
        percentageLabel.text = "0%"
        timeElapsed = 0
        totalTime = nil
        timer.invalidate()
    }
    
    func playAlarm() {
        guard let path = Bundle.main.path(forResource: "alarm_sound", ofType:"mp3") else {
            print("Failed fetching path")
            return
        }
        let url = URL(fileURLWithPath: path)

        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
