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
    
    func fetchYogiProducts(page: Int) -> Observable<[Product]> {
        let endPoint = EndPoint(urlInformation: .pagination(page: page))
        
        return network.fetch(endPoint: endPoint)
            .map { data -> [Product] in
                let jsonDecoder = JSONDecoder()
                let decodedData = try? jsonDecoder.decode(YogiResponse.self, from: data)
                
                let products = decodedData?.productData.products.map { product in
                    product.toDomain()
                }
                return products ?? []
            }
    }
}
