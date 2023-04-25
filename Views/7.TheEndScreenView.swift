//
//  File.swift
//  
//
//  Created by Camila Spolador on 08/04/23.
//

import Foundation
import SwiftUI
import SpriteKit

struct TheEndScreenView: View {
    @EnvironmentObject var soundManager: SoundManager
    @State var navigated = false
    
    var body: some View {
        
        VStack {
            NavigationLink(isActive: $navigated, destination: {
                MenuScreenView()
            }) {
                EmptyView()
            }
            SpriteView(scene: TheEndScreen.buildScene(performNavigation: {
                navigated = true
            }))
            
        }
        .ignoresSafeArea()
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

