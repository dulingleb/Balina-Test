//
//  PhotoListModels.swift
//  Balina Test
//
//  Created by Dulin Gleb on 28.4.24..
//

import Foundation
import Alamofire

struct PhotoListModel: Decodable {
    let content: [PhotoModel]
    let page: Int
    let pageSize: Int
    let totalElements: Int
    let totalPages: Int
}
