//
//  RequestBuilder.swift
//  Pokedex
//
//  Created by Freak on 08.05.2026.
//
import Foundation

class RequestBuilder {

    static func buildRequest(
        to url: URL,
        for query: String,
        with body: [String: Any]
    ) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        return request
    }

}
