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
	
	init(network: HttpNetworkType) {
		self.network = network
	}
	
	//MARK: - Method
	
	func fetchMovies(page: Int) -> Observable<[Movie]> {
		//        let url = EndPointStorage.movieList(page: page).generateURL()
		return network.request(MovieAPI.nowPlayingList(page: page))
			.asObservable()
			.map { response -> [Movie] in
				let jsonDecoder = JSONDecoder()
				guard let decodedData = try? jsonDecoder.decode(MovieResponseModel.self, from: response.data),
							let movies = decodedData.movies else {
					throw HttpNetworkError.decodeError
				}
				
				return movies.compactMap { $0.toDomain() }
			}
	}
}
