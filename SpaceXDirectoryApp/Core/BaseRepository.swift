//
//  BaseRepositiry.swift
//  SpaceXDirectoryApp
//
//  Created by Kirill Berezhnoy on 18.12.2023.
//

import Foundation
import RxSwift

// MARK: - BaseRepository protocol
protocol BaseRepository: AnyObject {
    
    associatedtype T
    
    func get() -> Single<T>
    
}
