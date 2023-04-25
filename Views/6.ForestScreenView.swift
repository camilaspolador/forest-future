//
//  File.swift
//  
//
//  Created by Camila Spolador on 11/04/23.
//

import Foundation
import SwiftUI
import SpriteKit

class ForestScreenManager: ObservableObject {
    var scene = ForestScreen.buildScene(performNavigation: nil, frame: 1)
    @Published var showSlider = false
    
    func updateScene(value: Float) {
        scene.updateFrame(value: value)
    }
}

struct ForestScreenView: View {
    @State var navigated = false
    @State var value: Float = 1
    @State var isEditing = false
    
    @StateObject var manager = ForestScreenManager()
    @EnvironmentObject var soundManager: SoundManager
    
    
    var body: some View {
        ZStack {
            NavigationLink(isActive: $navigated, destination: {
                TheEndScreenView()
            }) {
                EmptyView()
            }
            SpriteView(scene: manager.scene)
                .onChange(of: value) { newValue in
                    manager.updateScene(value: newValue)
                }
                .overlay(alignment: .bottom, content: {
                    if manager.showSlider {
                        Slider(
                            value: $value,
                            in: 1...59,
                            step: 1
                        )
                        .accentColor(.gray)
                        .padding(50)
                        .tint(.green)
                        .frame(width: 800)
                    }
                })
                .onAppear {
                    manager.scene.manager = manager
                }
        }
        .ignoresSafeArea()
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            soundManager.playLoop(sound: .calm)
            manager.scene.performNavigation = {
                navigated = true
            }
        }
    }
}
