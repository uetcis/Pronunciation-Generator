//
//  AppDelegate.swift
//  Pronunciation Generator
//
//  Created by CaptainYukinoshitaHachiman on 2019/3/1.
//  Copyright © 2019 CaptainYukinoshitaHachiman. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

	var windowControlelr: NSWindowController!

	func applicationDidFinishLaunching(_ aNotification: Notification) {
		let storyboard = NSStoryboard(name: .init("Main"), bundle: .main)
		windowControlelr = storyboard.instantiateInitialController() as? NSWindowController
	}

	func applicationWillTerminate(_ aNotification: Notification) {
		// Insert code here to tear down your application
	}
	
	func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
		if !flag {
			NSApp.activate(ignoringOtherApps: false)
			windowControlelr.window?.makeKeyAndOrderFront(self)
		}
		return true
	}


}

