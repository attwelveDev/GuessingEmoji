//
//  ViewController.swift
//  GuessingEmoji
//
//  Created by Aaron Nguyen on 6/4/18.
//  Copyright © 2018 Aaron Nguyen. All rights reserved.
//

// MARK: Modules

import UIKit
import AVFoundation
import SafariServices
import StoreKit

// MARK: Extensions

extension UIStackView {
    func removeAllArrangedSubviews() {
        let removedSubviews = arrangedSubviews.reduce([]) { (allSubviews, subview) -> [UIView] in
            self.removeArrangedSubview(subview)
            return allSubviews + [subview]
        }
        
        removedSubviews.forEach({ $0.removeFromSuperview() })
    }
}

extension Array {
    var shuffled: Array {
        var array = self
        
        indices.dropLast().forEach {
            guard case let index = Int(arc4random_uniform(UInt32(count - $0))) + $0, index != $0 else { return }
            array.swapAt($0, index)
        }
        
        return array
    }
}

extension String {
    var jumble: String {
        return String(Array(self).shuffled)
    }
}

class ViewController: UIViewController, SKStoreProductViewControllerDelegate {

    // MARK: @IBOutlet connections
    
    @IBOutlet weak var easyButton: UIButton!
    @IBOutlet weak var mediumButton: UIButton!
    @IBOutlet weak var hardButton: UIButton!
    @IBOutlet weak var instructsButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!
    
    @IBOutlet var instructsView: UIView!
    @IBOutlet weak var instructsText: UITextView!
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet var moreView: UIView!
    @IBOutlet weak var vabButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var rateButton: UIButton!
    @IBOutlet weak var siteButton: UIButton!
    @IBOutlet weak var ppButton: UIButton!
    @IBOutlet weak var maButton: UIButton!
    @IBOutlet weak var aboutButton: UIButton!
    @IBOutlet weak var bBackButton: UIButton!
    
    @IBOutlet var maView: UIView!
    @IBOutlet weak var qtButton: UIButton!
    @IBOutlet weak var qtText: UITextView!
    @IBOutlet weak var tcButton: UIButton!
    @IBOutlet weak var tcText: UITextView!
    @IBOutlet weak var cBackButton: UIButton!
    
    @IBOutlet var aboutView: UIView!
    @IBOutlet weak var aboutText: UITextView!
    @IBOutlet weak var aBackButton: UIButton!
    
    @IBOutlet var gameView: UIView!
    @IBOutlet weak var bombLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
//    @IBOutlet weak var highscoreLabel: UILabel!
    @IBOutlet weak var emojiLabel: UILabel!
    @IBOutlet weak var emojiImageView: UIImageView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var hintButton: UIButton!
    
    @IBOutlet var gameOverView: UIView!
    @IBOutlet weak var gameOverLabel: UILabel!
    @IBOutlet weak var gameOverMessageLabel: UILabel!
    @IBOutlet weak var gameOverScoreLabel: UILabel!
//    @IBOutlet weak var gameOverHighscoreLabel: UILabel!
    @IBOutlet weak var shareResultButton: UIButton!
    @IBOutlet weak var againButton: UIButton!
    @IBOutlet weak var menuButton: UIButton!
    
    // MARK: Other Declarations
    
    var player: AVAudioPlayer?
    
