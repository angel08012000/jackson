//
//  musicEditor.swift
//  jacksonyee
//
//  Created by 林湘羚 on 2021/1/12.
//

import SwiftUI
import UIKit


//把照片存起來
func saveImage(imageName: String, image: UIImage){
 guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }

    let fileName = imageName
    let fileURL = documentsDirectory.appendingPathComponent(fileName)
    guard let data = image.jpegData(compressionQuality: 1) else { return }

    //Checks if file exists, removes it if so.
    if FileManager.default.fileExists(atPath: fileURL.path) {
        do {
            try FileManager.default.removeItem(atPath: fileURL.path)
            print("Removed old image")
        } catch let removeError {
            print("couldn't remove file at path", removeError)
        }

    }

    do {
        try data.write(to: fileURL)
    } catch let error {
        print("error saving file with error", error)
    }

}

//載入照片
func loadImageFromDiskWith(fileName: String) -> UIImage? {

  let documentDirectory = FileManager.SearchPathDirectory.documentDirectory

    let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
    let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)

    if let dirPath = paths.first {
        let imageUrl = URL(fileURLWithPath: dirPath).appendingPathComponent(fileName)
        let image = UIImage(contentsOfFile: imageUrl.path)
        return image

    }

    return nil
}

//struct ShareSomething: UIViewControllerRepresentable{
//    //let controller = UIActivityViewController(activityItems: ["我最愛的老公", UIImage(named: "少年的你")!, URL(string: "http://apppeterpan.mystrikingly.com")!], applicationActivities: nil)
//}

struct ImagePickerController: UIViewControllerRepresentable {
    
    //儲存所選的照片
    @Binding var showSelectPhoto: Bool
    @Binding var selectImage: Image
    
    //回傳coordinator的實例
    func makeCoordinator() -> Coordinator {
        Coordinator(imagePickerController: self)
    }
    
    //coordinator的類別
    //為了當UIImagePickerController的delegate
    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            
        }
        
        
        internal init(imagePickerController:
        ImagePickerController) {
            self.imagePickerController = imagePickerController
        }

        let imagePickerController: ImagePickerController
        
        //選好照片後，回傳照片，且關閉相簿
        func imagePickerController(_ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info:
        [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                imagePickerController.selectImage = Image(uiImage:
            uiImage)
                saveImage(imageName: String(total), image: uiImage)
                print("total: \(total)")
//                total += 1
            }
            imagePickerController.showSelectPhoto = false
        }
    }
    
    //打開使用者的相簿
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    //初始化
    func makeUIViewController(context: Context) ->
    UIImagePickerController {
        let controller = UIImagePickerController()
        controller.sourceType = .photoLibrary
        controller.delegate = context.coordinator
        
        loadImageFromDiskWith(fileName: musicName[0])
        
        return controller
    }
    
    //當APP更動
    func updateUIViewController(_ uiViewController:
    UIImagePickerController, context: Context) {
        //當有變動的時候，saveImage到Document Direction
    }
    
    
}

//總共有幾筆料
var total = 0
var temp_now = 0

struct musicEditor: View {
    var musicsData: MusicsData
    var editMusicIndex: Int?
    
    @State private var name = ""
    @State private var description = ""
    @State private var score = true
    @State private var image = "home"
    @State private var num = 0
    @Binding var showEditMusic: Bool
    
    @State private var selectImage = Image("home")
    @State private var showSelectPhoto = false
    
    public var now = 0
    
    @State var items: [Any] = []
    @State var sheet = false
    
    func actionSheet() {
//        guard let data = URL(string: "https://www.apple.com") else { return }
        print("I'm in")
        guard let data = UIImage(named: "home") else { return }
        
        let av = UIActivityViewController(activityItems: [data], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
    }
    
    
    var body: some View {
        NavigationView{
            Form{
                HStack{
                    Spacer()
                    LinearGradient(gradient: Gradient(colors: [Color(red: 255/255, green: 192/255, blue: 203/255), Color(red: 176/255, green: 23/255, blue: 31/255)]), startPoint: .top, endPoint: .bottom)
                                    .mask(
                                        Text(name)
                                            .font(.system(size:30, design: .rounded))
                                            .fontWeight(.bold)
                                            .scaledToFit()
                                            .frame(width: 300, height: 200)
                                            .clipped()
                                    )
                                    .frame(width:200, height:70)
                    Spacer()
                }
                
                selectImage
                    .resizable()
                    .scaledToFill()
                    .frame(width: 300, height: 300)
                    .clipped()
                
                
                Button(action: {
                        //按下按鈕後，顯示相簿
                        showSelectPhoto = true
                    }) {
                        HStack {
                            Text("點我換照片")
                                .font(.headline)
                            Button(action: actionSheet) {
                                Image(systemName: "square.and.arrow.up")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 36, height: 36)
                            }
                        }
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50)
                        //.background(Color.white)
                        .foregroundColor(Color(red: 250/255, green: 128/255, blue: 114/255))
                        .cornerRadius(20)
                        .padding(.horizontal)
                    }.sheet(isPresented: $showSelectPhoto) {
                        ImagePickerController(showSelectPhoto:  self.$showSelectPhoto, selectImage: $selectImage)
                    }
                
                
                
                TextField("歌名", text: $name)
                TextField("心得", text: $description)
                Toggle("喜歡", isOn: $score)
            }
            //再次開啟時，照片來還在
            .onAppear(perform: {
                //num是照片的檔名
                if (now == -1){
                    selectImage = Image("home")
                }
                else if(loadImageFromDiskWith(fileName: String(num)) == nil){
                    selectImage = Image("home")
                }
                else{
                    selectImage = Image(uiImage: loadImageFromDiskWith(fileName: String(num))!)
                }
                
                
            })
            .navigationBarTitle(editMusicIndex == nil ? "新增歌曲" : "編輯歌曲")
            .toolbar(content: {
                ToolbarItem{
                    Button("儲存"){
                        let music = music_sturct(name: name, description: description, score: score, num: total)
                        if let editMusicIndex = editMusicIndex {
                            musicsData.musics[editMusicIndex] = music
                        }
                        else{
                            musicsData.musics.insert(music, at: 0)
                            showEditMusic = false
                        }
                        total += 1
                        
                        print("save already")
                    }
                }
            })
        }
        .onAppear(perform: {
            //print("index: \(editMusicIndex)")
            if let editMusicIndex = editMusicIndex{
                let editMusic = musicsData.musics[editMusicIndex]
                name = editMusic.name
                description = editMusic.description
                score = editMusic.score
                num = editMusic.num
            }
        })
        
    }
}

//struct musicEditor_Previews: PreviewProvider {
//    static var previews: some View {
//        musicEditor(musicsData: musicsData, editMusicIndex: 0, showEditMusic: true)
//    }
//}
