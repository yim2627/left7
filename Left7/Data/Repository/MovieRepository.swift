//
//  MovieRepository.swift
//  Left7
//
//  Created by 임지성 on 2022/07/02.
//

import Foundation
import RxSwift

final class MovieRepository: NetworkRepository {
    //MARK: - Properties

    private let network: HttpNetworkType
    
    //MARK: - Init

    init(network: HttpNetworkType = HttpNetwork()) {
        self.network = network
    }
    
    //MARK: - Method

    func fetchMovies(page: Int) -> Observable<[Movie]> {
        let endPoint = EndPoint(urlInformation: .pagination(page: page))
        
        return network.fetch(endPoint: endPoint)
            .map { data -> [Movie] in
                let jsonDecoder = JSONDecoder()
                let decodedData = try? jsonDecoder.decode(MovieResponseModel.self, from: data)
                
                let movies = decodedData?.movies.map { movie in
                    movie.toDomain()
                }
                
                return movies ?? []
            }
    }
}
