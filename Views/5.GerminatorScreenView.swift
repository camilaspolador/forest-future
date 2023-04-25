//
//  4.GerminatorScreenView.swift
//  wwdc-2023-pinhao
//
//  Created by Camila Spolador on 13/04/23.
//

import Foundation
import SwiftUI
import SpriteKit

struct GerminationScreenView: View {
    @State var navigated = false
    
    var body: some View {
        
        VStack {
            NavigationLink(isActive: $navigated, destination: {
                ForestScreenView()
            }) {
                EmptyView()
            }
            SpriteView(scene: GerminationScreen.buildScene(performNavigation: {
                navigated = true
            }))
        }
        .ignoresSafeArea()
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}
