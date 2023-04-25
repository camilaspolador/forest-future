//
//  File.swift
//  
//
//  Created by Camila Spolador on 06/04/23.
//

import Foundation
import SpriteKit

class IntroductionScreen: SKScene {
    let soundManager = SoundManager()
    var performNavigation: (() -> ())?
    static func buildScene(performNavigation: (() -> ())?) -> IntroductionScreen {
        let scene = IntroductionScreen(fileNamed: "1.IntroductionScreen")!
        scene.performNavigation = performNavigation
        scene.scaleMode = .aspectFit
        
        print("carregando a cena introduction")
        return scene
    }
    
    var button: SKSpriteNode!
    var card: SKSpriteNode!
    var character: SKSpriteNode!
    private var animation: SKAction!
    var dialogues: [Dialogue] = [
        Dialogue(imageUrl: "Card2"),
        Dialogue(imageUrl: "Card3"),
        Dialogue(imageUrl: "Card4")
    ]
    
    // Primeira função que o programa chama quando carrega a cena
    override func didMove(to view: SKView) {
        print("entrou no did move")
        button = childNode(withName: "button") as? SKSpriteNode
        card = childNode(withName: "main_card") as? SKSpriteNode
        character = childNode(withName: "alex") as? SKSpriteNode

        setupCharacterAnimation()
    }
    
    func setupCharacterAnimation(){
        
        print("animando personagem falando")
        
        var textures = [SKTexture]()
        
        textures.append(SKTexture(imageNamed: "seriousTalking1"))
        textures.append(SKTexture(imageNamed: "seriousTalking2"))
        textures.append(SKTexture(imageNamed: "seriousTalking3"))
        textures.append(SKTexture(imageNamed: "seriousTalking4"))
        
        let frames = SKAction.animate(with: textures, timePerFrame: 0.25, resize: true, restore: false)
        
        animation = SKAction.repeatForever(frames)
        character.run(animation)

    }
    
    func setupNextDialogue() {
        if dialogues.count >= 1 {
            let dialogue = dialogues.removeFirst()
            
            card.run(.setTexture(SKTexture(imageNamed: dialogue.imageUrl), resize: true))
            soundManager.play(sound: .texts)
            
        } else if dialogues.count == 0 {
            soundManager.play(sound: .texts)
            removeAllChildren()
            performNavigation?()
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    func touchDown(atPoint pos : CGPoint) {
   
        if button.contains(pos) {
            setupNextDialogue()
        }
    }
    
    
}

struct Dialogue {
    var imageUrl: String
}
