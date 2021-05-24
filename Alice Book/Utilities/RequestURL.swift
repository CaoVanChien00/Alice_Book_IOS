//
//  RequestURL.swift
//  Alice Book
//
//  Created by Alice on 5/23/21.
//  Copyright © 2021 Alice. All rights reserved.
//

import Foundation

class RequestURL {
    var url: URL?
    var boundary = "Boundary-\(UUID().uuidString)"
    var request: URLRequest?
    var formFields = [String: Any]()
    
    init(url: String) {
        self.url = URL(string: url)
        setupRequest()
    }
    
    func addFormString(name: String, value: String) {
        self.formFields[name] = value
    }
    
    func addFormData(name: String, fileName: String, mimeType: String, fileData: Data) {
        let tempArray: [String: Any] = ["fileName": fileName, "mimeType": mimeType, "fileData": fileData]
        self.formFields[name] = tempArray
    }
    
    private func convertFieldString(name: String, value: String, boundary: String) -> String {
        var fieldString = "--\(self.boundary)\r\n"
        fieldString += "Content-Disposition: form-data; name=\(name)\r\n"
        fieldString += "\r\n"
        fieldString += "\(value)\r\n"
        return fieldString
    }
    
    private func convertFileData(fieldName: String, fileName: String, mimeType: String, fileData: Data, using boundary: String) -> Data {
        let data = NSMutableData()
        
        data.appendString("--\(boundary)\r\n")
        data.appendString("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n")
        data.appendString("Content-Type: \(mimeType)\r\n\r\n")
        data.append(fileData)
        data.appendString("\r\n")
        
        return data as Data
    }
    
    private func createHttpBody() -> NSMutableData {
        let httpBody = NSMutableData()
        
        for (key, value) in self.formFields {
            if let value = value as? String {
                httpBody.appendString(convertFieldString(name: key, value: value, boundary: self.boundary))
            } else {
                if let value = value as? [String: Any] {
                    if let fileName = value["fileName"] as? String, let mimeType = value["mimeType"] as? String, let data = value["fileData"] as? Data {
                        httpBody.append(convertFileData(fieldName: key, fileName: fileName, mimeType: mimeType, fileData: data, using: self.boundary))
                    }
                }
            }
            
        }
        
        httpBody.appendString("--\(boundary)--")
        
        return httpBody
    }
    
    func getRequest() -> URLRequest {
        self.request?.httpBody = createHttpBody() as Data
        return self.request!
    }
    
    private func setupRequest() {
        if let url = self.url {
            self.request = URLRequest(url: url)
        }
        
        self.request?.httpMethod = "POST"
        self.request?.setValue("multipart/form-data; boundary=\(self.boundary)", forHTTPHeaderField: "Content-Type")
    }
}

extension NSMutableData {
    func appendString(_ string: String) {
        if let data = string.data(using: .utf8) {
            self.append(data)
        }
    }
}
