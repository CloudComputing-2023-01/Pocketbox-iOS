//
//  EditPostView.swift
//  PocketBox
//
//  Created by MBSoo on 2023/06/14.
//

import SwiftUI

struct EditPostView: View {
    let url = "http://pocketbox.shop/board/"
    @State var title = ""
    @State var content = ""
    @ObservedObject var postNetworking: PostViewModel
    @FocusState var isFocused: Bool
    @State var simpleResponse = Simpleresponse(statusCode: 0, responseMessage: "")
    var postId: Int
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
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
                        
                        Task {
                            do {
                                print("Task1")
                                simpleResponse = try await postNetworking.editPost(url: url, postId: postId, title: title, content:content)
                                postNetworking.posts = try await postNetworking.getPosts(url: url)
                            } catch {
                                print(error)
                            }
                        }
                        presentationMode.wrappedValue.dismiss()
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

//struct EditPostView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditPostView()
//    }
//}
