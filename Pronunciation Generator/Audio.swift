//
//  Audio.swift
//  Pronunciation Generator
//
//  Created by CaptainYukinoshitaHachiman on 2019/3/1.
//  Copyright © 2019 CaptainYukinoshitaHachiman. All rights reserved.
//

import AVFoundation
import AppKit

extension AVMutableCompositionTrack {
	
	func append(url: URL, scale: Int = 1) {
		for _ in 1...scale {
			let newAsset = AVURLAsset(url: url)
			let range = CMTimeRangeMake(start: .zero, duration: newAsset.duration)
			let end = timeRange.end
			if let track = newAsset.tracks(withMediaType: AVMediaType.audio).first {
				try! insertTimeRange(range, of: track, at: end)
			}
		}
	}
	
	func appendBlank(for seconds: Int) {
		let url = Bundle.main.url(forResource: "blank", withExtension: "wav")!
		append(url: url, scale: seconds)
	}
	
}
