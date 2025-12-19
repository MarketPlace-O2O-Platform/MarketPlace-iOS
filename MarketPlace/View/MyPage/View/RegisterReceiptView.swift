//
//  RegisterReceiptView.swift
//  MarketPlace
//
//  Created by Bowon Han on 7/2/25.
//

import SwiftUI

struct RegisterReceiptView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var isShowImagePicker: Bool = false
    @State private var bank: String = ""
    @State private var accountNumber: String = ""
//    @State private var isSaveAccount: Bool = false
    @State var image: UIImage?
    
    @ObservedObject var viewModel: SubmitReceiptViewModel
    
    @AppStorage("savedBank") private var savedBank: String = ""
    @AppStorage("savedAccountNumber") private var savedAccountNumber: String = ""
    @AppStorage("isAccountSaved") private var isAccountSaved: Bool = false

    init(viewModel: SubmitReceiptViewModel) {
        self.viewModel = viewModel
        setupNavigationBarAppearance()
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("환급받을 영수증을\n등록해주세요")
                .pretendardFont(size: 26, weight: .bold)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
                .padding(.top, 20)
                            
            ZStack {
                RoundedRectangle(cornerRadius: 2)
                    .stroke(Color(Colors.gray_600), lineWidth: 1)

                if image == nil {
                    VStack(spacing: 20){
                        Image("ReceiptIcon")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 64)

                        Text("24시간 내로 환급이 이루어지지 않을 시\n고객센터(쿠러미 카카오채널)로 문의해주세요!")
                            .pretendardFont(size: 14, weight: .medium)
                            .foregroundStyle(Colors.gray_600)
                            .multilineTextAlignment(.center)
                    }
                } else {
                    Image(uiImage: image!)
                        .resizable()
                        .scaledToFit()
                        .padding(.horizontal, 40)
                        .padding(.vertical, 20)
                }
            }
            .onTapGesture {
                self.isShowImagePicker.toggle()
            }
            
            Text("환급받을 계좌를\n알려주세요")
                .pretendardFont(size: 26, weight: .bold)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
                .padding(.top, 20)
            
            HStack(spacing: 10) {
                TextField("은행 입력", text: $bank)
                    .pretendardFont(size: 13, weight: .regular)
                    .padding()
                    .frame(width: 90, height: 48)
                    .background(
                        RoundedRectangle(cornerRadius: 2)
                            .stroke(Colors.gray_600, lineWidth: 1)
                    )
                
                TextField("계좌번호 입력", text: $accountNumber)
                    .pretendardFont(size: 13, weight: .regular)
                    .padding()
                    .frame(height: 48)
                    .background(
                        RoundedRectangle(cornerRadius: 2)
                            .stroke(Colors.gray_600, lineWidth: 1)
                    )
            }.padding(.bottom, 10)
            
            CheckboxView(title: "계좌번호 저장", isChecked: $isAccountSaved)
            
            Button(action: {
                // - 계좌번호 임시저장
                if isAccountSaved {
                    savedBank = bank
                    savedAccountNumber = accountNumber
                } else {
                    savedBank = ""
                    savedAccountNumber = ""
                }
                
                // - TODO: 영수증 보내는 API
                if let image = image,
                   let jpgImageData = image.jpegData(compressionQuality: 0.2) {
                    let boundary = "Boundary-\(UUID().uuidString)"
                    
                    Task {
                        await viewModel.putSubmitRecipt(memberCouponId: viewModel.couponId, image: jpgImageData, bodyBoundary: boundary)
                        await viewModel.saveAccountNum(account: bank, accountNumber: accountNumber)
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }) {
                Text("저장하기")
                    .pretendardFont(size: 14, weight: .bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(bank.isEmpty || accountNumber.isEmpty ? Color.gray.opacity(0.4) : .black)
                    .cornerRadius(8)
            }
            .disabled(bank.isEmpty || accountNumber.isEmpty)
            .padding(.bottom, 10)
        }
        .sheet(isPresented: $isShowImagePicker) {
            UImagePicker(sourceType: .photoLibrary) { image in
                self.image = image
            }
        }
        .onAppear {
            if isAccountSaved {
                bank = savedBank
                accountNumber = savedAccountNumber
            }
        }
        .padding(.horizontal, 30)
        .navigationTitle("환급하기")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.backward")
                        .foregroundColor(.black)
                }
            }
        }
    }
    
    private func setupNavigationBarAppearance() {
        /// UINavigationBar의 기본 설정을 수정합니다.
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.white
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        
        /// 기본 back indicator를 숨깁니다.
        appearance.setBackIndicatorImage(UIImage(), transitionMaskImage: UIImage())
        
        /// 설정된 appearance 적용
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
}
