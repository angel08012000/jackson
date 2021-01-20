//
//  ContentView.swift
//  jackson
//
//  Created by 慈慈 on 2021/1/5.
//

import SwiftUI


struct ContentView: View {
    
    var body: some View {
        TabView{
//            .mask(Image("face")
//                .resizable()
//                .scaledToFit()
//                .frame(width: 400, height: 400)
//                    .offset(x:10, y:-20)
//            )
//            .shadow(radius: 30)
//            ins()
//                .tabItem{
//                    VStack{
//                        Image(systemName: "photo")
//                        Text("instagram")
//                    }
//                }
            music()
                .tabItem {
                    Image(systemName: "music.note")
                    Text("music")
                }
            
            youtube()
                .tabItem {
                    Image(systemName: "play.rectangle")
                    Text("youtube")
                }
        }.accentColor(Color(red: 240/255, green: 128/255, blue: 128/255))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
