//
//  HomeView.swift
//  PocketBox
//
//  Created by MBSoo on 2023/06/10.
//

import SwiftUI

struct HomeView: View {
    let cols = [GridItem(.adaptive(minimum: 100)),GridItem(.adaptive(minimum: 100)),GridItem(.adaptive(minimum: 100))]
    @State var openFile = false
    @State var showAlert = false
    @State var filename = ""
    @State var imageData = Data()
    @State var files: [String:URL] = [:]
    @State var file = File(statusCode: 0, responseMessage: "", data: FolderResponse())
    
    @State var registerFoler = false
    @State var folderName = ""
    @State var folders: [String] = []
    @ObservedObject var fileNetworking: FileViewModel
    @ObservedObject var userVM: UserViewModel
    var body: some View {
        VStack {
            HeaderView()
            HStack {
                Text("파일")
                    .font(.system(size: 17, weight: .bold, design: .rounded))
                Spacer()
                Button {
                    registerFoler = true
                } label: {
                    Image(systemName: "plus.rectangle.on.folder.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                }.alert("폴더의 이름을 적어주세요",isPresented: $registerFoler) {
                    TextField("이름", text: $folderName)
                        .border(.bar)
                    Button("취소", role: .destructive) {
                        Text("취소")
                    }
                    Button(role: .cancel) {
                        folders.append(folderName)
                    } label: {
                        Text("확인")
                    }

                }

            }.padding()
            HStack{
                TextField("", text: $filename)
                    .border(.black, width: 1)
                Button {
                    openFile = true
                } label: {
                    Image(systemName: "square.and.arrow.up")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.black)
                }.fileImporter(isPresented: $openFile, allowedContentTypes: [.image, .directory, .jpeg, .rawImage]) { result in
                    do {
                        print("Task start1")
                        
                        let fileURL = try result.get()
                        let url = try fileURL.asURL()
                        print(fileURL)
                        url.startAccessingSecurityScopedResource()
                        if let imageData = try? Data(contentsOf: url) {
                            self.imageData = imageData
                        }
                        files[self.filename] = url
                        fileNetworking.postFile(name: "병수", path: [], filename: filename)
                        print("Task  end")
                        
                        showAlert = true
                    } catch {
                        
                    }
        
                }.alert(isPresented: $showAlert) {
                    return Alert(title: Text("업로드 하시겠습니까?"), primaryButton: .default(Text("확인"), action: {
                        fileNetworking.uploadS3(fileURL: (files[filename] ?? URL(string: ""))!, filename: filename)
                    }), secondaryButton: .destructive(Text("취소")))
                }
                
            }
            HStack {
                ForEach(folders, id: \.self) { row in
                    NavigationLink {
                        FolderDetailView(fileNetworking: fileNetworking, folderName: row)
                    } label: {
                        VStack {
                            Image(systemName: "folder")
                                .resizable()
                                .frame(width: 80, height: 80)
                                .foregroundColor(.yellow.opacity(0.4))
                            Text("\(row)")
                        }
                    }.isDetailLink(false)
                }
            }
            LazyVGrid(columns: cols) {
                ForEach(files.keys.sorted(), id: \.self) { key in
                    VStack {
                        NavigationLink {
                            FileDetailView(key: key, image: imageData, url: files[key] ?? URL(filePath: ""))
                        } label: {
                            VStack {
                                Image("file")
                                    .resizable()
                                    .frame(width: 70, height: 70)
                                Text("\(key)")
                            }
                        }
                    }.padding()
                }
            }
            Spacer()
        }
    }
}

//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//    }
//}
