//
//  URLBuilder.swift
//  WeatherForecast
//
//  Created by Admin on 29.05.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

class URLBuilder {
    
    private var components: URLComponents
    
    init() {
        self.components = URLComponents()
    }
    
    func set(scheme: String) -> URLBuilder {
        self.components.scheme = scheme
        return self
    }
    
    func set(host: String) -> URLBuilder {
        self.components.host = host
        return self
    }
    
    func set(port: Int) -> URLBuilder {
        self.components.port = port
        return self
    }
    
    func set(path: String) -> URLBuilder {
        var path = path
        if !path.hasPrefix("/") {
            path = "/" + path
        }
        self.components.path = path
        return self
    }
    
    func addQueryItem(name: String, value: String) -> URLBuilder  {
        if self.components.queryItems == nil {
            self.components.queryItems = []
        }
        self.components.queryItems?.append(URLQueryItem(name: name, value: value))
        return self
    }
    
    func addQueryItems(_ items: [URLQueryItem]) -> URLBuilder {
        self.components.queryItems = items
        return self
    }
    
    func build() -> URL? {
        return self.components.url
    }
}
