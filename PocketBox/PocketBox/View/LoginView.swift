//
//  LoginView.swift
//  PocketBox
//
//  Created by MBSoo on 2023/06/11.
//

import SwiftUI

struct LoginView: View {
    @State var email = ""
    @State var name = ""
    @State var password = ""
    @State var showAlert = false
    
    @ObservedObject var userVM: UserViewModel
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "box.truck.fill")
                    .resizable()
                    .frame(width: 70, height: 50)
                    .scaledToFill()
                    .foregroundColor(.yellow).opacity(0.4)
                Spacer()
            }.padding(20)
            HStack {
                Text("PocketBox에 오신 걸 환영합니다!")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                Spacer()
            }.padding(20)
            Divider()
            Section {
                HStack {
                    Text("이메일")
                        .font(.system(size: 15, weight: .light))
                        .frame(width: 70)
                    TextField("", text: $email)
                        .onChange(of: email, perform: { _ in
                            userVM.email = email
                        })
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.yellow,lineWidth: 1)
                        )
                }.padding()
//                HStack {
//                    Text("이름")
//                        .font(.system(size: 15, weight: .light))
//                        .frame(width: 70)
//                    TextField("", text: $name)
//                        .onChange(of: name, perform: { _ in
//                            userVM.name = name
//                        })
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 5)
//                                .stroke(Color.yellow, lineWidth: 1)
//                        )
//                }.padding(.horizontal)
                HStack {
                    Text("비밀번호")
                        .font(.system(size: 15, weight: .light))
                        .frame(width: 70)
                    SecureField("", text: $password)
                        .onChange(of: password, perform: { _ in
                            userVM.password = password
                        })
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.yellow, lineWidth: 1)
                        )
                }.padding()
                Button {
                    userVM.postLogin()
                    showAlert = !SignUpView(userVM: userVM).isValidEmail(email: email)
                } label: {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(height: 50)
                        .foregroundColor(.yellow.opacity(0.4))
                        .overlay(
                            Text("로그인")
                                .foregroundColor(.black)
                        )
                }.padding().alert(isPresented: $showAlert) {
                        return Alert(title: Text("로그인 실패"), message: Text("로그인 정보를 확인하세요."), dismissButton: .default(Text("확인"), action: {
                            email = ""
                            name = ""
                            password = ""
                        }))
                }
            }
        }.fullScreenCover(isPresented: $userVM.isLogined) {
            ContentView()
        }
    }
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(userVM: UserViewModel())
    }
}
