import SwiftUI

class KeychainManager {
    enum KeychainError: Error {
        case duplicateEntry
        case noToken
        case unknown(OSStatus)
    }
    
    static func save(studentId: String, token: Data) throws {
        print("save token: \(String(data: token, encoding: .utf8)!)")
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword, //data 종료를 알려주는 역할. -> 인터넷 비밀번호
            kSecAttrAccount as String: studentId as NSString, //사용자 이름
            kSecValueData as String: token as NSData //사용자 비밀번호
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status != errSecDuplicateItem else {
            throw KeychainError.unknown(status)
        }
        guard status == errSecSuccess else {
            throw KeychainError.unknown(status)
        }
        
        
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
