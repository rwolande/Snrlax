//
//  SnrlaxMediaManager.swift
//  Snrlax
//
//  Created by Ryan Wolande on 5/20/17.
//  Copyright © 2017 Ryan Wolande. All rights reserved.
//

import Foundation
import UIKit

public class SnrlaxMediaManager
{
        public enum MediaType
        {
                case thumbnail
                case image
                //case gif
                //case video
                
                static func all() -> [MediaType]
                {
                        return [.thumbnail, .image]//, .video]
                }
        }
        
        init()
        {
                self.update(media_types: MediaType.all())
        }
        
        private var caches = [MediaType:SnrlaxMediaCache]()
        
        func update(media_types: [MediaType])
        {
                for m in MediaType.all()
                {
                        if let cache = caches[m]
                        {
                                cache.removeAll()
                        }
                }
                caches.removeAll()
                for m in media_types
                {
                        caches[m] = SnrlaxMediaCache(type: m)
                }
        }
        
        func pull(endpoint: String, media_type: MediaType, image_view: UIImageView?)
        {
                guard let cache = caches[media_type]
                        else
                {
                        return
                }
                cache.download(media_endpoint: endpoint, image_view: image_view)
        }
}
