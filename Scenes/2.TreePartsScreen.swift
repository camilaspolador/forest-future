//
//  SwiftUIView.swift
//  
//
//  Created by Camila Spolador on 07/04/23.
//

import Foundation
import SpriteKit
import AVFoundation

class TreePartsScreen: SKScene {
    let soundManager = SoundManager()
    var performNavigation: (() -> ())?
    static func buildScene(performNavigation: (() -> ())?) -> TreePartsScreen {
        let scene = TreePartsScreen(fileNamed: "2.TreePartsScreen")!
        scene.performNavigation = performNavigation
        scene.scaleMode = .aspectFit
        
        print("carregando a cena da primeira interação")
        return scene
    }
    
    var closeButton: SKSpriteNode!
    var textBox: SKSpriteNode!
    var nextPageButton: SKSpriteNode!
    
    var treetopDefinition: SKSpriteNode!
    var treetrunkDefinition: SKSpriteNode!
    var seedDefinition: SKSpriteNode!
    var closeCardsButton: SKSpriteNode!
    
    var topAraucaria: SKSpriteNode!
    var trunkAraucaria: SKSpriteNode!
    var seedsAraucaria: SKSpriteNode!
    var groundAraucaria: SKSpriteNode!
    
    var topDot: SKSpriteNode!
    var trunkDot: SKSpriteNode!
    var seedsDot: SKSpriteNode!
    var hitBoxTop: SKShapeNode!
    var hitBoxTrunk: SKShapeNode!
    var hitBoxSeeds: SKShapeNode!

    var hasPressedPlay: Bool = false
    var hasOpenedTop: Bool = false
    var hasOpenedTrunk: Bool = false
    var hasOpenedSeeds: Bool = false
    var canTouchNextButton = false
    
    var draggin: SKSpriteNode!
    var zTop: CGFloat = 1
    var idealHeight: CGFloat!
    var imageList: [SKSpriteNode]!
    
    override func didMove(to view: SKView) {
        closeButton = childNode(withName: "Button_close") as? SKSpriteNode
        textBox = childNode(withName: "Text_box") as? SKSpriteNode
        nextPageButton = childNode(withName: "Button_pass_interaction") as? SKSpriteNode
        
        treetopDefinition = childNode(withName: "Treetop_definition") as? SKSpriteNode
        treetrunkDefinition = childNode(withName: "Treetrunk_definition") as? SKSpriteNode
        seedDefinition = childNode(withName: "Seeds_definition") as? SKSpriteNode
        closeCardsButton = childNode(withName: "Close_button") as? SKSpriteNode
        
        hideObjects()
        
        topAraucaria = childNode(withName: "Top_araucaria") as? SKSpriteNode
        trunkAraucaria = childNode(withName: "Trunk_araucaria") as? SKSpriteNode
        seedsAraucaria = childNode(withName: "seedsbutton") as? SKSpriteNode
        groundAraucaria = childNode(withName: "Ground_araucaria") as? SKSpriteNode
        
        topDot = childNode(withName: "topdot") as? SKSpriteNode
        trunkDot = childNode(withName: "trunkdot") as? SKSpriteNode
        seedsDot = childNode(withName: "seedsdot") as? SKSpriteNode
        hitBoxTop = childNode(withName: "hitboxtop") as? SKShapeNode
        hitBoxSeeds = childNode(withName: "hitboxseeds") as? SKShapeNode
        hitBoxTrunk = childNode(withName: "hitboxtrunk") as? SKShapeNode

        imageList = [topAraucaria, trunkAraucaria, seedsAraucaria]
        
        nextPageButton.isHidden = true
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    func touchDown(atPoint pos : CGPoint) {
   
        if closeButton.contains(pos) {
            print("apertou no close")
            closeButton.removeFromParent()
            textBox.removeFromParent()
            hasPressedPlay = true
        }
        
//      Esse if faz com que o restante do código não aconteça se hasPressedPlay = false
        if !hasPressedPlay {
            return
        }
        
        for image in imageList {
            if image.contains(pos) {
                draggin = image
                soundManager.play(sound: .texts)
                return
            }
        }
        
        if closeCardsButton.contains(pos){
            soundManager.play(sound: .buttons)
            hideObjects()
            showNextPageButton()
            return
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
        print("soltou o touch")
        
        if hitBoxSeeds.contains(pos){
            if draggin == seedsAraucaria {
                seedDefinition.isHidden = false
                closeCardsButton.isHidden = false
                draggin.position = seedsDot.position
                hasOpenedSeeds = true
                soundManager.play(sound: .correct)
                imageList.removeAll { node in
                    node == seedsAraucaria
                }
            }
        }
        if hitBoxTop.contains(pos){
            if draggin == topAraucaria {
                treetopDefinition.isHidden = false
                closeCardsButton.isHidden = false
                draggin.position = topDot.position
                hasOpenedTop = true
                soundManager.play(sound: .correct)
                imageList.removeAll { node in
                    node == topAraucaria
                }
            }
        }
        
        if hitBoxTrunk.contains(pos){
            if draggin == trunkAraucaria {
                treetrunkDefinition.isHidden = false
                closeCardsButton.isHidden = false
                draggin.position = trunkDot.position
                hasOpenedTrunk = true
                soundManager.play(sound: .correct)
                imageList.removeAll { node in
                    node == trunkAraucaria
                }
            }
        }
                if nextPageButton.contains(pos) && canTouchNextButton {
                    soundManager.play(sound: .buttons)
                    removeAllChildren()
                    performNavigation?()
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

    
    func hideObjects(){
        treetopDefinition.isHidden = true
        treetrunkDefinition.isHidden = true
        seedDefinition.isHidden = true
        closeCardsButton.isHidden = true
    }
    
    func showNextPageButton () {
        print("show next page button")
        print("hasOpenedTop: " + hasOpenedTop.description)
        print("hasOpenedTrunk: " + hasOpenedTrunk.description)
        print("hasOpenedSeeds: " + hasOpenedSeeds.description)
        
        if !hasOpenedTop || !hasOpenedSeeds || !hasOpenedTrunk {
            return
        }
        nextPageButton.isHidden = false
        canTouchNextButton = true
    }
}
