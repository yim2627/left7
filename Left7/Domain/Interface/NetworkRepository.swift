//
//  NetworkRepository.swift
//  Left7
//
//  Created by 임지성 on 2022/07/02.
//

import Foundation
import RxSwift

protocol NetworkRepository {
    func fetchMovies(page: Int) -> Observable<[Movie]>
}
