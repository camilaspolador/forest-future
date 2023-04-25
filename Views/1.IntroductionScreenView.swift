//
//  File.swift
//  
//
//  Created by Camila Spolador on 06/04/23.
//

import Foundation
import SwiftUI
import SpriteKit

struct IntroductionScreenView: View {
    @State var navigated = false
    
    var body: some View {
        
        VStack {
            NavigationLink(isActive: $navigated, destination: {
                TreePartsScreenView()
            }) {
                EmptyView()
            }
            SpriteView(scene: IntroductionScreen.buildScene(performNavigation: {
                navigated = true
            }))
        }
        .ignoresSafeArea()
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}
