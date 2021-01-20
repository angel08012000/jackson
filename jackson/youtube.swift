//
//  youtube.swift
//  jackson
//
//  Created by 慈慈 on 2021/1/5.
//

import SwiftUI
import Foundation
import URLImage

//SearchBar
struct SearchBar: UIViewRepresentable {

    @Binding var text: String

    //當text被輸入，把text設成輸入的字
    class Coordinator: NSObject, UISearchBarDelegate {

        @Binding var text: String

        init(text: Binding<String>) {
            _text = text
        }

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
        }
    }

    func makeCoordinator() -> SearchBar.Coordinator {
        return Coordinator(text: $text)
    }

    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        searchBar.searchBarStyle = .minimal
        searchBar.autocapitalizationType = .none
        return searchBar
    }

    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
        uiView.text = text
    }
}

struct you: Codable{
    let items: [you_items]
}

struct temp_1: Codable{
    let medium : temp_2
}

struct temp_2: Codable{
    let url: URL
}


struct you_items: Codable, Hashable{
    let snippet : you_title
    let contentDetails : you_add
}

struct you_title: Codable, Hashable{
    
    static func == (lhs: you_title, rhs: you_title) -> Bool {
        return lhs.title == rhs.title
    }
    
    func hash(into hasher: inout Hasher) {
          hasher.combine(title)
       }
    
    let title : String
    let thumbnails : temp_1
}

struct you_add: Codable, Hashable{
    let videoId: String
}

struct youtube: View {
    
    @State var YoutubeData = you(items: [])
    
    @State var you_pic = Image("home")
    
    @State private var image = Image(systemName: "heart.fill")
    @State private var getImage = false
    
    @State private var searchText : String = ""
    @State private var img_total = 0
    var img_list = [Image]()
    
    func getPic(url: URL){
        if let data = try? Data(contentsOf: url),
           let uiImage = UIImage(data: data){
            you_pic = Image(uiImage: uiImage)
        }
    }
    
    func getYoutube(){
        let urlStr = "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet,contentDetails,status&playlistId=UUCCHj7PB8LbWbqhRmIDYLIw&key=AIzaSyCub5xFjlck0Rd5frQ0_p96hgmfuGASYDU&maxResults=30"
        if let url = URL(string: urlStr){
            URLSession.shared.dataTask(with: url) { (data, response , error) in
                
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                if let data = data{
                    do{
                        //print("in")
                        YoutubeData = try decoder.decode(you.self, from: data)
                        print("title: \(YoutubeData.items[0].snippet.title)")
                        print("img: \(YoutubeData.items[0].snippet.thumbnails.medium)")
//                        you_title = you_data.items[0].snippet.title
//                        you_url = you_data.items[0].contentDetails.videoId
                    }
                    catch{
                        print("error")
                    }
                }
                else{
                    print("error")
                }
            }.resume()
        }
    }
    
    var body: some View {
        
        NavigationView{
            VStack{
                SearchBar(text: $searchText)
                List{
                    //ForEach的range是固定的，若要用動態的需要加入id
                    ForEach(self.YoutubeData.items.filter {
                        self.searchText.isEmpty ? true : $0.snippet.title.contains(self.searchText)
                    }, id:\.self){ (item) in
                        
                        NavigationLink(destination: webView(url: item.contentDetails.videoId)){
                            HStack{
                                //getPic(url: YoutubeData.items[index].snippet.thumbnails.medium.url)
                                
                                URLImage(url: item.snippet.thumbnails.medium.url) { (image)  in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 80, height: 45)
                                    .clipped()
                                
                               }
                                Text(item.snippet.title)
                            }
                        }
                    }
                }.navigationBarTitle(Text("粉絲自製YT頻道"))
            }.onAppear(perform: {
                getYoutube()
            })
        }
    }
}

struct youtube_Previews: PreviewProvider {
    static var previews: some View {
        youtube()
    }
}
