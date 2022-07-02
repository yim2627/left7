//
//  YogiHomeRepository.swift
//  Left7
//
//  Created by 임지성 on 2022/07/02.
//

import Foundation
import RxSwift

final class YogiProductRepository: NetworkRepository {
    private let network: HttpNetwork
    
    init(network: HttpNetwork = HttpNetwork()) {
        self.network = network
    }
    
    func fetchYogiProduct(page: Int) -> Observable<Product> {
        let endPoint = EndPoint(urlInformation: .pagination(page: page))
        
        return .empty()
    }
}
