//
//  SnrlaxMediaCache.swift
//  Snrlax
//
//  Created by Ryan Wolande on 5/20/17.
//  Copyright © 2017 Ryan Wolande. All rights reserved.
//

import Foundation
import UIKit

public class SnrlaxMediaCache
{
        let _type: SnrlaxMediaManager.MediaType!
        private var cached_media = [String:AnyObject]()
        private var pending_keys = [String:Bool]()
        private var pending_views = [String:[UIImageView]]()
        
        init(type: SnrlaxMediaManager.MediaType)
        {
                _type = type
        }
        
        func get(key: String) -> AnyObject?
        {
                return cached_media[key]
        }
        
        func removeAll()
        {
                pending_keys.removeAll()
                pending_views.removeAll()
        }
        
        public func download(media_endpoint: String, image_view: UIImageView?)
        {
                if pending_views[media_endpoint] == nil
                {
                        pending_views[media_endpoint] = [UIImageView]()
                }
                if image_view != nil
                {
                        pending_views[media_endpoint]!.append(image_view!)
                }
                
                if cached_media[media_endpoint] != nil
                {
                        update_views(media_endpoint: media_endpoint)
                        return
                }
                
                if pending_keys[media_endpoint] != nil && pending_keys[media_endpoint]!
                {
                        //already downloading
                        return
                }
                
                download(media_endpoint: media_endpoint)
        }
        
        private func get_data_from_url(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
                URLSession.shared.dataTask(with: url) {
                        (data, response, error) in
                        completion(data, response, error)
                        }.resume()
        }
        
        private func download(media_endpoint: String)
        {
                pending_keys[media_endpoint] = true
                
                let url = URL(string: media_endpoint)!
                get_data_from_url(url: url) { (data, response, error)  in
                        guard let data = data, error == nil
                                else
                        {
                                return
                        }
                        if let image = UIImage(data: data)
                        {
                                self.cached_media[media_endpoint] = image
                                DispatchQueue.main.async()
                                        {
                                                () -> Void in
                                                self.update_views(media_endpoint: media_endpoint)
                                }
                        }
                }
                
        }
        
        private func update_views(media_endpoint: String)
        {
                pending_keys[media_endpoint] = nil
                if var views = self.pending_views[media_endpoint]
                {
                        if views.isEmpty
                        {
                                return
                        }
                        if let image = get(key: media_endpoint) as? UIImage
                        {
                                while !views.isEmpty
                                {
                                        if let view = views.last
                                        {
                                                view.image = image
                                                views.removeLast()
                                        }
                                }
                        }
                }
        }
}
