//
//  ViewController.swift
//  Left7
//
//  Created by 임지성 on 2022/07/01.
//

import UIKit
import RxSwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        
        let end = EndPoint(urlInformation: .pagination(jsonId: 1))
        let net = HttpNetwork()
        net.fetch(endPoint: end)
            .subscribe(onNext: { data in
                let jsonDecoder = JSONDecoder()
                let decodedData = try? jsonDecoder.decode(YogiResponse.self, from: data)
                
                print(decodedData)
            })
    }
}

