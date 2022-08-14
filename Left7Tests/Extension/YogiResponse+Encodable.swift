//
//  MovieResponseModel+Encodable.swift
//  Left7Tests
//
//  Created by 임지성 on 2022/07/07.
//

@testable import Left7

extension MovieResponseModel: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(page, forKey: .page)
        try container.encode(dates, forKey: .dates)
        try container.encode(movies, forKey: .movies)
        try container.encode(totalPages, forKey: .totalPages)
        try container.encode(totalResults, forKey: .totalResults)
    }
}

extension MovieResponseModel.MovieListItem: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(adult, forKey: .adult)
        try container.encode(id, forKey: .id)
        try container.encode(overview, forKey: .overview)
        try container.encode(popularity, forKey: .popularity)
        try container.encode(title, forKey: .title)
        try container.encode(video, forKey: .video)
        try container.encode(backdropPath, forKey: .backdropPath)
        try container.encode(genreIds, forKey: .genreIds)
        try container.encode(originalLanguage, forKey: .originalLanguage)
        try container.encode(originalTitle, forKey: .originalTitle)
        try container.encode(posterPath, forKey: .posterPath)
        try container.encode(releaseDate, forKey: .releaseDate)
        try container.encode(voteAverage, forKey: .voteAverage)
        try container.encode(voteCount, forKey: .voteCount)
    }
}

extension MovieResponseModel.MoviePlayLimitDate: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(maximum, forKey: .maximum)
        try container.encode(minimum, forKey: .minimum)
    }
}
