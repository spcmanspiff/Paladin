//
//  TabView.swift
//  Paladin
//
//  Created by Brad Scott on 9/30/20.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            SpellView()
                .tabItem {
                    Image(systemName: "wand.and.stars")
                    Text("Spells")
                    
                }
            ClassView()
                .tabItem {
                    Image(systemName: "waveform.path.ecg")
                       
                    Text("Class")
                }
        }
    
    
    }
}

struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
