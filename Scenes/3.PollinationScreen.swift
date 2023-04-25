//
//  File.swift
//  
//
//  Created by Camila Spolador on 09/04/23.
//

import Foundation
import SpriteKit
import AVFoundation

class PollinationScreen: SKScene {
    let soundManager = SoundManager()
    var performNavigation: (() -> ())?
    static func buildScene(performNavigation: (() -> ())?) -> PollinationScreen {
        let scene = PollinationScreen(fileNamed: "3.PollinationScreen")!
        scene.performNavigation = performNavigation
        scene.scaleMode = .aspectFit
        
        print("carregando a cena da segunda interação")
        return scene
    }
    
    var blowDetector = BlowDetector(detectionThreshold: -9)
    var pollen: SKEmitterNode!
    var instructionsCard: SKSpriteNode!
    var closeButton: SKSpriteNode!
    var hasPressedPlay: Bool = false
    var circle: SKSpriteNode!
    var helpButton: SKSpriteNode!
    var nextButton: SKSpriteNode!
    var greatJob: SKSpriteNode!
    
    var counterFrame = 0
    
    var minVolume: Float = -30
    var maxVolume: Float = -10
    
    var counterTime = 0
    let timeLimit = 50
    
    var terminou = false
    var canTouchNextButton = false
    
    var finalPosition: CGFloat =  0
    var initialPosition: CGFloat = 0
    var step: CGFloat = 0

    override func didMove(to view: SKView) {
        blowDetector.startDetecting()
        pollen = childNode(withName: "polen") as? SKEmitterNode
        instructionsCard = childNode(withName: "pollination_card") as? SKSpriteNode
        closeButton = childNode(withName:"play_button") as? SKSpriteNode
        pollen.isHidden = true
        circle = childNode(withName: "circle") as? SKSpriteNode
        helpButton = childNode(withName: "blow_button") as? SKSpriteNode
        nextButton = childNode(withName: "next_page_button") as? SKSpriteNode
        greatJob = childNode(withName: "GreatJob") as? SKSpriteNode
        
        nextButton.isHidden = true
        greatJob.isHidden = true
        
        let finalCircle = childNode(withName: "circle2") as! SKSpriteNode
        
        finalCircle.alpha = 0
        
        initialPosition = circle.position.y
        finalPosition = finalCircle.position.y
        step = (finalPosition - initialPosition) / CGFloat (timeLimit)
        soundManager.playLoop(sound: .pollenn)

    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    func touchDown(atPoint pos : CGPoint) {
        
        if closeButton.contains(pos) {
            print("apertou no close")
            closeButton.removeFromParent()
            instructionsCard.removeFromParent()
            soundManager.stop(sound: .backgroundb)
            soundManager.play(sound: .buttons)
            hasPressedPlay = true
        }
        if nextButton.contains(pos) && canTouchNextButton {
            soundManager.play(sound: .buttons)
            soundManager.stop(sound: .pollenn)
            removeAllChildren()
            performNavigation?()

        }
        if helpButton.contains(pos) {
            let volume = Float.random(in: minVolume...maxVolume)
            dealWithVolume(receivedVolume: volume)
        }

    }
    
    override func update(_ currentTime: TimeInterval) {
        
        if !hasPressedPlay {
            return
        }
        
        // Diminuir a quantidade de usos do microfone
        if counterFrame <  10 {
            counterFrame += 1
            return
        }
        counterFrame = 0
        // 
        
        guard let blowVolume =  blowDetector.getVolume(threshold: minVolume) else {
            print("Sem barulho")
            pollen.particleBirthRate = 1
            return
        }
        
        dealWithVolume(receivedVolume: blowVolume)
    }
    
    func dealWithVolume(receivedVolume: Float) {
        var volume = min(receivedVolume, maxVolume)
        volume = volume + (0 - minVolume)
        volume = volume / (maxVolume - minVolume)
        
        print("Barulho detectado: " + receivedVolume.description)
        pollen.isHidden = false
        
        pollen.particleBirthRate = CGFloat(300 * volume)
        
        if terminou {
            return
        }
        
        counterTime = counterTime + 1
        
        circle.position.y += step
        
        if counterTime > timeLimit {
            // terminou
            terminou = true
        }
        let scaleUP = SKAction.scale(to: 1.2, duration: 0.8)
        let scaleDown = SKAction.scale(to: 0, duration: 0.8)
            
        let animation = SKAction.sequence([scaleUP,scaleDown])
        
        if terminou == true {
            canTouchNextButton = true
            nextButton.isHidden = false
            greatJob.isHidden = false
            greatJob.run(SKAction.repeat(animation, count: 1))
            soundManager.play(sound: .correct)
        }
    }
}
