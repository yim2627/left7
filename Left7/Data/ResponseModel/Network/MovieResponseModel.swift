//
//  MovieResponseModel.swift
//  Left7
//
//  Created by 임지성 on 2022/07/01.
//

import Foundation

struct MovieResponseModel: Decodable {
    let dates: MoviePlayLimitDate
    let page: Int
    let movies: [MovieListItem]
    let totalPages: Int
    let totalResults: Int

    enum CodingKeys: String, CodingKey {
        case dates, page
        case movies = "results"
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

extension MovieResponseModel {
    struct MovieListItem: Decodable {
        let adult: Bool
        let id: Int
        let overview: String
        let popularity: Double
        let title: String
        let video: Bool
        let backdropPath: String
        let genreIds: [Int]
        let originalLanguage: String
        let originalTitle: String
        let posterPath: String
        let releaseDate: String
        let voteAverage: Double
        let voteCount: Int

        enum CodingKeys: String, CodingKey {
            case adult, id, overview, popularity, title, video
            case backdropPath = "backdrop_path"
            case genreIds = "genre_ids"
            case originalLanguage = "original_language"
            case originalTitle = "original_title"
            case posterPath = "poster_path"
            case releaseDate = "release_date"
            case voteAverage = "vote_average"
            case voteCount = "vote_count"
        }
        
        func toDomain() -> Movie {
            return .init(
                id: id,
                name: title,
                posterPath: posterPath,
                descriptionSubject: overview,
                rate: voteAverage,
                isFavorite: false
            )
        }
    }
}

extension MovieResponseModel {
    struct MoviePlayLimitDate: Decodable {
        let maximum: String
        let minimum: String
        
        enum CodingKeys: String, CodingKey {
            case maximum, minimum
        }
    }
}



