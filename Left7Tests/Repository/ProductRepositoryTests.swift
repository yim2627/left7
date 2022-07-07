//
//  ProductRepositoryTests.swift
//  Left7Tests
//
//  Created by 임지성 on 2022/07/07.
//

import XCTest
@testable import Left7

import RxSwift

final class ProductRepositoryTests: XCTestCase {
    private var testModel: YogiResponse!
    private var testModelData: Data!
    
    private var disposeBag: DisposeBag!
    
    override func setUpWithError() throws {
        testModel = YogiResponse(
            statusMsg: "",
            statusCode: -1,
            productData: YogiResponse.ProductDataResponse(
                productTotalCount: -1,
                products: [
                    YogiResponse.ProductDataResponse.ProductResponse(
                        id: -1,
                        name: "",
                        thumbnailPath: "",
                        description: YogiResponse.ProductDataResponse.ProductResponse.ProductDescriptionResponse(
                            imagePath: "",
                            subject: "",
                            price: -1
                        ),
                        rate: -1
                    ),
                    YogiResponse.ProductDataResponse.ProductResponse(
                        id: -2,
                        name: "",
                        thumbnailPath: "",
                        description: YogiResponse.ProductDataResponse.ProductResponse.ProductDescriptionResponse(
                            imagePath: "",
                            subject: "",
                            price: -2
                        ),
                        rate: -2
                    ),
                    YogiResponse.ProductDataResponse.ProductResponse(
                        id: -3,
                        name: "",
                        thumbnailPath: "",
                        description: YogiResponse.ProductDataResponse.ProductResponse.ProductDescriptionResponse(
                            imagePath: "",
                            subject: "",
                            price: -3
                        ),
                        rate: -3
                    )
                ]
            )
        )
        
        testModelData = try! JSONEncoder().encode(testModel)
        
        disposeBag = DisposeBag()
    }
    
    func test_fetchYogiProducts() {
        let testPage = 1
        
        let network = MockHttpNetwork(data: testModelData)
        let endPoint = EndPoint(urlInformation: .pagination(page: testPage))
        let repository = YogiProductRepository(network: network)
        
        let products = self.testModel.productData.products.map { $0.toDomain() }
        
        repository.fetchYogiProducts(page: testPage)
            .subscribe(onNext: { models in
                XCTAssertEqual(products, models)
                network.verifyFetch(endPoint: endPoint)
            })
            .disposed(by: disposeBag)
    }
}
