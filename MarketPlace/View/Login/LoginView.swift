import SwiftUI

struct LoginView: View {
    @State private var selectedSchool: String = ""
    @State private var studentID: String = ""
    @State private var password: String = ""
    @StateObject private var viewModel = LoginViewModel()
    
    @AppStorage(UserDefaultsKeys.saveId) private var saveID: Bool = false
    @AppStorage(UserDefaultsKeys.savePassword) private var savePassword: Bool = false
        
    @FocusState var isEditing: Bool
    
    let schools = ["인천대학교"]
    
    var body: some View {
        if viewModel.isLoggedIn {
            ContentView()
        } else {
            VStack(alignment: .leading, spacing: 4) {
                Image("logo")
                    .resizable()
                    .frame(width: 124, height: 40)
                    .padding(.top, 56)
                    .padding(.bottom, 20)
                    .padding(.leading, 20)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("매번 마라탕 한 그릇, 이천 원 더 내고 있어요.")
                        .pretendardFont(size: 12, weight: .semibold)
                        .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                    
                    Text("이제, 다니는 대학 제휴 멤버십으로 \n쿠폰 꾸러미 받아볼까요?")
                        .pretendardFont(size: 16, weight: .medium)
                        .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 14)
                
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("학교")
                            .pretendardFont(size: 14, weight: .regular)
                            .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                        
                        Menu {
                            ForEach(schools, id: \.self) { school in
                                Button(action: {
                                    selectedSchool = school
                                }) {
                                    Text(school)
                                }
                            }
                        } label: {
                            HStack {
                                Text(selectedSchool.isEmpty ? "학교를 선택해주세요" : selectedSchool)
                                    .pretendardFont(size: 13, weight: .regular)
                                    .foregroundColor(selectedSchool.isEmpty ? .gray : .black)
                                    .padding()
                                
                                Spacer()
                                
                                Image(systemName: "chevron.down")
                                    .foregroundColor(.black)
                                    .padding(.trailing)
                            }
                            .frame(height: 48)
                            .background(RoundedRectangle(cornerRadius: 2).stroke(Color.gray.opacity(0.5), lineWidth: 1))
                        }
                    }
                    
                    // MARK: - 로그인 TextField
                    VStack(alignment: .leading, spacing: 8) {
                        Text("학번(ID)")
                            .pretendardFont(size: 14, weight: .regular)
                            .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                        
                        TextField("학번을 입력해 주세요.", text: $studentID)
                            .pretendardFont(size: 13, weight: .regular)
                            .padding()
                            .frame(height: 48)
                            .background(
                                RoundedRectangle(cornerRadius: 2)
                                    .stroke(studentID.isEmpty ? Color.gray.opacity(0.5) : .black, lineWidth: 1)
                            )
                            .focused($isEditing)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("비밀번호")
                            .pretendardFont(size: 14, weight: .regular)
                            .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                        
                        SecureField("비밀번호는 꼭꼭 지켜줄게요", text: $password)
                            .pretendardFont(size: 13, weight: .regular)
                            .padding()
                            .frame(height: 48)
                            .background(
                                RoundedRectangle(cornerRadius: 2)
                                    .stroke(password.isEmpty ? Color.gray.opacity(0.5) : .black, lineWidth: 1))
                            .focused($isEditing)
                    }
                    
                    Text("학교 포털 아이디 / 비밀번호를 적어주세요!")
                        .pretendardFont(size: 12, weight: .medium)
                        .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                    
                    if !isEditing, let errorMessage = viewModel.userErrorMessage {
                        Text(errorMessage)
                            .pretendardFont(size: 14, weight: .regular)
                            .foregroundColor(.red)
                            .padding(.top, 10)
                    }
                    
                    // MARK: - 로그인 버튼
                    Button(action: {
                        Task {
                            isEditing = false
                            await viewModel.signIn(studentId: studentID, password: password, saveID: saveID, savePassword: savePassword)
                        }
                    }) {
                        Text("로그인")
                            .pretendardFont(size: 14, weight: .bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(studentID.isEmpty || password.isEmpty ? Color.gray.opacity(0.4) : .black)
                            .cornerRadius(8)
                    }.disabled(studentID.isEmpty || password.isEmpty)
                    
                    HStack(spacing: 20) {
                        CheckboxView(title: "학번(ID) 저장", isChecked: $saveID)
                        
                        Spacer()
                        
                        CheckboxView(title: "비밀번호 저장", isChecked: $savePassword)
                    }
                }
                .padding(.horizontal, 20)
                
                Spacer()
            }
            .onAppear {
                if saveID, let id = KeychainManager.load(KeyChainKeys.studentId) {
                    studentID = id
                }
                
                if savePassword, let password = KeychainManager.load(KeyChainKeys.password) {
                    self.password = password
                }
            }
            .onChange(of: isEditing == true, { _, _ in
                viewModel.userErrorMessage = nil
            })
            .onTapGesture {
                self.endTextEditing()
            }
        }
    }
}

struct CheckboxView: View {
    let title: String
    @Binding var isChecked: Bool
    
    var body: some View {
        Button(action: {
            isChecked.toggle()
        }) {
            HStack {
                Image(systemName: isChecked ? "checkmark.square.fill" : "square")
                    .foregroundColor(.black)
                Text(title)
                    .pretendardFont(size: 12, weight: .bold)
                    .foregroundColor(.black)
            }
        }
    }
}
