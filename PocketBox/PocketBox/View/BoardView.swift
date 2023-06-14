//
//  BoardView.swift
//  PocketBox
//
//  Created by MBSoo on 2023/06/10.
//

import SwiftUI

struct BoardView: View {
    @ObservedObject var postNetworking: PostViewModel
    @Binding var posts: [PostDetail]
    
    let cols = [GridItem(.flexible())]
    let url = "http://pocketbox.shop/board/post"
    @State var showSheet = false
    var body: some View {
        ScrollView {
            HeaderView()
            HStack {
                Text("게시판")
                    .font(.system(size: 17, weight: .bold, design: .rounded))
                Spacer()
                Button {
                    showSheet = true
                } label: {
                    Image(systemName: "square.and.pencil")
                        .resizable()
                        .frame(width: 40, height: 40)
                }.sheet(isPresented: $showSheet) {
                    WritePostView(postNetworking: postNetworking)
                }
            }.padding()
           

            LazyVGrid(columns: cols) {
                ForEach(postNetworking.posts?.data ?? [], id:\.self) { col in
                    NavigationLink {
                        BoardDetailView(postNetworking: postNetworking, postId: col.postId)
                    } label: {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(Color.yellow.opacity(0.5))
                            .overlay(
                                VStack {
                                    Text("\(col.title)")
                                        .font(.system(size: 20, weight: .bold, design: .rounded))
                                    HStack {
                                        Spacer()
                                        Text("\(StringToDate(stringDate:col.createdAt), formatter: dateFormatter)")
                                            .font(.system(size: 10, weight: .light))
                                    }
                                    Spacer()
                                    HStack {
                                        Text("\(col.content)").truncationMode(.tail)
                                        Spacer()
                                    }.padding()
                                    Spacer()
                                    HStack {
                                        Image(systemName: "heart.fill").foregroundColor(.pink)
                                        Text("\(col.likeCount)")
                                        Spacer()
                                        Text("\(col.name)")
                                            .font(.system(size: 10, weight: .light))
                                    }.padding(.horizontal)
                                }.foregroundColor(.black)
                                    .padding()
                            )
                            .frame(height: 200)
                            
                    }


                }
            }
            Spacer()
        }
    }
}

//struct BoardView_Previews: PreviewProvider {
//    static var previews: some View {
//        BoardView()
//    }
//}
