//
//  URL+Temporary.swift
//  Pronunciation Generator
//
//  Created by CaptainYukinoshitaHachiman on 2019/3/2.
//  Copyright © 2019 CaptainYukinoshitaHachiman. All rights reserved.
//

import Foundation

extension URL {
	
	static func generateRandomTemporaryURL() -> URL? {
		let directory = NSTemporaryDirectory()
		let fileName = NSUUID().uuidString
		
		return NSURL.fileURL(withPathComponents: [directory, fileName])
	}
	
}
