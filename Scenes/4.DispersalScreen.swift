//
//  4.Interaction3Screen.swift
//  wwdc-2023-pinhao
//
//  Created by Camila Spolador on 11/04/23.
//

import Foundation
import SpriteKit

class DispersalScreen: SKScene {
    let soundManager = SoundManager()
    var performNavigation: (() -> ())?
    static func buildScene(performNavigation: (() -> ())?) -> DispersalScreen {
        let scene = DispersalScreen(fileNamed: "4.DispersalScreen")!
        scene.performNavigation = performNavigation
        scene.scaleMode = .aspectFit
        return scene
    }
    
    var playButton: SKSpriteNode!
    var dispersalCard: SKSpriteNode!
    var gralha: SKSpriteNode!
    var nextPageButton: SKSpriteNode!
    var flyButton: SKSpriteNode!
    var completeCard: SKSpriteNode!
    private var animation: SKAction!
    var canTouchFly = true
    var canTouchNextButton = false
    var appearNextButton = 0
    
    override func didMove(to view: SKView) {
        
        playButton = childNode(withName: "play_button") as? SKSpriteNode
        dispersalCard = childNode(withName: "dispersal_card") as? SKSpriteNode
        gralha = childNode(withName: "gralha") as? SKSpriteNode
        nextPageButton = childNode(withName: "next page button") as? SKSpriteNode
        flyButton = childNode(withName: "fly button") as? SKSpriteNode
        completeCard = childNode(withName: "Card complete") as? SKSpriteNode
        
        completeCard.isHidden = true
        nextPageButton.isHidden = true
        setupBackgroundAnimation()
        
        soundManager.playLoop(sound: .forest)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    func touchDown(atPoint pos : CGPoint) {
   
        if playButton.contains(pos) {
            dispersalCard.isHidden = true
            playButton.isHidden = true
            soundManager.play(sound: .buttons)
        }
        
        if nextPageButton.contains(pos) && canTouchNextButton {
            soundManager.play(sound: .buttons)
            soundManager.stop(sound: .forest)
            removeAllChildren()
            performNavigation?()
        }
        if canTouchFly == true {
            if flyButton.contains(pos) {
                flyButton.texture = SKTexture(imageNamed: "WaitButton")
                setupGralhaAnimation()
                soundManager.play(sound: .wings)
                canTouchFly = false
            }
        }
    }
    
    var layers = [SKNode]()
    
    func setupBackgroundAnimation() {
        for i in 1...3 {
            let newLayer = setupLayer(i)
            newLayer.action(forKey: "fundo")?.speed = 0
            layers.append(newLayer)
        }
    }
    
    
    func setupLayer(_ layer: Int) -> SKNode {
        let sprite1 = SKSpriteNode(imageNamed: "background dispersion\(layer)")
        let sprite2 = SKSpriteNode(imageNamed: "background dispersion\(layer)")
        
        sprite1.setScale(1.2)
        sprite2.setScale(1.2)

        sprite2.position = CGPoint(x: sprite1.size.width - 2, y: 0)
        
        let layerNode = SKNode()
        layerNode.addChild(sprite1)
        layerNode.addChild(sprite2)
        
        layerNode.zPosition = CGFloat(layer)
        
        let moveLeft = SKAction.moveBy(x: -sprite1.size.width, y: 0, duration: TimeInterval(6 * (6 - layer)))
        let moveBack = SKAction.moveBy(x: sprite1.size.width - 2, y: 0, duration: 0)
        let sequence = SKAction.sequence([moveLeft, moveBack])
        let loop = SKAction.repeatForever(sequence)
        
        layerNode.run(loop, withKey: "fundo")
        
        self.addChild(layerNode)
        canTouchFly = true
        return layerNode
    }
    
    func setupGralhaAnimation(){
        
        unpauseLayers()
        
        print("animando gralha voando")
        
        let pinhao = SKSpriteNode(imageNamed: "pinhao")
        pinhao.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: pinhao.size.width, height: pinhao.size.height))
        
        var textures = [SKTexture]()
        
        textures.append(SKTexture(imageNamed: "gralha1"))
        textures.append(SKTexture(imageNamed: "gralha2"))
        textures.append(SKTexture(imageNamed: "gralha3"))
        textures.append(SKTexture(imageNamed: "gralha4"))
        textures.append(SKTexture(imageNamed: "gralha3"))
        textures.append(SKTexture(imageNamed: "gralha2"))
        
        let frames = SKAction.animate(with: textures, timePerFrame: 0.15, resize: true, restore: false)
        
        let scaleUP = SKAction.scale(to: 1.2, duration: 0.5)
        let scaleDown = SKAction.scale(to: 0, duration: 0.5)
            
        let animation1 = SKAction.sequence([scaleUP,scaleDown])
        
        animation = SKAction.repeat(frames, count: 2)
        gralha.addChild(pinhao)
        gralha.run(animation)  { [self] in
            print("tirou speed")
            self.pauseLayers()
            self.canTouchFly = true
            flyButton.texture = SKTexture(imageNamed: "FlyButton")
            self.appearNextButton += 1
            
            if self.appearNextButton == 7 {
                self.nextPageButton.isHidden = false
                self.canTouchNextButton = true
                self.completeCard.isHidden = false
                self.completeCard.run(SKAction.repeat(animation1, count: 1))
                self.soundManager.play(sound: .correct)
            }
        }
    }
    
    func pauseLayers() {
        for layer in layers {
            layer.action(forKey: "fundo")?.speed = 0
        }
    }
    
    func unpauseLayers() {
        for layer in layers {
            layer.action(forKey: "fundo")?.speed = 1
        }
    }
    
}
