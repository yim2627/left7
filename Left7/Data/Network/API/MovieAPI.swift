//
//  MovieAPI.swift
//  Left7
//
//  Created by 임지성 on 2022/09/09.
//

import Foundation
import Moya

enum MovieAPI {
	case nowPlayingList(page: Int)
}

extension MovieAPI: TargetType {
	var baseURL: URL {
		switch self {
			case .nowPlayingList:
				guard let url = URL(string: "https://api.themoviedb.org/3") else {
					fatalError("Invalid URL")
				}
				return url
		}
	}
	
	var path: String {
		switch self {
			case .nowPlayingList:
				return "/movie/now_playing"
		}
	}
	
	var method: Moya.Method {
		switch self {
			case .nowPlayingList:
				return .get
		}
	}
	
	var task: Task {
		guard let parameter = parameter else {
			return .requestPlain
		} // 파라미터 문제가 있으면 빈 파라미터로 리턴하고, 실제 네트워크단에서 파라미터가 필요한데 없으면 에러를 던지게하면 될듯
		
		switch self {
			case .nowPlayingList:
				return .requestParameters(parameters: parameter, encoding: URLEncoding.queryString)
		}
	}
	
	var parameter: [String: Any]? {
		switch self {
			case .nowPlayingList(let page):
				let params = NowPlayingRequestModel(
						apiKey: "13002531cbc59fc376da2b25a2fb918a",
						page: page
				).toDictionary()
				
				return params
		}
	}
	
	var headers: [String : String]? {
		return ["Content-Type": "application/json"]
	}
}
