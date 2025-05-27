//
//  SearchViewModel.swift
//  MarketPlace
//
//  Created by Bowon Han on 5/27/25.
//

import Foundation

final class SearchMarketViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var market: [MarketSearchModel] = []
    
    let networkService = NetworkService()
    
    private func searchMarketsList(
        lastPageIndex: Int? = nil,
        pageSize: Int? = nil,
        name: String) async {
            let result: NetworkResult
            <APIResDto
            <MarketResDto
            <MarketSearchModel>>> = await networkService.request(
                MarketEndpoint.fetchMarketsWithSearching(
                    lastPageIndex: lastPageIndex,
                    pageSize: pageSize,
                    content: name)
            )
            
            switch result {
            case .success(let data, let statusCode):
                self.market = data.response.marketResDtos
            case .failure(let statusCode, let message):
                print("searchMarketsList: [statusCode] - \(statusCode), [message] - \(message ?? "없음")")

            }
    }
}
