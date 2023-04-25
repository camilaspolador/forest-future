//
//  File.swift
//  
//
//  Created by Camila Spolador on 08/04/23.
//

import Foundation
import SpriteKit

class TheEndScreen: SKScene {
    let soundManager = SoundManager()
    var performNavigation: (() -> ())?
    static func buildScene(performNavigation: (() -> ())?) -> TheEndScreen {
        let scene = TheEndScreen(fileNamed: "7.TheEndScreen")!
        scene.performNavigation = performNavigation
        scene.scaleMode = .aspectFit
        
        print("carregando o fim")
        return scene
    }
    var endCharacter: SKSpriteNode!
    private var animation: SKAction!
    var menuButton: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        endCharacter = childNode(withName: "endcharacter") as? SKSpriteNode
        menuButton = childNode(withName: "lastbutton") as? SKSpriteNode
        
        print("entrou no did move")
        
        setupCharacterAnimation()
    }
    
    func setupCharacterAnimation(){
        
        print("animando personagem falando")
        
        var textures = [SKTexture]()
        
        textures.append(SKTexture(imageNamed: "happyTalking1"))
        textures.append(SKTexture(imageNamed: "happyTalking2"))
        textures.append(SKTexture(imageNamed: "happyTalking3"))
        textures.append(SKTexture(imageNamed: "happyTalking4"))
        
        let frames = SKAction.animate(with: textures, timePerFrame: 0.25, resize: true, restore: false)
        
        animation = SKAction.repeatForever(frames)
        endCharacter.run(animation)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
        
    }
    
    func touchDown(atPoint pos : CGPoint) {
        
        if menuButton.contains(pos) {
            soundManager.play(sound: .texts)
            removeAllChildren()
            performNavigation?()
        }
    }
}

