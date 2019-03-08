//
//  Network.swift
//  Pronunciation Generator
//
//  Created by CaptainYukinoshitaHachiman on 2019/3/1.
//  Copyright © 2019 CaptainYukinoshitaHachiman. All rights reserved.
//

import Moya
import Keys

private let keys = PronunciationGeneratorKeys()

enum WebsterDictionary {
	case collegiate(word: String)
	case learners(word: String)
	case audio(filename: String)
}

extension WebsterDictionary: TargetType {
	
	var baseURL: URL {
		switch self {
		case .audio(filename: _):
			return URL(string: "https://media.merriam-webster.com/")!
		default:
			return URL(string: "https://www.dictionaryapi.com/")!
		}
	}
	
	var path: String {
		switch self {
		case .collegiate(let word):
			return "api/v3/references/collegiate/json/\(word)?key=\(keys.collegiateDictionaryAPIKey)"
		case .learners(let word):
			return "api/v3/references/learners/json/\(word)?key=\(keys.learnersDictionaryAPIKey)"
		case .audio(let filename):
			let firstLetter = filename.first
			return "soundc11/\(firstLetter ?? "a")/\(filename).wav"
		}
	}
	
	var method: Moya.Method {
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

let provider = MoyaProvider<WebsterDictionary>()
