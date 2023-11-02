//
//  YouTubeSearchResponce.swift
//  NetflixClone
//
//  Created by Adinay on 2/11/23.
//

import Foundation

struct YouTubeSearchResponce: Codable {
    let items: [VideoElement]
}

struct VideoElement: Codable {
    let id: InVideoElement
}

struct InVideoElement: Codable {
    let kind: String
    let videoId: String
}


//items =     (
//            {
//        etag = "1k_2VICe9CwIL2r7AsJyzX64FMQ";
//        id =             {
//            kind = "youtube#video";
//            videoId = qIehnUeMNLk;
//        };
//        kind = "youtube#searchResult";
//    },
