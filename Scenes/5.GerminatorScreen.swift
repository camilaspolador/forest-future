//
//  4.GerminatorScreen.swift
//  wwdc-2023-pinhao
//
//  Created by Camila Spolador on 13/04/23.
//

import Foundation
import SpriteKit

class GerminationScreen: SKScene {
    let soundManager = SoundManager()
    var performNavigation: (() -> ())?
    static func buildScene(performNavigation: (() -> ())?) -> GerminationScreen {
        let scene = GerminationScreen(fileNamed: "5.GerminationScreen")!
        scene.performNavigation = performNavigation
        scene.scaleMode = .aspectFit
        return scene
    }
    
    var text1: SKSpriteNode!
    var substrate: SKSpriteNode!
    var seeds: SKSpriteNode!
    var water: SKSpriteNode!
    var germinator1: SKSpriteNode!
    var seedsBox: SKSpriteNode!
    var light: SKSpriteNode!
    var screen: SKShapeNode!
    var openButton: SKSpriteNode!
    var closeButton: SKSpriteNode!
    var germinationCard: SKSpriteNode!
    var closeCardButton: SKSpriteNode!
    var nextPageButton: SKSpriteNode!
    var firstArrow: SKSpriteNode!
    var lightArrow: SKSpriteNode!
    var screenArrow: SKSpriteNode!
    var doorArrow: SKSpriteNode!
    var thirdArrow: SKSpriteNode!
    
    var imageList: [SKSpriteNode]!
    var draggin: SKSpriteNode!
    var canTurnLightOn = false
    var canTouchScreen = false
    var canTouchOpen = false
    var canTouchClose = false
    var canDragSeedsPot = false
    var hasPressedPlay = false
    var canTouchNextButton = false
    var cantTouchClose = true
    
