//
//  FolderDetailView.swift
//  PocketBox
//
//  Created by MBSoo on 2023/06/14.
//

import SwiftUI

struct FolderDetailView: View {
    @ObservedObject var fileNetworking: FileViewModel
    var folderName: String
    @State var filename = ""
    @State var openFile = false
    @State var showAlert = false
    @State var files:[String:URL] = [:]
    @State var imageData = Data()
    let cols = [GridItem(.adaptive(minimum: 100)),GridItem(.adaptive(minimum: 100)),GridItem(.adaptive(minimum: 100))]
    var body: some View {
        VStack {
            Text("\(folderName)")
                .font(.system(size: 25, weight: .bold, design: .rounded))
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