    let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.regular))
    
    var curtain = UIView()
    
    var button = UIButton()
    
    var remainingHints = 2
    
    var buttonTitle = String()
    var difficulty = String()
    
    var score = 0
    
    let explosionView = UIImageView(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
    
    let correctView = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
    
    let startView = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
    
    var tapPoint = CGPoint()
    
    var scaleNumber = CGFloat()
    
    var isInitialLaunch = true
    var isInitalRotation = true
    
    var isLoadingApp = false
    
    var modePlayed = String()
    
    // TODO: to insert in next update
//    var easyHighscore = UserDefaults.standard.integer(forKey: "easyHighscore")
//    var mediumHighscore = UserDefaults.standard.integer(forKey: "mediumHighscore")
//    var hardHighscore = UserDefaults.standard.integer(forKey: "hardHighscore")
//
//    let defaults = UserDefaults.standard
    
    // MARK: Override functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if defaults.object(forKey: "easyHighscore") == nil {
//            defaults.set(0, forKey: "easyHighscore")
//        }
//        if defaults.object(forKey: "mediumHighscore") == nil {
//            defaults.set(0, forKey: "mediumHighscore")
//        }
//        if defaults.object(forKey: "hardHighscore") == nil {
//            defaults.set(0, forKey: "hardHighscore")
//        }
        
        roundCornersOf(easyButton, radius: easyButton.frame.height / 2, shadows: true)
        roundCornersOf(mediumButton, radius: mediumButton.frame.height / 2, shadows: true)
        roundCornersOf(hardButton, radius: hardButton.frame.height / 2, shadows: true)
        roundCornersOf(instructsButton, radius: instructsButton.frame.height / 2, shadows: true)
        roundCornersOf(moreButton, radius: moreButton.frame.height / 2, shadows: true)
        
        roundCornersOf(vabButton, radius: vabButton.frame.height / 2, shadows: false)
        roundCornersOf(shareButton, radius: shareButton.frame.height / 2, shadows: false)
        roundCornersOf(rateButton, radius: shareButton.frame.height / 2, shadows: false)
        roundCornersOf(siteButton, radius: siteButton.frame.height / 2, shadows: false)
        roundCornersOf(ppButton, radius: ppButton.frame.height / 2, shadows: false)
        roundCornersOf(maButton, radius: maButton.frame.height / 2, shadows: false)
        roundCornersOf(aboutButton, radius: aboutButton.frame.height / 2, shadows: false)
        
        roundCornersOf(tcButton, radius: tcButton.frame.height / 2, shadows: false)
        roundCornersOf(qtButton, radius: qtButton.frame.height / 2, shadows: false)
        
        instructsView.frame = CGRect(x: 0, y: 0, width: view.frame.width - 40, height: view.frame.height - 40)
        moreView.frame = CGRect(x: 0, y: 0, width: view.frame.width - 40, height: view.frame.height - 40)
        maView.frame = CGRect(x: 0, y: 0, width: view.frame.width - 40, height: view.frame.height - 40)
        aboutView.frame = CGRect(x: 0, y: 0, width: view.frame.width - 40, height: view.frame.height - 40)
        gameView.frame = CGRect(x: 0, y: 0, width: view.frame.width - 40, height: view.frame.height - 40)
        gameOverView.frame = CGRect(x: 0, y: 0, width: view.frame.width - 40, height: view.frame.height - 40)
        
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 2436:
                let screenSize = UIScreen.main.bounds.size
                if screenSize.width > screenSize.height { // landscape
                    instructsView.frame = CGRect(x: 0, y: 0, width: view.frame.width - 80, height: view.frame.height - 40)
                    moreView.frame = CGRect(x: 0, y: 0, width: view.frame.width - 80, height: view.frame.height - 40)
                    maView.frame = CGRect(x: 0, y: 0, width: view.frame.width - 80, height: view.frame.height - 40)
                    aboutView.frame = CGRect(x: 0, y: 0, width: view.frame.width - 80, height: view.frame.height - 40)
                    gameView.frame = CGRect(x: 0, y: 0, width: view.frame.width - 80, height: view.frame.height - 40)
                    gameOverView.frame = CGRect(x: 0, y: 0, width: view.frame.width - 80, height: view.frame.height - 40)
                } else { // portrait
                    instructsView.frame = CGRect(x: 0, y: 0, width: view.frame.width - 40, height: view.frame.height - 80)
                    moreView.frame = CGRect(x: 0, y: 0, width: view.frame.width - 40, height: view.frame.height - 80)
                    maView.frame = CGRect(x: 0, y: 0, width: view.frame.width - 40, height: view.frame.height - 80)
                    aboutView.frame = CGRect(x: 0, y: 0, width: view.frame.width - 40, height: view.frame.height - 80)
                    gameView.frame = CGRect(x: 0, y: 0, width: view.frame.width - 40, height: view.frame.height - 80)
                    gameOverView.frame = CGRect(x: 0, y: 0, width: view.frame.width - 40, height: view.frame.height - 80)
                }
            default:
                break // every other iPhone than iPhone X
            }
        }
        
        if instructsText.contentSize.height < instructsText.frame.size.height {
            instructsText.isScrollEnabled = false
        } else {
            instructsText.isScrollEnabled = true
        }
        if tcText.frame.size.height < tcText.contentSize.height {
            tcText.frame.size.height = tcText.contentSize.height
        }
        if qtText.frame.size.height < qtText.contentSize.height {
            qtText.frame.size.height = qtText.contentSize.height
        }
        if aboutText.contentSize.height < aboutText.frame.size.height {
            aboutText.isScrollEnabled = false
        } else {
            aboutText.isScrollEnabled = true
        }
        roundCornersOf(instructsView, radius: 10, shadows: true)
        roundCornersOf(backButton, radius: backButton.frame.height / 2, shadows: false)
        
        roundCornersOf(aboutView, radius: 10, shadows: false)
        roundCornersOf(aBackButton, radius: aBackButton.frame.height / 2, shadows: false)
        
        roundCornersOf(moreView, radius: 10, shadows: true)
        roundCornersOf(bBackButton, radius: bBackButton.frame.height / 2, shadows: false)
        
        roundCornersOf(maView, radius: 10, shadows: false)
        roundCornersOf(cBackButton, radius: cBackButton.frame.height / 2, shadows: false)
    
        roundCornersOf(gameView, radius: 10, shadows: true)
        roundCornersOf(hintButton, radius: hintButton.frame.height / 2, shadows: false)
        
        roundCornersOf(gameOverView, radius: 10, shadows: true)
        
        roundCornersOf(shareResultButton, radius: shareButton.frame.height / 2, shadows: false)
        roundCornersOf(againButton, radius: againButton.frame.height / 2, shadows: false)
        roundCornersOf(menuButton, radius: menuButton.frame.height / 2, shadows: false)
        
        blurEffectView.frame = view.frame
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        iconIndex = Int(arc4random_uniform(UInt32(emojiArray.count)))
        key = Array(emojiArray.keys)[iconIndex]
        dictValue = Array(emojiArray.values)[iconIndex]
        jumbledKey = key.jumble.lowercased()
        unjumbledAnswers = [String]()
        
        explosionView.image = UIImage(named: "explosionGradient")
        roundCornersOf(explosionView, radius: explosionView.frame.size.width / 2, shadows: false)
        explosionView.clipsToBounds = true
        
        correctView.backgroundColor = .green
        roundCornersOf(correctView, radius: correctView.frame.size.width / 2, shadows: false)
        correctView.clipsToBounds = true
        
        startView.backgroundColor = .cyan
        roundCornersOf(startView, radius: startView.frame.size.width / 2, shadows: false)
        startView.clipsToBounds = true

        emojiImageView.center = emojiLabel.center
        
        if view.frame.height > view.frame.width {
            scaleNumber = view.frame.height * 2 + 150
        } else {
            scaleNumber = view.frame.width * 2 + 150
        }

        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        blurEffectView.frame = view.frame
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            self.instructsView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width - 40, height: self.view.frame.height - 40)
            self.moreView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width - 40, height: self.view.frame.height - 40)
            self.maView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width - 40, height: self.view.frame.height - 40)
            self.aboutView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width - 40, height: self.view.frame.height - 40)
            self.gameView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width - 40, height: self.view.frame.height - 40)
            self.gameOverView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width - 40, height: self.view.frame.height - 40)
            
            if self.instructsText.contentSize.height < self.instructsText.frame.size.height {
                self.instructsText.isScrollEnabled = false
            } else {
                self.instructsText.isScrollEnabled = true
            }
            if self.tcText.frame.size.height < self.tcText.contentSize.height {
                self.tcText.frame.size.height = self.tcText.contentSize.height
            }
            if self.qtText.frame.size.height < self.qtText.contentSize.height {
                self.qtText.frame.size.height = self.qtText.contentSize.height
            }
            if self.aboutText.contentSize.height < self.aboutText.frame.size.height {
                self.aboutText.isScrollEnabled = false
            } else {
                self.aboutText.isScrollEnabled = true
            }

            self.imageFromLabel(self.emojiLabel)
            self.emojiImageView.center = self.emojiLabel.center
            self.emojiLabel.center = self.emojiImageView.center
            
            if UIDevice().userInterfaceIdiom == .phone {
                switch UIScreen.main.nativeBounds.height {
                case 2436:
                    let screenSize = UIScreen.main.bounds.size
                    if screenSize.width > screenSize.height { // landscape
                        self.instructsView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width - 80, height: self.view.frame.height - 40)
                        self.moreView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width - 80, height: self.view.frame.height - 40)
                        self.maView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width - 80, height: self.view.frame.height - 40)
                        self.aboutView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width - 80, height: self.view.frame.height - 40)
                        self.gameView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width - 80, height: self.view.frame.height - 40)
                        self.gameOverView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width - 80, height: self.view.frame.height - 40)
                    } else { // portrait
                        self.instructsView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width - 40, height: self.view.frame.height - 80)
                        self.moreView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width - 40, height: self.view.frame.height - 80)
                        self.maView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width - 40, height: self.view.frame.height - 80)
                        self.aboutView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width - 40, height: self.view.frame.height - 80)
                        self.gameView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width - 40, height: self.view.frame.height - 80)
                        self.gameOverView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width - 40, height: self.view.frame.height - 80)
                    }
                default:
                    break // every other iPhone than iPhone X
                }
            }
            
            self.roundCornersOf(self.instructsView, radius: 10, shadows: true)
            self.roundCornersOf(self.moreView, radius: 10, shadows: true)
            self.roundCornersOf(self.maView, radius: 10, shadows: false)
            self.roundCornersOf(self.aboutView, radius: 10, shadows: false)
            self.roundCornersOf(self.gameView, radius: 10, shadows: true)
            self.roundCornersOf(self.gameOverView, radius: 10, shadows: true)
            
            self.instructsView.center = self.view.center
            self.moreView.center = self.view.center
            self.maView.center = self.view.center
            self.aboutView.center = self.view.center
            self.gameView.center = self.view.center
            self.gameOverView.center = self.view.center
        }
    }
    
