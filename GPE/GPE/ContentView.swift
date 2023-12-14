//
//  ContentView.swift
//  GPE
//
//  Created by LorenzoSpinosa on 13/12/23.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
   
    var scene = SKScene(fileNamed : "MyScene.sks")!
    
    var body: some View {
      
        SpriteView(scene: scene)
            .ignoresSafeArea()
       
    }
}

struct ContentView_Preview : PreviewProvider{
    static var previews: some View {
        ContentView()
    }
    
}
