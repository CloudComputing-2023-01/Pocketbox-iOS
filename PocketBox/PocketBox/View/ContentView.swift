//
//  ContentView.swift
//  PocketBox
//
//  Created by MBSoo on 2023/06/10.
//

import SwiftUI

struct ContentView: View {
    let boardurl = "http://pocketbox.shop/board"
    let fileurl = "http://pocketbox.shop/folder"
    let mypageurl = "http://pocketbox.shop/user"
    
    
    @State var postDetail: Post = Post(statusCode: 0, responseMessage: "")
    @State var posts: [PostDetail] = []
    @State var userDetail: UserData = UserData(statusCode: 0, responseMessage: "", data: User())
    @State var folder: Folder = Folder(statusCode: 0, responseMessage: "", data: FolderResponse())
    @StateObject var postNetworking = PostViewModel()
    @StateObject var fileNetworking = FileViewModel()
    @ObservedObject var userVM = UserViewModel()
    var body: some View {
        NavigationView {
            if (UserDefaultsManager.shared.getTokens().accessToken == "" ) {
                SignUpView(userVM: userVM)
            } else {
                TabBar(posts: $posts, postNetworking: postNetworking, userVM: userVM, fileNetworking: fileNetworking)
            }
        }.padding(.horizontal)
        .navigationViewStyle(.stack)
        .task {
            do {
                postDetail = try await postNetworking.getPosts(url: boardurl)
                userDetail = try await userVM.getUserInfo()
                folder = try await fileNetworking.getFolder(name: userDetail.data.name ?? "병수", path: [])
//                print(userDetail.data)
                postNetworking.posts = postDetail
                userVM.userDetail = userDetail.data
                print(fileNetworking.folder)
                print(userDetail)
                print(folder)
                posts = postDetail.data ?? []
                
                
            } catch {
                print(error)
            }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
