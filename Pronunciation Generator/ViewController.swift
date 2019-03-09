//
//  ViewController.swift
//  Pronunciation Generator
//
//  Created by CaptainYukinoshitaHachiman on 2019/3/1.
//  Copyright © 2019 CaptainYukinoshitaHachiman. All rights reserved.
//

import Cocoa
import AVFoundation
import SwiftyJSON

class ViewController: NSViewController {
	
	@IBOutlet weak var textView: NSTextView!
	
	var words = [String]()
	
	var audioDictionary = [String:URL]()
	
	var finished = [String]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}

	@IBAction func donwloadAndCombine(_ sender: Any) {
		audioDictionary = [:]
		finished = []
		words = []
		
		let text = textView.textStorage?.string
		words = text?.split(separator: "\n").map { return String($0) } ?? []
		words.forEach({ (word) in
			download(word: word)
		})
	}
	
	func download(word: String) {
		getAudio(forWord: word) { (url) in
			guard let url = url else {
				return
			}
			self.audioDictionary[word] = url
			if self.audioDictionary.count == self.words.count {
				self.combine()
			}
		}

	}
	
	func getAudio(forWord word: String, callback: @escaping (URL?) -> ()) {
		requestLearners(with: word) { (learnersResult) in
			if let filename = learnersResult {
				self.requestAudio(forFilename: filename, callback: callback)
			} else {
				self.requestCollegiate(with: word, callback: { (collegiateResult) in
					guard let filename = collegiateResult else {
						NSLog("Word %@ Not Found", word)
						// Alert
						return
					}
					self.requestAudio(forFilename: filename, callback: callback)
				})
			}
		}
	}
	
	func requestAudio(forFilename filename: String, callback: @escaping (URL?) -> ()) {
		provider.request(.audio(filename: filename)) { (result) in
			switch result {
			case .success(let response):
				guard response.statusCode == 200 else {
					NSLog("Failed to get audio file with code %@", response.statusCode)
					callback(nil)
					return
				}
				do {
					let url = URL.generateRandomTemporaryURL()!.appendingPathExtension("wav")
					try response.data.write(to: url)
					callback(url)
				} catch {
					NSLog("Failed to write audio file: %@", error.localizedDescription)
					callback(nil)
				}
			case .failure(let error):
				NSLog("Failed to get audio file: %@", error.localizedDescription)
				callback(nil)
			}
		}
	}
	
	func requestCollegiate(with word: String, callback: @escaping (String?) -> ()) {
		provider.request(.collegiate(word: word)) { (result) in
			switch result {
			case .success(let response):
				do {
					let data = response.data
					let json = try JSON(data: data)
					let filename = json[0]["hwi"]["prs"][0]["sound"]["audio"].string
					callback(filename)
				} catch {
					NSLog("Failed to unwrap Collegiate: %@", error.localizedDescription)
					callback(nil)
				}
			case .failure(let error):
				NSLog("Failed to request Collegiate: %@", error.localizedDescription)
				callback(nil)
			}
		}
	}
	
	func requestLearners(with word: String, callback: @escaping (String?) -> ()) {
		provider.request(.learners(word: word)) { (result) in
			switch result {
			case .success(let response):
				do {
					let data = response.data
					let json = try JSON(data: data)
					let filename = json[0]["hwi"]["prs"][0]["sound"]["audio"].string
					callback(filename)
				} catch {
					NSLog("Failed to unwrap Learners: %@", error.localizedDescription)
					callback(nil)
				}
			case .failure(let error):
				NSLog("Failed to request Learners: %@", error.localizedDescription)
				callback(nil)
			}
		}
	}
	
	func combine() {
		let composition = AVMutableComposition()
		let compositionAudioTrack = composition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid)
		words.forEach { word in
			if let singleURL = audioDictionary[word] {
				compositionAudioTrack?.append(url: singleURL)
				self.finished += [word]
				if self.finished.count < self.words.count {
					compositionAudioTrack?.appendBlank()
				}
			}
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
				
				let manager = FileManager(authorization: .init())
				if manager.fileExists(atPath: url.path) {
					do {
						try manager.removeItem(atPath: url.path)
					} catch {
						NSLog("Failed to remove: %@", error.localizedDescription)
					}
				}
				
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

