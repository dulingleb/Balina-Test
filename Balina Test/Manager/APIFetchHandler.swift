//
//  APIFetchHandler.swift
//  Balina Test
//
//  Created by Dulin Gleb on 28.4.24..
//

import Foundation
import Alamofire
import UIKit

final class APIFetchHandler {
    static let shared = APIFetchHandler()
    
    private let baseUrl = "https://junior.balinasoft.com/api/v2/"
    
    func getPhotos(page: Int = 0, completitionHandler: @escaping (PhotoListModel?, Error?) -> Void) {
        let url = baseUrl + "photo/type"
        let headers = HTTPHeaders.default
        let parameters: Parameters = [
            "page": page
        ]
        AF.request(url, method: .get, parameters: parameters, headers: headers).responseDecodable(of: PhotoListModel.self) { response in
            switch response.result {
            case .success(let value):
                completitionHandler(value, nil)
            case .failure(let error):
                completitionHandler(nil, error)
            }
        }
    }
    
    func sendPhoto(id: Int, image: UIImage, completition: @escaping () -> Void) {
        let url = baseUrl + "photo"
        
        let parameters = [
            "typeId": String(id),
            "name" : "Dulin Gleb"
        ]
        
        let headers: HTTPHeaders = [
            "Content-type": "multipart/form-data",
            "Content-Disposition" : "form-data"
        ]
        
        let imageData = image.jpegData(compressionQuality: 0.8)
        
        guard let imageData = imageData else { return }
        
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imageData, withName: "photo", mimeType: "image/jpg")
            for (key, value) in parameters {
                if let keyData = value.data(using: .utf8){
                    multipartFormData.append(keyData, withName: key)
                }
            }
        }, to: url, method: .post, headers: headers).response { response in
            switch response.result {
            case .success(let success):
                print(success)
                completition()
            case .failure(let error):
                print(error)
            }
        }
    }
}
