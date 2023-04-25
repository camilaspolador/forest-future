//
//  SwiftUIView.swift
//  
//
//  Created by Camila Spolador on 07/04/23.
//

import Foundation
import SwiftUI
import SpriteKit

struct TreePartsScreenView: View {
    @State var navigated = false
    
    var body: some View {
        
        VStack {
            NavigationLink(isActive: $navigated, destination: {
                PollinationScreenView()
            }) {
                EmptyView()
            }
            SpriteView(scene: TreePartsScreen.buildScene(performNavigation: {
                navigated = true
            }))
        }
        .ignoresSafeArea()
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}
