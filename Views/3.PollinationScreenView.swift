//
//  File.swift
//  
//
//  Created by Camila Spolador on 09/04/23.
//

import Foundation
import SwiftUI
import SpriteKit

struct PollinationScreenView: View {
    @EnvironmentObject var soundManager: SoundManager
    @State var navigated = false
    
    var body: some View {
        
        VStack {
            NavigationLink(isActive: $navigated, destination: {
                DispersalScreenView()
            }) {
                EmptyView()
            }
            SpriteView(scene: PollinationScreen.buildScene(performNavigation: {
                navigated = true
            }))
        }
        .ignoresSafeArea()
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            soundManager.stop(sound: .backgroundb)
        }
    }
}