    override func didMove(to view: SKView) {
        
        text1 = childNode(withName: "text") as? SKSpriteNode
        substrate = childNode(withName: "substrate") as? SKSpriteNode
        seeds = childNode(withName: "seeds") as? SKSpriteNode
        water = childNode(withName: "waterbottle") as? SKSpriteNode
        germinator1 = childNode(withName: "germinator") as? SKSpriteNode
        seedsBox = childNode(withName: "seedsbox") as? SKSpriteNode
        light = childNode(withName: "light") as? SKSpriteNode
        screen = childNode(withName: "screen") as? SKShapeNode
        openButton = childNode(withName: "open") as? SKSpriteNode
        closeButton = childNode(withName: "close") as? SKSpriteNode
        germinationCard = childNode(withName: "germinationcard") as? SKSpriteNode
        closeCardButton = childNode(withName: "close button") as? SKSpriteNode
        nextPageButton = childNode(withName: "next page button") as? SKSpriteNode
        firstArrow = childNode(withName: "first arrow") as? SKSpriteNode
        screenArrow = childNode(withName: "arrow screen") as? SKSpriteNode
        doorArrow = childNode(withName: "arrow door") as? SKSpriteNode
        lightArrow = childNode(withName: "arrow light") as? SKSpriteNode
        thirdArrow = childNode(withName: "third arrow") as? SKSpriteNode
        
        firstArrow.isHidden = false
        screenArrow.isHidden = true
        lightArrow.isHidden = true
        doorArrow.isHidden = true
        thirdArrow.isHidden = true
        nextPageButton.isHidden = true
        imageList = [substrate]
        screen.alpha = 0
        
        text1.isHidden = true
        
        soundManager.playLoop(sound: .germinationsong)
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    func touchDown(atPoint pos : CGPoint) {
        
        if closeCardButton.contains(pos) && cantTouchClose {
            print("apertou no close")
            soundManager.play(sound: .buttons)
            closeCardButton.removeFromParent()
            germinationCard.removeFromParent()
            text1.isHidden = false
            cantTouchClose = false
            hasPressedPlay = true
            return
        }
        
        if !hasPressedPlay {
            return
        }
        
        for image in imageList {
            if image.contains(pos) {
                soundManager.play(sound: .texts)
                print("apertou na image \(image)")
                draggin = image
            }
        }
        
        if canTurnLightOn == true {
            if light.contains(pos) {
                soundManager.play(sound: .clickButton)
                germinator1.texture = SKTexture(imageNamed: "germinator LON Thigh")
                text1.texture = SKTexture(imageNamed: "germinator text5")
                light.texture = SKTexture(imageNamed: "light on")
                canTouchScreen = true
                canTurnLightOn = false
                lightArrow.isHidden = true
                screenArrow.isHidden = false
            }
        }
        
        if canTouchScreen == true {
            if screen.contains(pos) {
                soundManager.play(sound: .lightt)
                germinator1.texture = SKTexture(imageNamed: "germinator LON Tlow")
                text1.texture = SKTexture(imageNamed: "germinator text6")
                canTouchOpen = true
                canTouchScreen = false
                screenArrow.isHidden = true
                doorArrow.isHidden = false
            }
        }
        
        if canTouchOpen == true {
            if openButton.contains(pos) {
                soundManager.play(sound: .door)
                germinator1.texture = SKTexture(imageNamed: "germinatior opened")
                openButton.texture = SKTexture(imageNamed: "openbutton pressed")
                closeButton.texture = SKTexture(imageNamed: "closebutton")
                text1.texture = SKTexture(imageNamed: "germinator text7")
                imageList.append(seedsBox)
                canDragSeedsPot = true
                canTouchOpen = false
                doorArrow.isHidden = true
                thirdArrow.isHidden = false
            }
        }
        
        if canTouchClose == true {
            if closeButton.contains(pos) {
                soundManager.play(sound: .door)
                germinator1.texture = SKTexture(imageNamed: "germinatior with seeds closed")
                openButton.texture = SKTexture(imageNamed: "openbutton")
                closeButton.texture = SKTexture(imageNamed: "closebutton pressed")
                text1.texture = SKTexture(imageNamed: "germinator text9")
                canTouchClose = false
                nextPageButton.isHidden = false
                canTouchNextButton = true
                doorArrow.isHidden = true
            }
        }
        
        if nextPageButton.contains(pos) && canTouchNextButton {
            soundManager.play(sound: .texts)
            removeAllChildren()
            soundManager.stop(sound: .germinationsong)
            performNavigation?()
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
        print("soltou o touch")
        
        
        if seedsBox.contains(pos) {
            if draggin == substrate {
                seedsBox.texture = SKTexture(imageNamed: "Pote substrato")
                text1.texture = SKTexture(imageNamed: "germinator text2")
                substrate.removeFromParent()
                imageList.append(seeds)
                imageList.removeFirst()
                soundManager.play(sound: .subs)
            }
            
            if draggin == seeds {
                seedsBox.texture = SKTexture(imageNamed: "Pote sementes")
                text1.texture = SKTexture(imageNamed: "germinator text3")
                seeds.removeFromParent()
                imageList.append(water)
                imageList.removeFirst()
                soundManager.play(sound: .texts)
            }
            
            if draggin == water {
                seedsBox.texture = SKTexture(imageNamed: "Pote sementes com agua")
                text1.texture = SKTexture(imageNamed: "germinator text4")
                water.removeFromParent()
//                imageList.removeFirst()
                imageList.removeAll()
                canTurnLightOn = true
                firstArrow.isHidden = true
                lightArrow.isHidden = false
                soundManager.play(sound: .waterr)
            }
        }
        
       
            if germinator1.contains(pos) && canDragSeedsPot {
                if draggin == seedsBox {
                    germinator1.texture = SKTexture(imageNamed: "germinator with seeds opened")
                    text1.texture = SKTexture(imageNamed: "germinator text8")
                    seedsBox.removeFromParent()
                    imageList.removeAll()
                    canTouchClose = true
                    thirdArrow.isHidden = true
                    doorArrow.isHidden = false
                    soundManager.play(sound: .buttons)
                }
            }
        
        draggin = nil
    }
    
    func touchMoved(atPoint pos : CGPoint) {
        draggin?.position = pos
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(atPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
}
