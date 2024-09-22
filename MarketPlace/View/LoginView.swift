//
//  LoginView.swift
//  MarketplaceUNI
//
//  Created by 이예나 on 9/22/24.
//

import Foundation
import UIKit

class LoginView: UIView {

    // UILabel을 생성하여 "Login Screen" 텍스트를 표시
    private let loginLabel: UILabel = {
        let label = UILabel()
        label.text = "Login Screen"
        label.font = UIFont.systemFont(ofSize: 24)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 로그인 레이블을 뷰에 추가
        addSubview(loginLabel)
        
        // 레이블의 오토레이아웃 설정
        NSLayoutConstraint.activate([
            loginLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            loginLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
