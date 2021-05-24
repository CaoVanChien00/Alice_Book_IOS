//
//  Category.swift
//  Alice Book
//
//  Created by Alice on 5/23/21.
//  Copyright © 2021 Alice. All rights reserved.
//

import Foundation

class CategoryDecodable: Decodable {
    var id: Int
    var name: String
    var description: String
    var thumb: String
    var upload: String
    var update: String
}

class Category {
    var id: Int?
    var name: String?
    var description: String?
    var thumb: String?
    var upload: String?
    var update: String?
    
    init() {
    }
    
    init(decodable: CategoryDecodable) {
        self.id = decodable.id
        self.name = decodable.name
        self.description = decodable.description
        self.thumb = decodable.thumb
        self.upload = decodable.upload
        self.update = decodable.update
    }
}
