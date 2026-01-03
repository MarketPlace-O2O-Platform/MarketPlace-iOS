
import SwiftUI

struct CheerView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var loginVM: LoginViewModel
    @EnvironmentObject var viewModel: CheerViewModel
    
    @State var upcomingLastIndex: Int = 0
    
    @State private var hasData: Bool = true
    
    var body: some View {
        NavigationView {
            ScrollView {
                CheerSearchView(searchText: $viewModel.searchText)

                VStack(spacing:20) {
                    if viewModel.searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        HotCheerView(hotCheerMarkets: $viewModel.cheerMarket, cheerTicket: $viewModel.memberCheerTicket, lastIndex: $upcomingLastIndex)
                            .padding(.top, 10)

                        Rectangle()
                            .foregroundStyle(Color(hex: "#EEEEEE"))
                            .frame(height: 4)

                        CheerListView()
                    } else {
                        if hasData {
                            ScrollView {
                                LazyVStack(spacing: 10) {
                                    ForEach(Array($viewModel.searchMarkets.enumerated()), id: \.offset) { index, $market in
                                        VStack {
                                            CheerSearchCardCell(market: $market)
                                                .padding(.vertical, 10)
                                            Divider()
                                        }
                                        .onAppear {
                                            guard index == viewModel.cheerMarket.count - 1,
                                                  let lastId = viewModel.searchLastMarketId
                                            else { return }

                                            Task {
                                                await viewModel.fetchSearchCheerMarket(lastPageIndex: lastId, name: viewModel.currentKeyword)
                                            }
                                        }
                                    }
                                }
                                .padding()
                            }
                        } else{
                            CheerSearchfailedView()
                        }
                    }
                }
            }
            .onTapGesture {
                self.endTextEditing()
            }
            .onAppear{
                print("🔥 CheerView onAppear 호출됨")
                print("🔥 현재 searchText: '\(viewModel.searchText)'")

                // searchText 초기화
                viewModel.searchText = ""

                print("🔥 초기화 후 searchText: '\(viewModel.searchText)'")

                // 네비게이션 스택 리셋
                DispatchQueue.main.async {
                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                       let window = windowScene.windows.first {

                        func findNavigationController(in viewController: UIViewController?) -> UINavigationController? {
                            if let navController = viewController as? UINavigationController {
                                return navController
                            }
                            for child in viewController?.children ?? [] {
                                if let navController = findNavigationController(in: child) {
                                    return navController
                                }
                            }
                            return nil
                        }

                        if let tabBarController = window.rootViewController as? UITabBarController,
                           let selectedVC = tabBarController.selectedViewController,
                           let navController = findNavigationController(in: selectedVC) {
                            navController.popToRootViewController(animated: false)
                            print("✅ 네비게이션 스택 리셋 완료")
                        }
                    }
                }

                Task {
                    await viewModel.fetchMemberInfo()
                    await viewModel.fetchUpcomingMarket()
                }
            }
            .onChange(of: upcomingLastIndex) { _, newValue in
                Task {
                    await viewModel.fetchUpcomingMarket(lastPageIndex: viewModel.upcomingMarketLastMarketId)
                }
            }
            .onChange(of: viewModel.searchText) { _, newValue in
                Task {
                    hasData = await viewModel.fetchSearchCheerMarket(name: newValue)
                    viewModel.currentKeyword = newValue
                }
            }
        }
    }
}
