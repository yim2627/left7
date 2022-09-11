//
//  HttpNetwork.swift
//  Left7
//
//  Created by 임지성 on 2022/06/17.
//

import Foundation
import RxSwift

import Moya
import RxMoya

final class HttpNetwork: MoyaProvider<MultiTarget>, HttpNetworkType {
	func request(_ targetType: TargetType) -> Single<Response> {
		self.rx.request(.target(targetType))
			.filterSuccessfulStatusCodes() // status 200번대가 아닐시 Moya 내부에서 에러 처리
	}
}
