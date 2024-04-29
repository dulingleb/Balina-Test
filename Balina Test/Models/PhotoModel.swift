//
//  PhotoModel.swift
//  Balina Test
//
//  Created by Dulin Gleb on 28.4.24..
//

import Foundation
import UIKit

struct PhotoModel: Decodable {
    let id: Int
    let name: String
    let image: URL?
}
