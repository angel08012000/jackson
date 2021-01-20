import SwiftUI
import AVFoundation

var musicName = ["MyBoo"]

var sentence = ["我們珍惜每一刻\n我們很少說話\n但常常微笑", "你保護世界\n我保護你"]
var role = ["韋一航", "小北"]

//ok
//照片的名字跟電影名稱相同
struct music_sturct: Identifiable, Codable{
    let id = UUID()
    var name: String
    var description: String
    var score: Bool
    var num: Int
}

//ok
//musics變動時會通知觀察MusicsData的view
class MusicsData: ObservableObject {
    @AppStorage("musics") var musicsData: Data?
    
    init() {
        if let musicsData = musicsData {
            let decoder = JSONDecoder()
            if let decodedData = try? decoder.decode([music_sturct].self, from: musicsData){
                musics = decodedData
            }
        }
    }
    
    @Published var musics = [music_sturct](){
        didSet{
            let encoder = JSONEncoder()
            do{
                let data = try encoder.encode(musics)
                musicsData = data
            } catch{
                
            }
        }
    }
}

struct MusicList: View{
    @StateObject var musicsData = MusicsData()
    @State private var showEditMusic = false
    @State private var searchText : String = ""
    
    @State private var role_img: String = "cute"
    @State private var text: String = "還喜歡我的哪首歌？\n快把它加到我的音樂吧～"
    @State private var role_name: String = "千璽"
    @GestureState private var longPressTap = false
    @State private var moveDistance: CGFloat = 500
    
    func speak(){
        let voice = AVSpeechSynthesisVoice(language: "zh-TW")
        let tosay = AVSpeechUtterance(string: text)
        tosay.voice = voice
        let spk = AVSpeechSynthesizer()
        spk.speak(tosay)
    }
    
    var body: some View {
        NavigationView{
            VStack{
                //SearchBar(text: $searchText)
                List{
                    ForEach(musicsData.musics.indices, id: \.self){ (index) in
                        NavigationLink(destination: musicEditor(musicsData: musicsData, editMusicIndex: index, showEditMusic: $showEditMusic, now: musicsData.musics[index].num)){
                            MusicRow(music: musicsData.musics[index])
                        }
                    }
                    .onDelete{ (indexSet) in
                        musicsData.musics.remove(atOffsets: indexSet)
                        
                    }
                }
                Spacer()
                HStack{
                    Image(role_img)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                    .padding()
                    VStack{
                        Text(text)
                        HStack{
                            Text("By \(role_name)")
                            Button(action: {
                                speak()
                            }){
                                Image(systemName: "headphones")
                            }
                        }
                    }
                    
                }
                .gesture(
                        LongPressGesture(minimumDuration: 1.0)
                            .updating($longPressTap, body: { (currentState, state, transaction) in
                                state = currentState
                                let random_index = Int.random(in: 0..<2)
                                role_img = role[random_index]
                                text = sentence[random_index]
                                role_name = role[random_index]
                                
                                print("")
                            })
                            .onEnded({ _ in
                                role_img = "cute"
                                text = "還喜歡我的哪首歌？\n快把它加到我的音樂吧～"
                                role_name = "千璽"
                            })
                    )
                .position(x: moveDistance, y:200)
                .onAppear(perform: {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                        withAnimation(Animation.linear(duration: 2)) {
                            moveDistance = 200
                        }
                    }
                })
                }
            
            
            .navigationTitle("我的音樂")
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showEditMusic = true
                    }){
                        Image(systemName: "plus.circle.fill")
                    }
                }
                
//                ToolbarItem(placement: .navigationBarLeading){
//                    EditButton()
//                }
            })
            .sheet(isPresented: $showEditMusic) {
                musicEditor(musicsData: musicsData, showEditMusic: $showEditMusic, now: -1)
            }
            
        }
    }
}

struct MusicRow: View{
    var music: music_sturct
    
    var body: some View {
        HStack{
            Text(music.name)
            Spacer()
            Image(systemName: music.score ? "heart.fill" : "heart").foregroundColor(Color(red: 240/255, green: 128/255, blue: 128/255))
        }
    }
}

struct music: View {
    
    var body: some View {
        VStack{
            MusicList()
        }
    }
}

struct music_Previews: PreviewProvider {
    static var previews: some View {
        music()
    }
}
