//
//  4.Interaction3ScreenView.swift
//  wwdc-2023-pinhao
//
//  Created by Camila Spolador on 11/04/23.
//
import Foundation
import SwiftUI
import SpriteKit

struct DispersalScreenView: View {
    @State var navigated = false
    
    var body: some View {
        
        VStack {
            NavigationLink(isActive: $navigated, destination: {
                GerminationScreenView()
            }) {
                EmptyView()
            }
            SpriteView(scene: DispersalScreen.buildScene(performNavigation: {
                navigated = true
            }))
        }
        .ignoresSafeArea()
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}
