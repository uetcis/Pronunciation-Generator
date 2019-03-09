//
//  LearnersDictionary.swift
//  Pronunciation Generator
//
//  Created by CaptainYukinoshitaHachiman on 2019/3/8.
//  Copyright © 2019 CaptainYukinoshitaHachiman. All rights reserved.
//

struct LearnersDictionary: Codable {
	struct Hwi: Codable {
		struct Prs: Codable {
			struct Sound: Codable {
				let audio: String
			}
			let sound: Sound
		}
		let prs: [Prs]?
	}
	let hwi: Hwi
}
