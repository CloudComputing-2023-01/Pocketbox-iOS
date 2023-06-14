//
//  BoardDetailView.swift
//  PocketBox
//
//  Created by MBSoo on 2023/06/10.
//

import SwiftUI

let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    
    return formatter
}()

func StringToDate(stringDate: String)-> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"  //"2023-03-04T05:34:50"
    
    return dateFormatter.date(from: stringDate) ?? Date()
}

struct Simpleresponse: Codable {
    var statusCode: Int
    var responseMessage: String
    
    enum CodingKeys: CodingKey {
        case statusCode
        case responseMessage
    }
}

struct BoardDetailView: View {
    @StateObject var postNetworking: PostViewModel
    @State var postDetails: PostDetailContent = PostDetailContent(data: PostDetail(postId: 0, name: "", title: "", content: "", likeCount: 0, createdAt: "", updatedAt: "", commentDtoList: []))
    @State var isTapped = false
    @State var commentResponse = Simpleresponse(statusCode: 0, responseMessage: "")
    @State var showSheet = false
    @State var writeComment = false
    @State var comment = ""
    @State var post = PostDetail(postId: 0, name: "", title: "", content: "", likeCount: 0, createdAt: "", updatedAt: "")
    
    
    var postId: Int
    let boardurl = "http://pocketbox.shop/board"
    
    var body: some View {
        ScrollView {
            Text("\(postDetails.data.title)")
                .font(.system(size: 20, weight: .bold, design: .rounded))
            HStack {
                Spacer()
                Text("\(StringToDate(stringDate: postDetails.data.createdAt), formatter: dateFormatter)")
                    .font(.system(size: 10, weight: .light))
            }.padding(.horizontal)
            HStack {
                Spacer()
                Text("\(postDetails.data.name)")
                    .font(.system(size: 15, weight: .light))
            }
            .padding()
            HStack {
                Text(postDetails.data.content)
                    .multilineTextAlignment(.leading)
                Spacer()
            }.padding()
            HStack {
                Button {
                    postNetworking.likePost(url: boardurl, postId: postDetails.data.postId)
                    postNetworking.isTapped += 1
                    Task {
                        do {
                            print("Task1")
                            postDetails = try await postNetworking.getPostDetail(url: boardurl, postId: postId)
                        }
                    }
                    isTapped = true
                }label: {
                Image(systemName: isTapped ? "heart.fill" : "heart")
                    .foregroundColor(.pink)
                Text("\(postDetails.data.likeCount)")
                    
            }
            
            
            Spacer()
        }
        .padding()
        Rectangle().frame(height: 4).foregroundColor(.yellow.opacity(0.4))
        Section {
            HStack {
                if writeComment {
                    TextField("바른 댓글을 작성해주세요.", text: $comment)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.yellow,lineWidth: 1)
                        )
                        .onSubmit {
                            Task {
                                do {
                                    let simpleResponse: Simpleresponse = try await postNetworking.postComment(url: boardurl, postId: postId, content: comment)
                                    postDetails = try await postNetworking.getPostDetail(url: boardurl, postId: postId)
                                }
                            }
                            writeComment = false
                        }
                }
                Button {
                    writeComment.toggle()
                } label: {
                    Text(writeComment ? "취소" : "댓글 쓰기" )
                }
            }
            ForEach(postDetails.data.commentDtoList ?? [], id: \.commentId) { row in
                HStack {
                    Text("\(row.name)")
                    
                    Text("\(StringToDate(stringDate:row.createdAt), formatter: dateFormatter)")
                        .font(.system(size: 10, design: .rounded))
                    Spacer()
                    Button {
                        Task {
                            do {
                                let simpleResponse: Simpleresponse = try await postNetworking.deleteComment(url: boardurl, commentId: row.commentId)
                                postDetails = try await postNetworking.getPostDetail(url: boardurl, postId: postId)
                            }
                        }
                    } label: {
                        Image(systemName: "x.circle.fill")
                            .foregroundColor(.black)
                    }

                }.padding(.horizontal)
                Text(row.content)
            }.padding()
        }
        Spacer()
            .navigationBarItems(trailing: Button(action: {
                showSheet = true
            }, label: {
                Text("게시물 수정")
            }).sheet(isPresented: $showSheet, content: {
                EditPostView(postNetworking: postNetworking, postId: postId)
            }))
        
    }
        .task {
            do {
                postDetails = try await postNetworking.getPostDetail(url: boardurl, postId: postId)
                postNetworking.postDetail = postDetails.data
                print(postDetails.data)
                print(postNetworking.postDetail ?? "")
            } catch {
                print(error)
                print("error, detailView")
            }
        }
}
}

//struct BoardDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        BoardDetailView()
//    }
//}
