//
//  FileDetailView.swift
//  PocketBox
//
//  Created by MBSoo on 2023/06/12.
//

import SwiftUI

struct FileDetailView: View {
    var key: String
    var image: Data
    var url: URL
    @State var showAlert = false
    var body: some View {
        VStack {
            Image(uiImage: UIImage(data: image) ?? UIImage(ciImage: .black))
                .resizable()
                .scaledToFill()
                .frame(height: 200)
                .navigationTitle(Text("\(key)"))
                .navigationBarItems(trailing: Button {
                    let documentPath = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask)[0]
                    let finalPath = documentPath.appendingPathComponent(url.lastPathComponent)
                    do {
                        try FileManager.default.copyItem(at: url, to: finalPath)
                    } catch let error {
                        print(error)
                    }
                    showAlert = true
                } label: {
                    Image(systemName: "arrow.down.doc")
                }).alert(isPresented: $showAlert) {
                    Alert(title: Text("저장완료!"))
                }
        }.navigationViewStyle(.stack)
    }
}

//struct FileDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        FileDetailView(key: "")
//    }
//}
