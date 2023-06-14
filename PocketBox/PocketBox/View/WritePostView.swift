//
//  WritePostView.swift
//  PocketBox
//
//  Created by MBSoo on 2023/06/12.
//

import SwiftUI

struct WritePostView: View {
    let url = "http://pocketbox.shop/board/post"
    @State var title = ""
    @State var content = ""
    @ObservedObject var postNetworking: PostViewModel
    @FocusState var isFocused: Bool
    
    
    var body: some View {
        ScrollView {
            Spacer()
                .frame(height: 200)
            
            Section  {
                Text("제목을 입력해주세요")
                    .font(.system(size: 17, weight: .bold))
                TextField("제목", text: $title)
                    .border(.yellow.opacity(0.4))
                Text("내용을 입력해주세요.")
                    .font(.system(size: 17, weight: .bold))
                TextEditor(text: $content)
                    .border(.yellow.opacity(0.4))
                    .focused($isFocused)
                    .ignoresSafeArea(.keyboard, edges: .bottom)
                    .frame(height: 350)
                HStack(alignment: .center) {
                    Spacer()
                    Button {
                        postNetworking.postPost(url: url, title: title, content: content)
                        Task {
                            do {
                                postNetworking.posts = try await postNetworking.getPosts(url: "http://pocketbox.shop/board")
                            }
                        }
                    } label: {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 80, height: 40)
                            .foregroundColor(.yellow.opacity(0.4))
                            .overlay(
                                Text("작성완료")
                                    .foregroundColor(.black)
                            )
                    }
                    Spacer()
                }
            }.padding()
            Spacer()
        }
        .onTapGesture {
            isFocused = false
        }
    }
}

//struct WritePostView_Previews: PreviewProvider {
//    static var previews: some View {
//        WritePostView(postNetworking: PostViewModel())
//    }
//}
