//
//  File.swift
//  
//
//  Created by Camila Spolador on 06/04/23.
//

import Foundation
import SwiftUI
import SpriteKit

struct MenuScreenView: View {
    @EnvironmentObject var soundManager: SoundManager
    @State var navigated = false
    
    var body: some View {
        
        VStack {
            NavigationLink(isActive: $navigated, destination: {
                IntroductionScreenView()
            }) {
                EmptyView()
            }
            SpriteView(scene: MenuScreen.buildScene(performNavigation: {
                navigated = true
            }))
        }
        .ignoresSafeArea()
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            soundManager.playLoop(sound: .backgroundb)
            soundManager.stop(sound: .calm)
            soundManager.stop(sound: .forest)
            soundManager.stop(sound: .river)
        }
    }
}
