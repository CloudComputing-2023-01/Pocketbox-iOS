//
//  MyPageView.swift
//  PocketBox
//
//  Created by MBSoo on 2023/06/10.
//

import SwiftUI

struct MyPageView: View {
    @ObservedObject var userVM: UserViewModel
    @State var showSheet = false
    var body: some View {
        VStack {
            HeaderView()
            HStack {
                Text("마이 페이지")
                    .font(.system(size: 17, weight: .bold, design: .rounded))
                Spacer()
                Button {
                    showSheet = true
                } label: {
                    Image(systemName: "square.and.pencil")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.yellow)
                }.sheet(isPresented: $showSheet) {
                    MyPageReplaceView(userVM: userVM)
                }

                
            }.padding()
            Spacer()
            HStack {
                Text("이름")
                    .font(.system(size: 20, weight: .regular))
                    .frame(width: 70)
                Text("\(userVM.userDetail?.name ?? "")")
                    .font(.system(size: 20, weight: .bold))
                Spacer()
            }
            .padding()
            HStack {
                Text("이메일")
                    .font(.system(size: 20, weight: .regular))
                    .frame(width: 70)
                Text("\(userVM.userDetail?.email ?? "")")
                    .font(.system(size: 20, weight: .bold))
                Spacer()
            }
            .padding()
            HStack {
                Text("암호")
                    .font(.system(size: 20, weight: .regular))
                    .frame(width: 70)
                Text("************")
                    .font(.system(size: 20, weight: .bold))
                Spacer()
            }
            .padding()
            Spacer()
        }
    }
}

//struct MyPageView_Previews: PreviewProvider {
//    static var previews: some View {
//        MyPageView()
//    }
//}
