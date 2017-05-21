//
//  Snrlax.swift
//  Snrlax
//
//  Created by Ryan Wolande on 5/20/17.
//  Copyright © 2017 Ryan Wolande. All rights reserved.
//

import Foundation
import UIKit

public class SnrlaxServiceConfiguration
{
        let _host: String!
        let _header_keys: [String:String]!
        var ssl: Bool = true
        
        init(host: String, header_keys: [String:String] = [String:String]())
        {
                self._host = host
                self._header_keys = header_keys
        }
}

public class Snrlax
{
        public static let shared = Snrlax()
        public let media_manager = SnrlaxMediaManager()
        open var configuration: SnrlaxServiceConfiguration?
        open var global_parser_delegate: QueryDelegate?
        open var global_data_source: QueryDataSource?
        private var dispatched_count: Int = 0
        {
                didSet
                {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = dispatched_count > 0
                }
        }
        
        
        func request(endpoint: SnrlaxEndpoint, parser_delegate: QueryDelegate? = nil, data_source: QueryDataSource? = nil)
        {
                let query = SnrlaxQuery(endpoint: endpoint)
                query.parser_delegate = parser_delegate
                query.data_source = data_source == nil ? self.global_data_source : data_source!
                query.request()
                
                self.began_request()
        }
        
        func began_request()
        {
                self.dispatched_count += 1
        }
        
        func finished_request()
        {
                self.dispatched_count -= 1
        }
        
        
}

