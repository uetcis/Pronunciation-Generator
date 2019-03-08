//
//  Network.swift
//  Pronunciation Generator
//
//  Created by CaptainYukinoshitaHachiman on 2019/3/1.
//  Copyright © 2019 CaptainYukinoshitaHachiman. All rights reserved.
//

import Moya

enum CollinsPronunciationAudio {
	case collinsLearner(word: String)
}

extension CollinsPronunciationAudio: TargetType {
	
	var baseURL: URL {
		return URL(string: "https://www.collinsdictionary.com/")!
	}
	
	var path: String {
		switch self {
		case let .collinsLearner(word):
			return "us/sounds/e/en_/en_us/en_us_\(word).mp3"
		}
	}
	
	var method: Method {
		return .get
	}
	
	var sampleData: Data {
		return Data()
	}
	
	var task: Task {
		return Task.requestPlain
	}
	
	var headers: [String : String]? {
		return nil
	}
	
	
}

let provider = MoyaProvider<CollinsPronunciationAudio>()