//    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
//
//    }
    
    // MARK: @IBAction functions
    
    @IBAction func addInstructsView(_ sender: Any) {
        fadeIn(blurEffectView)
        animateIn(instructsView)
    }
    
    @IBAction func addMoreView(_ sender: Any) {
        fadeIn(blurEffectView)
        animateIn(moreView)
    }
    
    @IBAction func showVab(_ sender: Any) {
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] as! String
        let build = dictionary["CFBundleVersion"] as! String
        
        if vabButton.title(for: .normal) == "Version & Build" {
            vabButton.setTitle("Version \(version) | Build \(build)", for: .normal)

            perform(#selector(ViewController.changeVab), with: nil, afterDelay: 5)
        } else {
            NSObject.cancelPreviousPerformRequests(withTarget: self)
            vabButton.setTitle("Version & Build", for: .normal)
        }
    }
    
    @IBAction func shareAction(_ sender: Any) {
        let textToShare = ["Hello! I love GuessingEmoji and I think you should check it out!\n\nGuessingEmoji tests your knowledge of the little symbols you encounter but ignore every day...\n\nDownload now! https://itunes.apple.com/us/app/guessingemoji/id1373719010?mt=8"]
        
        let activityVc = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityVc.popoverPresentationController?.sourceView = view
        
        activityVc.excludedActivityTypes = [UIActivityType("com.apple.mobilenotes.SharingExtension")]
        
        present(activityVc, animated: true, completion: nil)
    }
    
    @IBAction func rateAction(_ sender: Any) {
        if !isLoadingApp {
            presentApp("GuessingEmoji", appId: 1373719010)
        }
    }
    
    @IBAction func showSite(_ sender: Any) {
        presentWebsite("https://sites.google.com/view/attwelve/")
    }
    
    @IBAction func showPp(_ sender: Any) {
        presentWebsite("https://sites.google.com/view/attwelve/privacy-policy")
    }
    
    @IBAction func addMaView(_ sender: Any) {
        animateIn(maView)
        
        resetAppButtons()
    }
    
    @IBAction func showQt(_ sender: Any) {
        if !isLoadingApp {
            presentApp("QuickTap", appId: 1190851546)
        }
    }
    
    @IBAction func showTc(_ sender: Any) {
        if !isLoadingApp {
            presentApp("TempConv", appId: 1163432921)
        }
    }
    
    @IBAction func addAboutView(_ sender: Any) {
        animateIn(aboutView)
    }
    
    @IBAction func goBack(_ sender: Any) {
        easyButton.isUserInteractionEnabled = true
        mediumButton.isUserInteractionEnabled = true
        hardButton.isUserInteractionEnabled = true
        
        fadeOut(blurEffectView)
        
        animateOut(instructsView)
        animateOut(moreView)
        animateOut(gameOverView)
        
        resetAppButtons()
    }
    
    @IBAction func aGoBack(_ sender: Any) {
        animateOut(maView)
        animateOut(aboutView)
        
        resetAppButtons()
    }
    
    @IBAction func startGame(_ sender: Any) {
        easyButton.isUserInteractionEnabled = false
        mediumButton.isUserInteractionEnabled = false
        hardButton.isUserInteractionEnabled = false
        
        if (sender as! UIButton).titleLabel?.text != "Again!" {
            modePlayed = ((sender as! UIButton).titleLabel?.text!)!
        }
        
//        switch modePlayed {
//        case "Easy":
//            highscoreLabel.text = String(easyHighscore)
//            print(easyHighscore)
//        case "Medium":
//            highscoreLabel.text = String(mediumHighscore)
//        case "Hard":
//            highscoreLabel.text = String(hardHighscore)
//        default:
//            break
//        }
        
        fadeIn(blurEffectView)
        animateIn(gameView)
        startGame(sender as! UIButton)
    }
    
    @IBAction func giveHint(_ sender: Any) {
        showHint()
    }
    
    @IBAction func playAgain(_ sender: Any) {
        startGame(sender as! UIButton)
    }
    
    @IBAction func shareGameResult(_ sender: Any) {
        var textToShare = ["Hello! I just played GuessingEmoji and achieved a score of \(score) playing \(modePlayed) mode!\n\nGuessingEmoji tests your knowledge of the little symbols you encounter but ignore every day...\n\nDownload now! https://itunes.apple.com/us/app/guessingemoji/id1373719010?mt=8"]

        if score == 50 {
            textToShare = ["Hello! I just played GuessingEmoji and achieved a score of \(score) playing \(modePlayed) mode! Getting 50 means that I diffused the emoji bomb and won the game!\n\nGuessingEmoji tests your knowledge of the little symbols you encounter but ignore every day...\n\nDownload now! https://itunes.apple.com/us/app/guessingemoji/id1373719010?mt=8"]
        }
        
        let activityVc = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityVc.popoverPresentationController?.sourceView = view
        
        activityVc.excludedActivityTypes = [UIActivityType("com.apple.mobilenotes.SharingExtension")]
        
        present(activityVc, animated: true, completion: nil)
    }
    
    // MARK: Main functions
    
    @objc func changeVab() {
        vabButton.setTitle("Version & Build", for: .normal)
    }

    func startGame(_ sender: UIButton) {
        gameView.alpha = 1
        gameOverView.removeFromSuperview()
        
        startView.center.x = gameView.center.x - 20
        startView.center.y = gameView.center.y - 20
        gameView.addSubview(startView)
        expandView(startView, duration: 0.25)
        
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        generator.impactOccurred()
        playSound("startBellSFX", fileExtension: ".mp3")
        
        remainingHints = 2
        
        buttonTitle = (sender.titleLabel?.text)!
        if buttonTitle == "Again!" {
            newQuestion(difficulty)
        } else {
            difficulty = buttonTitle
            newQuestion(buttonTitle)
        }
        
        scoreLabel.textColor = .black
//        highscoreLabel.textColor = .black
        
        score = 0
        scoreLabel.text = "\(score)"
        usedEmojis.removeAll()
    }
    
    @objc func handleTimeOut() {
        explosionView.center.x = bombLabel.center.x + 20
        explosionView.center.y = bombLabel.center.y + 20
        view.addSubview(explosionView)
        expandView(explosionView, duration: 0.25)
        handleGameOver("timeout")
    }
    
    func newQuestion(_ difficulty: String) {
        if difficulty == "Easy" || difficulty == "Medium" {
            perform(#selector(ViewController.handleTimeOut), with: nil, afterDelay: 10)
        } else {
            perform(#selector(ViewController.handleTimeOut), with: nil, afterDelay: 5)
        }

        stackView.removeAllArrangedSubviews()
        
        if difficulty == "Medium" || difficulty == "Hard" {
            hintButton.alpha = 1
            hintButton.setTitle("Hint (\(remainingHints))", for: .normal)
            if remainingHints == 0 {
                hintButton.isUserInteractionEnabled = false
            } else {
                hintButton.isUserInteractionEnabled = true
            }
        } else {
            hintButton.alpha = 0
        }
        
        var answers = Set<String>()
        
        iconIndex = Int(arc4random_uniform(UInt32(emojiArray.count)))
        key = Array(emojiArray.keys)[iconIndex]
        jumbledKey = key.jumble.lowercased()
        dictValue = Array(emojiArray.values)[iconIndex]
        var dict = [key: dictValue]
        
        while usedEmojis.contains(dict) {
            iconIndex = Int(arc4random_uniform(UInt32(emojiArray.count)))
            key = Array(emojiArray.keys)[iconIndex]
            jumbledKey = key.jumble.lowercased()
            dictValue = Array(emojiArray.values)[iconIndex]
            dict = [key: dictValue]
        }
        
        usedEmojis.append(dict)
        
        emojiLabel.text = dictValue
        imageFromLabel(emojiLabel)
        
        unjumbledAnswers.removeAll()
        
        while answers.count <= 2 {
            var answerIndex = Int(arc4random_uniform(UInt32(emojiArray.count)))
            var answerKey = Array(emojiArray.keys)[answerIndex]
            while answerKey == key {
                answerIndex = Int(arc4random_uniform(UInt32(emojiArray.count)))
                answerKey = Array(emojiArray.keys)[answerIndex]
            }
            answers.insert(answerKey)
        }
        
        unjumbledAnswers = Array(answers)
        
        var last = unjumbledAnswers.count - 1
        while last > 0 {
            let answerIndex = Int(arc4random_uniform(UInt32(last)))
            unjumbledAnswers.swapAt(last, answerIndex)
            last -= 1
        }
        
        var jumbledAnswers = [String]()
        for jumbledAnswer in unjumbledAnswers {
            jumbledAnswers.append(jumbledAnswer.lowercased().jumble)
        }
        
        let locationIndex = Int(arc4random_uniform(UInt32(4)))
        jumbledAnswers.insert(jumbledKey, at: locationIndex)
        unjumbledAnswers.insert(key, at: locationIndex)
        
        var finalAnswers = [String]()
        if difficulty == "Easy" {
            finalAnswers = unjumbledAnswers
        } else {
            finalAnswers = jumbledAnswers
        }
        
        var tagNum = 1

        for answer in finalAnswers {
            button = UIButton(frame: CGRect(x: 0, y: 0, width: 103.50, height: 30))
            button.addTarget(self, action: #selector(ViewController.checkAnswer(_:)), for: .touchUpInside)
            button.addTarget(self, action: #selector(ViewController.locationChecker(_:forEvent:)), for: .touchUpInside)
            
            button.tag = tagNum
            tagNum += 1
            
            button.setTitle(answer, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 14)
            button.backgroundColor = UIColor(red: 234/255, green: 195/255, blue: 97/255, alpha: 1)
            button.setTitleColor(.black, for: .normal)
            
            roundCornersOf(button, radius: button.frame.height / 2, shadows: false)
            stackView.addArrangedSubview(button)
        }
    }
    
    @objc func checkAnswer(_ sender: UIButton) {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        
        if sender.title(for: .normal) == jumbledKey || sender.title(for: .normal) == key {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01, execute: {
                self.correctView.center.x = self.tapPoint.x
                self.correctView.center.y = self.tapPoint.y
                self.gameView.addSubview(self.correctView)
                self.expandView(self.correctView, duration: 0.25)
            })
            
            score += 1
            scoreLabel.text = "\(score)"
            
//            if modePlayed == "Easy" && score >= easyHighscore {
//                defaults.set(score, forKey: "easyHighscore")
//                defaults.synchronize()
//
//                scoreLabel.textColor = .green
//                highscoreLabel.textColor = .green
//
//                highscoreLabel.text = scoreLabel.text
//            } else if modePlayed == "Medium" && score >= mediumHighscore {
//                defaults.set(score, forKey: "mediumHighscore")
//                defaults.synchronize()
//
//                scoreLabel.textColor = .green
//                highscoreLabel.textColor = .green
//
//                highscoreLabel.text = scoreLabel.text
//            } else if modePlayed == "Hard" && score >= hardHighscore {
//                defaults.set(score, forKey: "hardHighscore")
//                defaults.synchronize()
//
//                scoreLabel.textColor = .green
//                highscoreLabel.textColor = .green
//
//                highscoreLabel.text = scoreLabel.text
//            }
            
            emojiLabel.alpha = 1
            
            stackView.removeAllArrangedSubviews()
            
            let label = UILabel(frame: CGRect(x: 10, y: gameView.center.y, width: 430, height: 30))
            label.backgroundColor = UIColor(red: 234/255, green: 195/255, blue: 97/255, alpha: 1)
            label.font = .systemFont(ofSize: 13)
            label.textColor = .black
            label.text = key
            label.textAlignment = .center
            roundCornersOf(label, radius: label.frame.height / 2, shadows: false)
            label.clipsToBounds = true
            
            stackView.addArrangedSubview(label)
            
            emojiImageView.alpha = 0
            
            if score != 50 {
                playSound("dingSFX", fileExtension: ".mp3")
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.01, execute: {
                    self.correctView.center.x = self.tapPoint.x + 20
                    self.correctView.center.y = self.tapPoint.y + 20
                    self.view.addSubview(self.correctView)
                    self.expandView(self.correctView, duration: 0.25)
                })
                
                playSound("victorySFX", fileExtension: ".mp3")

                stackView.removeAllArrangedSubviews()
                
                self.handleGameOver("complete")
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                label.removeFromSuperview()

                self.stackView.removeAllArrangedSubviews()
                
                if self.score != 50  {
                    self.newQuestion(self.difficulty)
                }
            })
        } else {
            explosionView.center.x = bombLabel.center.x + 20
            explosionView.center.y = bombLabel.center.y + 20
            view.addSubview(explosionView)
            expandView(explosionView, duration: 0.25)
            handleGameOver("incorrect")
        }
    }
    
    func showHint() {
        hintButton.alpha = 0
        remainingHints -= 1
        hintButton.isUserInteractionEnabled = true
        
        let firstLetterKey = key.first
        let utterance = AVSpeechUtterance(string: String(firstLetterKey!).lowercased())
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.5
        
        let synthesiser = AVSpeechSynthesizer()
        synthesiser.speak(utterance)
        
        stackView.removeAllArrangedSubviews()
        
        var tagNum = 1
        
        for answer in unjumbledAnswers {
            button = UIButton(frame: CGRect(x: 0, y: 0, width: 103.50, height: 30))
            button.addTarget(self, action: #selector(ViewController.checkAnswer(_:)), for: .touchUpInside)
            button.addTarget(self, action: #selector(ViewController.locationChecker(_:forEvent:)), for: .touchUpInside)
            
            button.tag = tagNum
            tagNum += 1
            
            button.setTitle(answer, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 13)
            button.backgroundColor = UIColor(red: 234/255, green: 195/255, blue: 97/255, alpha: 1)
            button.setTitleColor(.black, for: .normal)
            
            roundCornersOf(button, radius: button.frame.height / 2, shadows: false)
            stackView.addArrangedSubview(button)
        }
    }
    
    @objc func locationChecker(_ button: UIButton, forEvent event: UIEvent) {
        guard let touch = event.allTouches?.first else { return }
        
        if traitCollection.horizontalSizeClass == .regular {
            if button.tag == 1 {
                tapPoint.x = touch.location(in: button).x
            } else if button.tag == 2 {
                tapPoint.x = touch.location(in: button).x + button.frame.width
            } else if button.tag == 3 {
                tapPoint.x = touch.location(in: button).x + 2 * button.frame.width
            } else if button.tag == 4 {
                tapPoint.x = touch.location(in: button).x + 3 * button.frame.width
            }
            
            tapPoint.y = touch.location(in: button).y
        } else if traitCollection.horizontalSizeClass == .compact {
            if button.tag == 1 {
                tapPoint.y = touch.location(in: button).y
            } else if button.tag == 2 {
                tapPoint.y = touch.location(in: button).y + button.frame.height
            } else if button.tag == 3 {
                tapPoint.y = touch.location(in: button).y + 2 * button.frame.height
            } else if button.tag == 4 {
                tapPoint.y = touch.location(in: button).y + 3 * button.frame.height
            }
            
            tapPoint.x = touch.location(in: button).x
        }
    }
    
    func handleGameOver(_ method: String) {
        gameView.alpha = 0
        
        roundCornersOf(gameOverView, radius: 10, shadows: true)
        gameOverView.center = view.center
        
        self.gameOverView.alpha = 0
        self.view.addSubview(self.gameOverView)
        
        UIView.animate(withDuration: 1.0, animations: {
            self.gameOverView.alpha = 1
        })
        
        gameOverScoreLabel.text = scoreLabel.text
//        gameOverHighscoreLabel.text = highscoreLabel.text
//
//        if gameOverScoreLabel.text == gameOverHighscoreLabel.text {
//            gameOverScoreLabel.textColor = .green
//            gameOverHighscoreLabel.textColor = .green
//        } else {
//            gameOverScoreLabel.textColor = .black
//            gameOverHighscoreLabel.textColor = .black
//        }
        
        switch method {
        case "incorrect":
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.prepare()
            generator.impactOccurred()
            playSound("explosionSFX", fileExtension: ".mp3")
            
//            if (modePlayed == "Easy" && score > easyHighscore) || (modePlayed == "Medium" && score > mediumHighscore) || (modePlayed == "Hard" && score > hardHighscore) {
//                gameOverLabel.text = "New Highscore!"
//            } else if (modePlayed == "Easy" && score == easyHighscore) || (modePlayed == "Medium" && score == mediumHighscore) || (modePlayed == "Hard" && score == hardHighscore) {
//                gameOverLabel.text = "Equalled Highscore!"
//            } else {
                gameOverLabel.text = "Game Over!"
//            }
            
            if key == "DVD" {
                gameOverMessageLabel.text = "Incorrect. It was \(key) (\(dictValue))."
            } else {
                gameOverMessageLabel.text = "Incorrect. It was \(key.lowercased()) (\(dictValue))."
            }
        case "timeout":
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.prepare()
            generator.impactOccurred()
            playSound("explosionSFX", fileExtension: ".mp3")
//
//            if (modePlayed == "Easy" && score > easyHighscore) || (modePlayed == "Medium" && score > mediumHighscore) || (modePlayed == "Hard" && score > hardHighscore) {
//                gameOverLabel.text = "New Highscore!"
//            } else if (modePlayed == "Easy" && score == easyHighscore) || (modePlayed == "Medium" && score == mediumHighscore) || (modePlayed == "Hard" && score == hardHighscore) {
//                gameOverLabel.text = "Equalled Highscore!"
//            } else {
                gameOverLabel.text = "Game Over!"
//            }
        
            if key == "DVD" {
                gameOverMessageLabel.text = "Timeout. It was \(key) (\(dictValue))."
            } else {
                gameOverMessageLabel.text = "Timeout. It was \(key.lowercased()) (\(dictValue))."
            }
        case "complete":
//            if (modePlayed == "Easy" && score > easyHighscore) || (modePlayed == "Medium" && score > mediumHighscore) || (modePlayed == "Hard" && score > hardHighscore) {
//                gameOverLabel.text = "Diffused + New Highscore!"
//            } else if (modePlayed == "Easy" && score == easyHighscore) || (modePlayed == "Medium" && score == mediumHighscore) || (modePlayed == "Hard" && score == hardHighscore) {
//                gameOverLabel.text = "Diffused + Equalled Highscore!"
//            } else {
                gameOverLabel.text = "Diffused!"
//            }

            gameOverMessageLabel.text = "You've completed the game!"
        default:
            break
        }
    }
    
    func imageFromLabel(_ label: UILabel) {
        curtain = UIView(frame: CGRect(x: gameView.center.x - 25, y: 125, width: emojiLabel.frame.width, height: emojiLabel.frame.height))
        curtain.alpha = 1
        curtain.backgroundColor = .white
        curtain.center = emojiLabel.center
        
        gameView.addSubview(curtain)
        
        UIView.animate(withDuration: 0.15) {
            self.curtain.alpha = 0
        }
        
        UIGraphicsBeginImageContextWithOptions(label.bounds.size, false, UIScreen.main.scale)
        label.drawHierarchy(in: label.bounds, afterScreenUpdates: true)
        
        let emojiImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        emojiImageView.image = emojiImage?.withRenderingMode(.alwaysTemplate)
        emojiImageView.alpha = 1
        
        emojiImageView.center = emojiLabel.center
        emojiLabel.center = emojiImageView.center
    }

    func animateIn(_ view: UIView) {
        view.transform = CGAffineTransform.identity
        
        self.view.addSubview(view)
        view.center = self.view.center
        
        view.transform = CGAffineTransform.init(scaleX: 0.9, y: 0.9)
        view.alpha = 0
        
        UIView.animate(withDuration: 0.25) {
            view.alpha = 1
            view.transform = CGAffineTransform.identity
        }
    }
    
    func animateOut(_ view: UIView) {
        UIView.animate(withDuration: 0.25, animations: {
            view.transform = CGAffineTransform.init(scaleX: 0.9, y: 0.9)
            view.alpha = 0
        }) { (success: Bool) in
            view.transform = CGAffineTransform.identity
            view.removeFromSuperview()
        }
    }
    
    func fadeIn(_ view: UIView) {
        view.alpha = 0
        self.view.addSubview(view)
        UIView.animate(withDuration: 0.1) {
            view.alpha = 1
        }
    }
    
    func fadeOut(_ view: UIView) {
        view.alpha = 1
        self.view.addSubview(view)
        UIView.animate(withDuration: 0.1, animations: {
            view.alpha = 0
        }) { (success: Bool) in
            view.removeFromSuperview()
        }
    }
    
    func expandView(_ view: UIView, duration: TimeInterval) {
        view.transform = CGAffineTransform.identity
        view.alpha = 1
        
        UIView.animate(withDuration: duration) {
            view.transform = CGAffineTransform.init(scaleX: self.scaleNumber, y: self.scaleNumber)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration, execute: {
            UIView.animate(withDuration: 0.50, animations: {
                view.alpha = 0
            }, completion: { (success: Bool) in
                view.removeFromSuperview()
            })
        })
    }
    
    func playSound(_ name: String, fileExtension: String) {
        guard let url = Bundle.main.url(forResource: name, withExtension: fileExtension) else { return }
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
            
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func roundCornersOf(_ view: UIView, radius: CGFloat, shadows: Bool) {
        view.layer.cornerRadius = radius
        
        if shadows {
            view.backgroundColor = .white
            view.layer.shadowColor = UIColor.black.cgColor
            view.layer.shadowOpacity = 0.75
            view.layer.shadowOffset = .zero
            view.layer.shadowRadius = radius
            view.layer.shadowPath = UIBezierPath(rect: view.bounds).cgPath
        }
    }
    
    func presentWebsite(_ url: String) {
        if let website = URL(string: url) {
//            let config = SFSafariViewController.Configuration()
//            let vc = SFSafariViewController(url: website, configuration: config) // use if configuration needed
            
            let vc = SFSafariViewController(url: website)
            present(vc, animated: true)
        }
    }
    
    func presentApp(_ app: String, appId: Int) {
        isLoadingApp = true
        
        if app == "QuickTap" {
            qtButton.setTitle("Loading...", for: .normal)
            
            rateButton.isUserInteractionEnabled = false
            qtButton.isUserInteractionEnabled = false
            tcButton.isUserInteractionEnabled = false
        } else if app == "TempConv" {
            tcButton.setTitle("Loading...", for: .normal)
            
            rateButton.isUserInteractionEnabled = false
            qtButton.isUserInteractionEnabled = false
            tcButton.isUserInteractionEnabled = false
        } else {
            rateButton.setTitle("Loading...", for: .normal)
            
            rateButton.isUserInteractionEnabled = false
            qtButton.isUserInteractionEnabled = false
            tcButton.isUserInteractionEnabled = false
        }
        
        let storeVc = SKStoreProductViewController()
        storeVc.delegate = self
        
        let parameters = [SKStoreProductParameterITunesItemIdentifier: NSNumber(value: appId)]
        
        storeVc.loadProduct(withParameters: parameters, completionBlock: { (result, error) in
            self.isLoadingApp = false
            
            if result {
                self.present(storeVc, animated: true, completion: nil)
                
                if app == "QuickTap" {
                    self.qtButton.setTitle("QuickTap", for: .normal)
                } else if app == "TempConv" {
                    self.tcButton.setTitle("TempConv", for: .normal)
                } else {
                    self.rateButton.setTitle("Rate & Review", for: .normal)
                }
            } else {
                if let unwrappedError = error {
                    if app == "QuickTap" {
                        self.qtButton.setTitle("\(unwrappedError.localizedDescription)", for: .normal)
                        self.perform(#selector(ViewController.resetAppButtons), with: nil, afterDelay: 5)
                    } else if app == "TempConv" {
                        self.tcButton.setTitle("\(unwrappedError.localizedDescription)", for: .normal)
                        self.perform(#selector(ViewController.resetAppButtons), with: nil, afterDelay: 5)
                    } else {
                        self.rateButton.setTitle("\(unwrappedError.localizedDescription)", for: .normal)
                        self.perform(#selector(ViewController.resetAppButtons), with: nil, afterDelay: 5)
                    }
                }
            }
        })
    }
    
    @objc func resetAppButtons() {
        rateButton.isUserInteractionEnabled = true
        qtButton.isUserInteractionEnabled = true
        tcButton.isUserInteractionEnabled = true
        
        if rateButton.titleLabel?.text != "Rate & Review" || rateButton.titleLabel?.text != "Loading..." {
            rateButton.setTitle("Rate & Review", for: .normal)
        }
        
        if qtButton.titleLabel?.text != "QuickTap" || qtButton.titleLabel?.text != "Loading..." {
            qtButton.setTitle("QuickTap", for: .normal)
        }
        
        if tcButton.titleLabel?.text != "TempConv" || tcButton.titleLabel?.text != "Loading..." {
            tcButton.setTitle("TempConv", for: .normal)
        }
        
        NSObject.cancelPreviousPerformRequests(withTarget: self)
    }
    
    func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
        rateButton.isUserInteractionEnabled = true
        qtButton.isUserInteractionEnabled = true
        tcButton.isUserInteractionEnabled = true
        
        viewController.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Arrays of emojis
    
    let emojiArray = [
        "Letter": "✉",
        "Bags": "🛍",
        "Knife": "🔪",
        "Map": "🗺",
        "Pole": "💈",
        "Timer": "⌛",
        "Watch": "⌚",
        "Clock": "⏰",
        "Thermometer": "🌡",
        "Umbrella": "⛱",
        "Balloon": "🎈",
        "Ribbon": "🎀",
        "Radio": "📻",
        "Phone": "📱",
        "Telephone": "☎",
        "Battery": "🔋",
        "Computer": "💻",
        "Printer": "🖨",
        "Keyboard": "⌨",
        "Mouse": "🖱",
        "DVD": "📀",
        "Television": "📺",
        "Camera": "📷",
        "Candle": "🕯",
        "Lightbulb": "💡",
        "Flashlight": "🔦",
        "Book": "📖",
        "Newspaper": "📰",
        "Money": "💵",
        "Box": "📦",
        "Mailbox": "📪",
        "Pencil": "✏",
        "Pen": "🖊",
        "Folder": "📁",
        "Calendar": "📅",
        "Clipboard": "📋",
        "Ruler": "📏",
        "Lock": "🔒",
        "Key": "🔑",
        "Hammer": "🔨",
        "Shield": "🛡",
        "Telescope": "🔭",
        "Antenna": "📡",
        "Pill": "💊",
        "Door": "🚪",
        "Bed": "🛏",
        "Toilet": "🚽",
        "Shower": "🚿",
        "Bathtub": "🛁",
        "Coffin": "⚰"
    ]
    
    var usedEmojis = [[String: String]]()
    
    var iconIndex = Int()
    var key = String()
    var dictValue = String()
    var jumbledKey = String()
    var unjumbledAnswers = [String]()
    
}
