//
//  File.swift
//  
//
//  Created by Camila Spolador on 06/04/23.
//

import Foundation
import SpriteKit

class MenuScreen: SKScene {
    let soundManager = SoundManager()
    
    var performNavigation: (() -> ())?
    static func buildScene(performNavigation: (() -> ())?) -> MenuScreen {
        let scene = MenuScreen(fileNamed: "0.MenuScreen")!
        scene.performNavigation = performNavigation
        scene.scaleMode = .aspectFit
        return scene
    }
    
    var playButton: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        playButton = childNode(withName: "play_button") as? SKSpriteNode
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    func touchDown(atPoint pos : CGPoint) {
   
        if playButton.contains(pos) {
            print("apertou no play")
            let scaleUP = SKAction.scale(to: 1.05, duration: 0.2)
            let animation = SKAction.sequence([scaleUP])
            playButton.run(SKAction.repeatForever(animation))
            
            soundManager.play(sound: .buttons)
            run(SKAction.wait(forDuration: TimeInterval(0.2))) {
                self.performNavigation?()
                self.removeAllChildren()
            }
            
        }
    }
}
