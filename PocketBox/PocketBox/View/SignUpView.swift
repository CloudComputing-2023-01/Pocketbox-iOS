//
//  SignUpView.swift
//  PocketBox
//
//  Created by MBSoo on 2023/06/11.
//

import SwiftUI
import KakaoSDKAuth
import KakaoSDKUser

struct SignUpView: View {
    @State var email = ""
    @State var name = ""
    @State var password = ""
    @State private var emailValid: Bool = false
    @State private var showAlert = false
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
            HStack {
                Text("이메일로 계속하기")
                    .font(.system(size: 14, weight: .bold))
                Spacer()
            }.padding()
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
                HStack {
                    Text("이름")
                        .font(.system(size: 15, weight: .light))
                        .frame(width: 70)
                    TextField("", text: $name)
                        .onChange(of: name, perform: { _ in
                            userVM.name = name
                        })
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.yellow, lineWidth: 1)
                        )
                }.padding(.horizontal)
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
                    print(userVM.email, userVM.name, userVM.password)
                    showAlert = true
//                    userVM.register(name: userVM.name, email: userVM.email, password: userVM.password)
                    userVM.postRegister()
                } label: {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(height: 50)
                        .foregroundColor(.yellow.opacity(0.4))
                        .overlay(
                            Text("회원가입 완료")
                                .foregroundColor(.black)
                        )
                }.padding()
                    .alert(isPresented: $showAlert) {
                        if(isValidEmail(email: email)) {
                            return Alert(title: Text("회원가입 완료"), message: Text("회원가입에 성공했습니다."), dismissButton: .default(Text("확인")))
                        } else {
                            return Alert(title: Text("회원가입 실패"), message: Text("이메일을 확인해주세요."), dismissButton: .default(Text("확인"), action: {
                                email = ""
                            }))
                        }
                    }
            }
            HStack {
                Rectangle().frame(height: 1).foregroundColor(.gray.opacity(0.4))
                Text("또는")
                    .font(.system(size: 14, weight: .ultraLight))
                Rectangle().frame(height: 1).foregroundColor(.gray.opacity(0.4))
            }
            Button {
                if(UserApi.isKakaoTalkLoginAvailable()) {
                    UserApi.shared.loginWithKakaoAccount { oauthToken, error in
                        print(oauthToken)
                        print(error)
                    }
                } else {
                    UserApi.shared.loginWithKakaoAccount { oauthToken, error in
                        print(oauthToken)
                        print(error)
                    }
                }
            } label: {
                RoundedRectangle(cornerRadius: 10)
                    .frame(height: 50)
                    .foregroundColor(.yellow.opacity(0.4))
                    .overlay(
                        HStack {
                            Image("kakao")
                                .resizable()
                                .frame(width: 20, height: 20)
                            Spacer()
                            Text("카카오로 로그인 하기")
                            Spacer()
                        }.padding()
                            .foregroundColor(.black)
                    )
                
            }.padding()
            NavigationLink {
                LoginView(userVM: userVM)
            } label: {
                RoundedRectangle(cornerRadius: 10)
                    .frame(height: 50)
                    .foregroundColor(.yellow.opacity(0.4))
                    .overlay(
                        Text("이미 계정이 있으신가요?")
                            .foregroundColor(.black)
                    )
                    .padding()
            }
            Spacer()
            
            
            
        }
    }
    func isValidEmail(email: String) -> Bool {
        if email.count > 100 {
            return false
        }
        let emailFormat = "(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}" + "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" + "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-" + "z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5" + "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" + "9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" + "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        //let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: email)
    }
    
}

//struct SignUpView_Previews: PreviewProvider {
//    static var previews: some View {
//        SignUpView()
//    }
//}
