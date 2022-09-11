//
//  HttpNetworkType.swift
//  Left7
//
//  Created by 임지성 on 2022/09/11.
//

import Foundation
import RxSwift
import Moya

protocol HttpNetworkType {
	func request(_ targetType: TargetType) -> Single<Response>
}
