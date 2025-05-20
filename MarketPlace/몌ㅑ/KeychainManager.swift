import SwiftUI

class KeychainManager {
    enum KeychainError: Error {
        case duplicateEntry
        case noToken
        case unknown(OSStatus)
    }
    
    static func save(studentId: String, token: Data) throws {
        // 기존 항목이 있는지 확인
        if get() != nil {
            // 기존 항목 삭제
            try delete()
        }
        
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: studentId as NSString,
            kSecValueData as String: token as NSData
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            if status == errSecDuplicateItem {
                throw KeychainError.duplicateEntry
            } else {
                throw KeychainError.unknown(status)
            }
        }
        
        print("✅ 키체인에 새 토큰 저장됨: \(String(data: token, encoding: .utf8) ?? "알 수 없음")")
    }
    
    static func get() -> (userId: String, token: String)? {
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecReturnAttributes as String: kCFBooleanTrue,
            kSecReturnData as String: kCFBooleanTrue,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: CFTypeRef?
        _ = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard let data = result as? [String: AnyObject],
              let tokenData = data[kSecValueData as String] as? Data,
              let token = String(data: tokenData, encoding: String.Encoding.utf8),
              let studentId = data[kSecAttrAccount as String] as? String
                else { return nil }
        
        print("Token: ",token)
        
        return (studentId, token)
    }
    
    static func delete() throws {
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        guard status != errSecItemNotFound else { throw KeychainError.noToken}
        guard status == errSecSuccess else { throw KeychainError.unknown(status)}
    }
    
}

extension KeychainManager {
    static func getToken() -> String? {
        return get()?.token
    }
}
