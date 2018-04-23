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
    @IBOutlet weak var emojiLabel: UILabel!
    @IBOutlet weak var emojiImageView: UIImageView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var hintButton: UIButton!
    
    @IBOutlet var gameOverView: UIView!
    @IBOutlet weak var gameOverLabel: UILabel!
    @IBOutlet weak var gameOverMessageLabel: UILabel!
    @IBOutlet weak var gameOverScoreLabel: UILabel!
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
    
    var appErrorLoaded = String()
    
    var isInitialLaunch = true
    var isInitalRotation = true
    
    // MARK: Override functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        roundCornersOf(easyButton, radius: easyButton.frame.height / 2, shadows: true)
        roundCornersOf(mediumButton, radius: mediumButton.frame.height / 2, shadows: true)
        roundCornersOf(hardButton, radius: hardButton.frame.height / 2, shadows: true)
        roundCornersOf(instructsButton, radius: instructsButton.frame.height / 2, shadows: true)
        roundCornersOf(moreButton, radius: moreButton.frame.height / 2, shadows: true)
        
        roundCornersOf(vabButton, radius: vabButton.frame.height / 2, shadows: false)
        roundCornersOf(shareButton, radius: shareButton.frame.height / 2, shadows: false)
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
        
        roundCornersOf(againButton, radius: againButton.frame.height / 2, shadows: false)
        roundCornersOf(menuButton, radius: menuButton.frame.height / 2, shadows: false)
        
        blurEffectView.frame = view.frame
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
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
        let textToShare = ["Hello! I love GuessingEmoji and I think you should check it out!\n\nGuessingEmoji tests your knowledge of the little symbols you encounter but ignore every day.\n\nCheck it out now on the iOS App Store!"]
        
        let activityVc = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityVc.popoverPresentationController?.sourceView = view
        
        present(activityVc, animated: true, completion: nil)
    }
    
    @IBAction func showSite(_ sender: Any) {
        presentWebsite("https://sites.google.com/view/attwelve/")
    }
    
    @IBAction func showPp(_ sender: Any) {
        presentWebsite("https://sites.google.com/view/attwelve/privacy-policy")
    }
    
    @IBAction func addMaView(_ sender: Any) {
        animateIn(maView)
        
        qtButton.isUserInteractionEnabled = true
        tcButton.isUserInteractionEnabled = true
    }
    
    @IBAction func showQt(_ sender: Any) {
        presentApp("QuickTap", appId: 1190851546)
    }
    
    @IBAction func showTc(_ sender: Any) {
        presentApp("TempConv", appId: 1163432921)
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
    }
    
    @IBAction func aGoBack(_ sender: Any) {
        animateOut(maView)
        animateOut(aboutView)
    }
    
    @IBAction func startGame(_ sender: Any) {
        easyButton.isUserInteractionEnabled = false
        mediumButton.isUserInteractionEnabled = false
        hardButton.isUserInteractionEnabled = false
        
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
    
    // MARK: Main functions
    
    @objc func changeVab() {
        vabButton.setTitle("Version & Build", for: .normal)
    }
    
    @objc func rotated() {
        print(view.frame)
        
        if view.frame.height > view.frame.width {
            scaleNumber = view.frame.height * 2 + 150
        } else {
            scaleNumber = view.frame.width * 2 + 150
        }
        
        blurEffectView.frame = view.frame
    
        if UIDevice.current.userInterfaceIdiom == .pad {
            if isInitialLaunch {
                isInitialLaunch = false
            } else {
                let screenSize = UIScreen.main.bounds.size
                
                if isInitalRotation {
                    print("isInitalRotation")
                    
                    if screenSize.width > screenSize.height { // landscape
                        print("ls")
                        instructsView.frame = CGRect(x: 20, y: 20, width: view.frame.height - 40, height: view.frame.width - 40)
                        moreView.frame = CGRect(x: 20, y: 20, width: view.frame.height - 40, height: view.frame.width - 40)
                        maView.frame = CGRect(x: 20, y: 20, width: view.frame.height - 40, height: view.frame.width - 40)
                        aboutView.frame = CGRect(x: 20, y: 20, width: view.frame.height - 40, height: view.frame.width - 40)
                        gameView.frame = CGRect(x: 20, y: 20, width: view.frame.height - 40, height: view.frame.width - 40)
                        gameOverView.frame = CGRect(x: 20, y: 20, width: view.frame.height - 40, height: view.frame.width - 40)
                    } else { // portrait
                        print("pt")
                        instructsView.frame = CGRect(x: 20, y: 20, width: view.frame.height - 40, height: view.frame.width - 40)
                        moreView.frame = CGRect(x: 20, y: 20, width: view.frame.height - 40, height: view.frame.width - 40)
                        maView.frame = CGRect(x: 20, y: 20, width: view.frame.height - 40, height: view.frame.width - 40)
                        aboutView.frame = CGRect(x: 20, y: 20, width: view.frame.height - 40, height: view.frame.width - 40)
                        gameView.frame = CGRect(x: 20, y: 20, width: view.frame.height - 40, height: view.frame.width - 40)
                        gameOverView.frame = CGRect(x: 20, y: 20, width: view.frame.height - 40, height: view.frame.width - 40)
                    }
                    
                    isInitalRotation = false
                } else {
                    if screenSize.width > screenSize.height { // landscape
                        print("ls")
                        instructsView.frame = CGRect(x: 20, y: 20, width: view.frame.height - 40, height: view.frame.width - 40)
                        moreView.frame = CGRect(x: 20, y: 20, width: view.frame.height - 40, height: view.frame.width - 40)
                        maView.frame = CGRect(x: 20, y: 20, width: view.frame.height - 40, height: view.frame.width - 40)
                        aboutView.frame = CGRect(x: 20, y: 20, width: view.frame.height - 40, height: view.frame.width - 40)
                        gameView.frame = CGRect(x: 20, y: 20, width: view.frame.height - 40, height: view.frame.width - 40)
                        gameOverView.frame = CGRect(x: 20, y: 20, width: view.frame.height - 40, height: view.frame.width - 40)
                    } else { // portrait
                        print("pt")
                        instructsView.frame = CGRect(x: 20, y: 20, width: view.frame.height - 40, height: view.frame.width - 40)
                        moreView.frame = CGRect(x: 20, y: 20, width: view.frame.height - 40, height: view.frame.width - 40)
                        maView.frame = CGRect(x: 20, y: 20, width: view.frame.height - 40, height: view.frame.width - 40)
                        aboutView.frame = CGRect(x: 20, y: 20, width: view.frame.height - 40, height: view.frame.width - 40)
                        gameView.frame = CGRect(x: 20, y: 20, width: view.frame.height - 40, height: view.frame.width - 40)
                        gameOverView.frame = CGRect(x: 20, y: 20, width: view.frame.height - 40, height: view.frame.width - 40)
                    }
                }
            }
        } else {
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
            
            instructsView.center = view.center
            moreView.center = view.center
            maView.center = view.center
            aboutView.center = view.center
            gameView.center = view.center
            gameOverView.center = view.center
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
        roundCornersOf(moreView, radius: 10, shadows: true)
        roundCornersOf(maView, radius: 10, shadows: false)
        roundCornersOf(aboutView, radius: 10, shadows: false)
        roundCornersOf(gameView, radius: 10, shadows: true)
        roundCornersOf(gameOverView, radius: 10, shadows: true)
    }
    
    func startGame(_ sender: UIButton) {
        view.addSubview(gameView)
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
        
        score = 0
        scoreLabel.text = "Score: \(score)"
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
            
            roundCornersOf(button, radius: 10, shadows: false)
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
            scoreLabel.text = "Score: \(score)"
            
            emojiLabel.alpha = 1
            
            stackView.removeAllArrangedSubviews()
            
            let label = UILabel(frame: CGRect(x: 10, y: gameView.center.y, width: 430, height: 30))
            label.backgroundColor = UIColor(red: 234/255, green: 195/255, blue: 97/255, alpha: 1)
            label.font = .systemFont(ofSize: 13)
            label.textColor = .black
            label.text = key
            label.textAlignment = .center
            roundCornersOf(label, radius: 10, shadows: false)
            label.clipsToBounds = true
            
            stackView.addArrangedSubview(label)
            
            emojiImageView.alpha = 0
            
            if score != 50{
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
            
            roundCornersOf(button, radius: 10, shadows: false)
            stackView.addArrangedSubview(button)
        }
    }
    
    @objc func locationChecker(_ button: UIButton, forEvent event: UIEvent) {
        guard let touch = event.allTouches?.first else { return }
        
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
    }
    
    func handleGameOver(_ method: String) {
        gameView.removeFromSuperview()
        
        roundCornersOf(gameOverView, radius: 10, shadows: true)
        gameOverView.center = view.center
        
        self.gameOverView.alpha = 0
        self.view.addSubview(self.gameOverView)
        
        UIView.animate(withDuration: 1.0, animations: {
            self.gameOverView.alpha = 1
        })
        
        gameOverScoreLabel.text = scoreLabel.text
        
        switch method {
        case "incorrect":
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.prepare()
            generator.impactOccurred()
            playSound("explosionSFX", fileExtension: ".mp3")
            gameOverLabel.text = "Game Over!"
            
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
            gameOverLabel.text = "Game Over!"
            
            if key == "DVD" {
                gameOverMessageLabel.text = "Timeout. It was \(key) (\(dictValue))."
            } else {
                gameOverMessageLabel.text = "Timeout. It was \(key.lowercased()) (\(dictValue))."
            }
        case "complete":
            gameOverLabel.text = "Diffused!"
            gameOverMessageLabel.text = "You've completed the game!"
        default:
            break
        }
    }
    
    func imageFromLabel(_ label: UILabel) {
        curtain = UIView(frame: CGRect(x: gameView.center.x - 25, y: 125, width: 50, height: 50))
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
        if app == "QuickTap" {
            qtButton.setTitle("Loading...", for: .normal)
            
            qtButton.isUserInteractionEnabled = false
            tcButton.isUserInteractionEnabled = false
        } else {
            tcButton.setTitle("Loading...", for: .normal)
            
            qtButton.isUserInteractionEnabled = false
            tcButton.isUserInteractionEnabled = false
        }
        
        let storeVc = SKStoreProductViewController()
        storeVc.delegate = self
        
        let parameters = [SKStoreProductParameterITunesItemIdentifier: NSNumber(value: appId)]
        
        
        storeVc.loadProduct(withParameters: parameters, completionBlock: { (result, error) in
            if result {
                self.present(storeVc, animated: true, completion: nil)
                
                if app == "QuickTap" {
                    self.qtButton.setTitle("QuickTap", for: .normal)
                    self.qtButton.isUserInteractionEnabled = true
                } else {
                    self.tcButton.setTitle("TempConv", for: .normal)
                    self.tcButton.isUserInteractionEnabled = true
                }
            } else {
                if let unwrappedError = error {
                    self.appErrorLoaded = app
                    if app == "QuickTap" {
                        self.tcButton.isUserInteractionEnabled = false
                        self.qtButton.setTitle("\(unwrappedError.localizedDescription)", for: .normal)
                        self.perform(#selector(ViewController.handleAppStoreError), with: nil, afterDelay: 5)
                    } else {
                        self.qtButton.isUserInteractionEnabled = false
                        self.tcButton.setTitle("\(unwrappedError.localizedDescription)", for: .normal)
                        self.perform(#selector(ViewController.handleAppStoreError), with: nil, afterDelay: 5)
                    }
                }
            }
        })
    }
    
    @objc func handleAppStoreError() {
        if appErrorLoaded == "QuickTap" {
            self.tcButton.isUserInteractionEnabled = true
            qtButton.setTitle("QuickTap", for: .normal)
        } else {
            self.qtButton.isUserInteractionEnabled = true
            tcButton.setTitle("TempConv", for: .normal)
        }
    }
    
    func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
        qtButton.isUserInteractionEnabled = true
        tcButton.isUserInteractionEnabled = true
        viewController.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Array of emojis
    
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
