//
//  MyPageReplaceView.swift
//  PocketBox
//
//  Created by MBSoo on 2023/06/12.
//

import SwiftUI

struct MyPageReplaceView: View {
    @State var name = ""
    @State var email = ""
    @State var password = ""
    @ObservedObject var userVM: UserViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        VStack {
            HStack {
                Text("이름")
                    .font(.system(size: 20, weight: .regular))
                    .frame(width: 70)
                TextField(userVM.userDetail?.name ?? "", text: $name)
                    .font(.system(size: 20, weight: .bold))
                Spacer()
            }
            .padding()
            HStack {
                Text("이메일")
                    .font(.system(size: 20, weight: .regular))
                    .frame(width: 70)
                TextField(userVM.userDetail?.email ?? "", text: $email)
                    .font(.system(size: 20, weight: .bold))
                Spacer()
            }
            .padding()
            HStack {
                Text("암호")
                    .font(.system(size: 20, weight: .regular))
                    .frame(width: 70)
                SecureField("", text: $password)
                    .font(.system(size: 20, weight: .bold))
                Spacer()
            }.padding()
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(.yellow.opacity(0.4))
                    .frame(width: 70, height: 40)
                    .overlay(
                        Text("완료")
                            .foregroundColor(.white)
                    )
            }

        }
    }
}
