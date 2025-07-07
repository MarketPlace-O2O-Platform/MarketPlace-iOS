import SwiftUI

final class LoginViewModel: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var userErrorMessage: String?
    
    var token: String? {
        KeychainManager.getToken()
    }
    
    private var memberService: MemberServiceProtocol
    
    init(memberService: MemberServiceProtocol = MemberService()) {
        self.memberService = memberService
    }
    
    func signIn(studentId: String, password: String, saveAccount: Bool) async {
        let result = await memberService.signIn(studentId: studentId, password: password)
        
        switch result {
        case .success(let data, _):
            isLoggedIn = true
            
            /// - NOTE: 키체인에 토큰 저장
            KeychainManager.save(KeyChainKeys.token, value: data.response)
            
            if saveAccount {
                KeychainManager.save(KeyChainKeys.studentId, value: studentId)
                KeychainManager.save(KeyChainKeys.password, value: password)

            } else {
                KeychainManager.delete(KeyChainKeys.studentId)
                KeychainManager.delete(KeyChainKeys.password)

            }
            
        case .failure(let statusCode, let message):
            print("[signIn] - [\(statusCode)]: \(message ?? "알 수 없는 오류")")
            userErrorMessage = message
        }
    }
    
    func logout() {
        KeychainManager.delete(KeyChainKeys.token)
        DispatchQueue.main.async {
            self.isLoggedIn = false
        }
    }
}
