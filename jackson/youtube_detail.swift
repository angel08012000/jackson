//
//  youtube_detail.swift
//  jacksonyee
//
//  Created by 林湘羚 on 2021/1/12.
//

import SwiftUI
import WebKit

struct webView: UIViewRepresentable{
    @State var url: String
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
            if let url = URL(string: "https://www.youtube.com/watch?v=\(url)") {
                let request = URLRequest(url: url)
                webView.load(request)
            }
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
    }
    
    typealias UIViewType = WKWebView
    
    
}

struct youtube_detail: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

//struct youtube_detail_Previews: PreviewProvider {
//    static var previews: some View {
//        webView()
//    }
//}
