//
//  Endpoint.swift
//  Snrlax
//
//  Created by Ryan Wolande on 5/20/17.
//  Copyright © 2017 Ryan Wolande. All rights reserved.
//

import Foundation

public struct SnrlaxEndpoint
{
        public enum RESTmethod
        {
                case POST
                case GET
                case PUT
                case DELETE
                
                var includes_body: Bool
                {
                        return self == .POST || self == .PUT
                }
                
                var string: String
                {
                        switch self
                        {
                        case .POST:
                                return "POST"
                        case .GET:
                                return "GET"
                        case .PUT:
                                return "PUT"
                        case .DELETE:
                                return "DELETE"
                        }
                }
        }
        let rest_method: RESTmethod!
        let literal: String!
        
        var url: URL?
        {
                var complete = "https://"
                if let configuration = Snrlax.shared.configuration
                {
                        complete += configuration._host
                }
                complete += literal
                return URL(string: complete)
        }
        
        public init(literal: String, rest_method: RESTmethod = .GET)
        {
                self.literal = literal
                self.rest_method = rest_method
        }
}
