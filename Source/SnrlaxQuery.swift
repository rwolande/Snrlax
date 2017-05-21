//
//  Query.swift
//  Snrlax
//
//  Created by Ryan Wolande on 5/20/17.
//  Copyright © 2017 Ryan Wolande. All rights reserved.
//

import Foundation

//Protocol for managing the result of the query
@objc public protocol QueryDelegate: class
{
        @objc optional func successful_query(query: SnrlaxQuery, body: [String:AnyObject]) //body is returned data from endpoint
        @objc optional func failed_query(query: SnrlaxQuery, error: NSError?)
}

@objc public protocol QueryDataSource: class
{
        @objc optional func body(query: SnrlaxQuery) -> [String:Any] //populate with non-common parameters
}

public class DefaultDataSource: QueryDataSource
{
        static let shared = DefaultDataSource()
        public func body(query: SnrlaxQuery) -> [String:Any]
        {
                return [
                        "coordinate": [
                                "latitude": "42.24", "longitude" : "-83.1"]]
        }
}

/*Best practice may be to subclass wQuery, overriding global_delegate and add_extras_to_body() */
public class SnrlaxQuery: NSObject, URLSessionDelegate, URLSessionTaskDelegate//: NSURLSessionDelegate
{
        //MARK: Member Variables
        public weak var parser_delegate: QueryDelegate? //for success and failure management; best practice to assign to VC
        public weak var data_source: QueryDataSource? //for generating upload; if non-common parameters are required, assign and to VC
        
        //Basic class purposed to correctly generate String->URL and REST method type
        private let endpoint: SnrlaxEndpoint!
        
        public init(endpoint: SnrlaxEndpoint)
        {
                self.endpoint = endpoint
                super.init()
        }
        
        private func success(body: [String:AnyObject])
        {
                Snrlax.shared.global_parser_delegate?.successful_query?(query: self, body: body)
                self.parser_delegate?.successful_query?(query: self, body: body)
                Snrlax.shared.finished_request()
        }
        
        private func failure(error: NSError?)
        {
                Snrlax.shared.global_parser_delegate?.failed_query?(query: self, error: error)
                self.parser_delegate?.failed_query?(query: self, error: error)
                Snrlax.shared.finished_request()
        }
        
        private func create_request() -> NSMutableURLRequest?
        {
                guard let url = self.endpoint.url
                        else
                {
                        self.failure(error: nil)
                        return nil
                }
                do
                {
                        let request: NSMutableURLRequest = NSMutableURLRequest(url: url)
                        request.httpMethod = self.endpoint.rest_method.string
                        
                        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
                        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
                        
                        if let configuration = Snrlax.shared.configuration
                        {
                                for header in configuration._header_keys
                                {
                                        request.setValue(header.value, forHTTPHeaderField: header.key)
                                }
                        }
                        
                        if self.endpoint.rest_method.includes_body
                        {
                                let source_body = self.data_source?.body?(query: self)
                                let body = source_body == nil ? [String:AnyObject]() : source_body!
                                
                                let data = try JSONSerialization.data(withJSONObject: body, options: JSONSerialization.WritingOptions())
                                request.httpBody = data
                        }
                        
                        return request
                }
                catch let e as NSError
                {
                        self.failure(error: e)
                        return nil
                }
        }
        
        //MARK: Member Functions
        
        //Required for SSL
        public func urlSession(_ session: URLSession,
                               task: URLSessionTask,
                               didReceive challenge: URLAuthenticationChallenge,
                               completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?)
                -> Void)
        {
                completionHandler(
                        Foundation.URLSession.AuthChallengeDisposition.performDefaultHandling,
                        URLCredential(trust:
                                challenge.protectionSpace.serverTrust!))
        }
        
        //MARK: ec2
        
        public func request()
        {
                //UIApplication.shared.isNetworkActivityIndicatorVisible = true
                guard let request: URLRequest = create_request() as URLRequest?
                        else
                {
                        self.failure(error: nil)
                        return
                }
                
                let session = Foundation.URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil)
                let task : URLSessionDataTask = session.dataTask(with: request, completionHandler:
                {
                        (data, response, error) in
                        do
                        {
                                if data == nil
                                {
                                        self.failure(error: nil)
                                        return
                                }
                                
                                guard let body = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? Dictionary<String, AnyObject>
                                        else
                                {
                                        self.failure(error: nil)
                                        return
                                }
                                
                                self.success(body: body)
                        }
                        catch let e as NSError
                        {
                                self.failure(error: e)
                                return
                        }
                })
                task.resume()
        }
        
        //MARK: request helpers
        
        //MARK: Delegate Methods
}
