//
//  5.Interaction4Screen.swift
//  wwdc-2023-pinhao
//
//  Created by Camila Spolador on 11/04/23.
//

import Foundation
import SpriteKit
import AVFoundation

class ForestScreen: SKScene {
    let soundManager = SoundManager()
    var performNavigation: (() -> ())?
    var animationFrame: Int = 1
    var passButton: SKSpriteNode!
    var forestCard: SKSpriteNode!
    var closeButton: SKSpriteNode!
    var gralha: SKSpriteNode!
    var hasPressedPlay: Bool = false
    var canTouchNextButton = false
    var textBackground: SKSpriteNode!
    
    private var animation: SKAction!
    
    weak var manager: ForestScreenManager?

    static func buildScene(performNavigation: (() -> ())?, frame: Float) -> ForestScreen {
        let scene = ForestScreen(fileNamed: "6.ForestScreen")!
        scene.performNavigation = performNavigation
        scene.scaleMode = .aspectFit
        scene.animationFrame = Int(frame)

        return scene
    }
    var landscape: SKSpriteNode!
    var textures = [SKTexture]()
    
    override func didMove(to view: SKView) {
        landscape = childNode(withName: "landscape") as? SKSpriteNode
        landscape.texture = SKTexture(imageNamed: "\(animationFrame)")
        
        passButton = childNode(withName: "pass_button") as? SKSpriteNode
        passButton.isHidden = true
        gralha = childNode(withName: "gralha") as? SKSpriteNode
        forestCard = childNode(withName: "forest card") as? SKSpriteNode
        closeButton = childNode(withName: "play button") as? SKSpriteNode
        textBackground = childNode(withName: "Slider text") as? SKSpriteNode
        
        textBackground.isHidden = true
        setupGralhaAnimation()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
        
    }
    
    func touchDown(atPoint pos : CGPoint) {
        
        if closeButton.contains(pos) {
            print("apertou no close")
            soundManager.play(sound: .buttons)
            closeButton.removeFromParent()
            forestCard.removeFromParent()
            textBackground.isHidden = false
            manager?.showSlider = true
        }
        
        if passButton.contains(pos) && canTouchNextButton {
            print("apertou no passar")
            soundManager.play(sound: .texts)
            soundManager.pause(sound: .forest)
            soundManager.pause(sound: .river)
            removeAllChildren()
            performNavigation?()
            print("leu a função")

        }
    }
    
    func setupGralhaAnimation(){
        
        print("animando gralha voando")
        
        var textures = [SKTexture]()
        
        textures.append(SKTexture(imageNamed: "gralha1"))
        textures.append(SKTexture(imageNamed: "gralha2"))
        textures.append(SKTexture(imageNamed: "gralha3"))
        textures.append(SKTexture(imageNamed: "gralha4"))
        textures.append(SKTexture(imageNamed: "gralha3"))
        textures.append(SKTexture(imageNamed: "gralha2"))
        
        let frames = SKAction.animate(with: textures, timePerFrame: 0.25, resize: true, restore: false)
        
        animation = SKAction.repeatForever(frames)
        gralha.run(animation)
    }
    
        
    func updateFrame(value: Float) {
        print("atualizou frame")
        landscape.texture = SKTexture(imageNamed: "\(Int(value))")
        
        if value >= 9 {
            soundManager.playLoop(sound: .river)
        }
        if value < 9 {
            soundManager.pause(sound: .river)
        }
        
        if value >= 30 {
            soundManager.playLoop(sound: .forest)
        }
        if value < 30 {
            soundManager.pause(sound: .forest)
        }
    
        if value == 59 {
            print("chamou o botão")
            passButton.isHidden = false
            canTouchNextButton = true
        }
        if value != 59 {
            passButton.isHidden = true
            return
        }
    }
}
