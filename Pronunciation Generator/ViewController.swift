//
//  ViewController.swift
//  Pronunciation Generator
//
//  Created by CaptainYukinoshitaHachiman on 2019/3/1.
//  Copyright © 2019 CaptainYukinoshitaHachiman. All rights reserved.
//

import Cocoa
import AVFoundation
import AudioKit

class ViewController: NSViewController {
	
	@IBOutlet weak var textView: NSTextView!
	
	var words: [String]?
	
	var audioDictionary = [String:URL]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}

	@IBAction func donwloadAndCombine(_ sender: Any) {
		let text = textView.textStorage?.string
		words = text?.split(separator: "\n").map { return String($0) }
		words?.forEach({ (word) in
			download(word: word)
		})
	}
	
	func download(word: String) {
		provider.request(.collinsLearner(word: word)) { (result) in
			switch result {
			case let .success(response):
				if response.statusCode == 200 {
					if let mp3URL = URL.generateRandomTemporaryURL()?.appendingPathExtension("mp3"),
						let wavURL = URL.generateRandomTemporaryURL()?.appendingPathExtension("wav") {
						try? response.data.write(to: mp3URL)
						let converter = AKConverter(inputURL: mp3URL, outputURL: wavURL)
						converter.start(completionHandler: { (error) in
							if let error = error {
								NSLog("Convert Error: %@", error.localizedDescription)
							} else {
								DispatchQueue.main.async {
									self.audioDictionary[word] = wavURL
									if self.audioDictionary.count == self.words?.count {
										self.combine()
									}
								}
							}
						})
					}
				} else {
					// Handle
				}
			case let .failure(error):
				NSLog("Failed to Download: %@", error.localizedDescription)
				self.download(word: word)
			}
		}
	}
	
	func combine() {
		let composition = AVMutableComposition()
		let compositionAudioTrack = composition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid)
		words?.forEach { word in
			let singleURL = audioDictionary[word]!
			compositionAudioTrack?.append(url: singleURL)
			compositionAudioTrack?.appendBlank(for: 3)
		}
		let export = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetPassthrough)!
		export.outputFileType = .wav
		let panel = NSSavePanel()
		panel.directoryURL = FileManager.default.homeDirectoryForCurrentUser
		let formatter = DateFormatter()
		formatter.dateStyle = .short
		panel.nameFieldStringValue = "\(formatter.string(from: Date())).wav"
		panel.beginSheetModal(for: view.window!) { (result) in
			if result == .OK,
				let url = panel.url {
				export.outputURL = url
				
				DispatchQueue.main.async {
					export.exportAsynchronously {
						if let errorInfo = export.error?.localizedDescription {
							NSLog("Failed to combine: %@", errorInfo)
						} else {
							print("Done at \(url.absoluteString)")
						}
					}
					
				}
			}
		}
	}
	
}

