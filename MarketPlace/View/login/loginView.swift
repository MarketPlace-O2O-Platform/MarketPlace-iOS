import SwiftUI

struct LoginView: View {
    @State private var selectedSchool: String = ""
    @State private var studentID: String = ""
    @State private var password: String = ""
    @State private var saveID: Bool = false
    @State private var savePassword: Bool = false
    @StateObject private var loginVM = LoginViewModel()

    let schools = ["인천대학교"]
    
    var body: some View {
        if loginVM.isLoggedIn {
            ContentView() // ✅ 로그인 성공 시 ContentView로 이동
        } else {
            VStack(alignment: .leading, spacing: 4) {
                // Logo
                Image("logo")
                    .resizable()
                    .frame(width: 124, height: 40)
                    .padding(.top, 56)
                    .padding(.bottom, 20)
                    .padding(.leading, 20)
                
                // Introduction text
                VStack(alignment: .leading, spacing: 10) {
                    Text("매번 마라탕 한 그릇, 이천 원 더 내고 있어요.")
                        .font(Font.custom("Pretendard", size: 12).weight(.semibold))
                        .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                    
                    Text("이제, 다니는 대학 제휴 멤버십으로 \n쿠폰 꾸러미 받아볼까요?")
                        .font(Font.custom("Pretendard", size: 16).weight(.medium))
                        .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 14)
                
                // Form fields
                VStack(alignment: .leading, spacing: 16) {
                    // School selector (Dropdown)
                    VStack(alignment: .leading, spacing: 12) {
                        Text("학교")
                            .font(Font.custom("Pretendard", size: 14))
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
                    
                    // Student ID field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("학번(ID)")
                            .font(Font.custom("Pretendard", size: 14))
                            .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                        
                        TextField("학번을 입력해 주세요.", text: $studentID)
                            .padding()
                            .frame(height: 48)
                            .background(RoundedRectangle(cornerRadius: 2).stroke(Color.gray.opacity(0.5), lineWidth: 1))
                    }
                    
                    // Password field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("비밀번호")
                            .font(Font.custom("Pretendard", size: 14))
                            .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                        
                        SecureField("비밀번호는 꼭꼭 지켜줄게요", text: $password)
                            .padding()
                            .frame(height: 48)
                            .background(RoundedRectangle(cornerRadius: 2).stroke(Color.gray.opacity(0.5), lineWidth: 1))
                    }
                    
                    Text("학교 포털 아이디 / 비밀번호를 적어주세요!")
                        .font(Font.custom("Pretendard", size: 12).weight(.medium))
                        .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                    
                    // Error message
                    if let errorMessage = loginVM.errorMessage {
                        Text(errorMessage)
                            .font(.system(size: 14))
                            .foregroundColor(.red)
                            .padding(.top, 10)
                    }
                    
                    // Login button
                    Button(action: {
                        Task {
                            await loginVM.postLogin(studentId: studentID, password: password)
                        }
                    }) {
                        Text("로그인")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.gray.opacity(0.8))
                            .cornerRadius(8)
                    }
                    
                    // Checkboxes
                    HStack(spacing: 20) {
                        CheckboxView(title: "학번(ID) 저장", isChecked: $saveID)
                        
                        Spacer()
                        
                        CheckboxView(title: "비밀번호 저장", isChecked: $savePassword)
                    }
                }
                .padding(.horizontal, 20)
                
                Spacer()
            }
        }
    }
}

// Custom checkbox component
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
                    .font(.system(size: 14))
                    .foregroundColor(.black)
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
