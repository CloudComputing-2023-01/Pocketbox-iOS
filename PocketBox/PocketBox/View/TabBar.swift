//
//  TabBar.swift
//  PocketBox
//
//  Created by MBSoo on 2023/06/10.
//

import SwiftUI

struct TabBar: View {
    @Binding var posts: [PostDetail]
    @State var selection = 0
    @StateObject var postNetworking: PostViewModel
    @ObservedObject var userVM: UserViewModel
    @ObservedObject var fileNetworking: FileViewModel
    var body: some View {
        TabView(selection: $selection) {
            HomeView(fileNetworking: fileNetworking, userVM: userVM)
                .tabItem {
                    Image(systemName: "house.fill")
                        .resizable()
                }
                .tag(0)
            BoardView(postNetworking: postNetworking, posts: $posts)
                .tabItem {
                    Image(systemName: "newspaper.fill")
                        .resizable()
                }
                .tag(1)
            MyPageView(userVM: userVM)
                .tabItem {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                }
                .tag(2)
        }
    }
}

//struct TabBar_Previews: PreviewProvider {
//    static var previews: some View {
//        TabBar()
//    }
//}
