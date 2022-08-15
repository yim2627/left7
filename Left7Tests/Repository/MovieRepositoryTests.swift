//
//  MovieRepositoryTests.swift
//  Left7Tests
//
//  Created by 임지성 on 2022/07/07.
//

import XCTest
@testable import Left7

import RxSwift

final class MovieRepositoryTests: XCTestCase {
    private var testModel: MovieResponseModel!
    private var testModelData: Data!
    
    private var disposeBag: DisposeBag!
    
    override func setUpWithError() throws {
        testModel = .init(
            dates: .init(
                maximum: "",
                minimum: ""
            ),
            page: -1,
            movies: [
                .init(
                    adult: false,
                    id: -1,
                    overview: "",
                    popularity: -1,
                    title: "",
                    video: false,
                    backdropPath: "",
                    genreIds: [-1, -1],
                    originalLanguage: "",
                    originalTitle: "",
                    posterPath: "",
                    releaseDate: "",
                    voteAverage: -1,
                    voteCount: -1
                ),
                .init(
                    adult: false,
                    id: -1,
                    overview: "",
                    popularity: -1,
                    title: "",
                    video: false,
                    backdropPath: "",
                    genreIds: [-1, -1],
                    originalLanguage: "",
                    originalTitle: "",
                    posterPath: "",
                    releaseDate: "",
                    voteAverage: -1,
                    voteCount: -1
                )
            ],
            totalPages: -1,
            totalResults: -1
        )
        
        testModelData = try! JSONEncoder().encode(testModel)
        
        disposeBag = DisposeBag()
    }
    
    func test_fetchMovies() {
        let testPage = 1
        
        let network = MockHttpNetwork(data: testModelData)
        
        let queryParams = NowPlayingRequestModel(
            apiKey: "13002531cbc59fc376da2b25a2fb918a",
            page: 1)
        let url = try! EndPoint(
            urlInformation: .nowPlayingList,
            queryParameters: queryParams
        ).generateURL().get()
        
        let repository = MovieRepository(network: network)
        
        let movies = self.testModel.movies?.compactMap { $0.toDomain() }
        
        repository.fetchMovies(page: testPage)
            .subscribe(onNext: { models in
                XCTAssertEqual(movies, models)
                network.verifyFetch(url: url)
            })
            .disposed(by: disposeBag)
    }
}
