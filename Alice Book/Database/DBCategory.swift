//
//  DBCategory.swift
//  Alice Book
//
//  Created by Alice on 5/23/21.
//  Copyright © 2021 Alice. All rights reserved.
//

import UIKit

class DBCategory {
    
    //Decodable request
    class Request: Decodable {
        var msg: String
        var id: Int?
        var status: Bool
        var data: [CategoryDecodable]?
    }
    
    //Variable
    var url: String?
    
    //Contrustor
    init(url: String) {
        self.url = url
    }
    
    //get all category
    func getAll(completion: @escaping ([Category])->()) {
        let urlRequest = RequestURL(url: self.url!);
        var tmpArr = [Category]()
        
        urlRequest.addFormString(name: "type", value: "getall")
        
        self.request(urlRequest: urlRequest) { (data) in
            if let data = data, data.status == true {
                if let arr = data.data {
                    for item in arr {
                        tmpArr.append(Category(decodable: item))
                    }
                }
            }
            
            completion(tmpArr)
        }
    }
    
    //insert category
    func insert(category: Category, image: UIImage, completion: @escaping ()->()) {
        let urlRequest = RequestURL(url: self.url!);
        
        urlRequest.addFormString(name: "type", value: "insert")
        urlRequest.addFormString(name: "name", value: category.name!)
        urlRequest.addFormString(name: "description", value: category.description!)
        urlRequest.addFormData(name: "thumb", fileName: "image.jpg", mimeType: "image", fileData: image.pngData()!)
        
        self.request(urlRequest: urlRequest) { (data) in
            if let data = data, data.status == true {
                print(data.msg)
            }
        }
    }
    
    //upload category
    func update(category: Category, image: UIImage, completion: @escaping ()->()) {
        let urlRequest = RequestURL(url: self.url!);
        
        urlRequest.addFormString(name: "type", value: "update")
        urlRequest.addFormString(name: "id", value: String(category.id!))
        urlRequest.addFormString(name: "name", value: category.name!)
        urlRequest.addFormString(name: "description", value: category.description!)
        urlRequest.addFormData(name: "thumb", fileName: "image.jpg", mimeType: "image", fileData: image.pngData()!)
        
        self.request(urlRequest: urlRequest) { (data) in
            if let data = data, data.status == true {
                print(data.msg)
            }
        }
    }
    
    //upload category
    func delete(category: Category, completion: @escaping ()->()) {
        let urlRequest = RequestURL(url: self.url!);
        
        urlRequest.addFormString(name: "type", value: "delete")
        urlRequest.addFormString(name: "id", value: String(category.id!))
        
        self.request(urlRequest: urlRequest) { (data) in
            if let data = data, data.status == true {
                print(data.msg)
            }
        }
    }
    
    //Request
    func request(urlRequest: RequestURL, completion: @escaping (Request?)->()) {
        let request = urlRequest.getRequest()
        URLSession.shared.dataTask(with: request) { (data, _, _) in
            if let data = data {
                do {
                    
                    let json = try JSONDecoder().decode(Request.self, from: data)
                    
                    completion(json)
                    
                } catch {
                    completion(nil)
                }
                print(String(bytes: data, encoding: .utf8) ?? "Not show")
            } else {
                completion(nil)
            }
            }.resume()
    }
}
