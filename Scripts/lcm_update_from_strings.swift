#!/usr/bin/swift sh

import Foundation

import SwiftShell // @kareman ~> 5.1.0


/* swift-sh creates a binary whose path is not one we expect, so we cannot use
 * main.path directly.
 * Using the _ env variable is **extremely** hacky, but seems to do the job…
 * See https://github.com/mxcl/swift-sh/issues/101 */
let filepath = ProcessInfo.processInfo.environment["_"] ?? main.path
main.currentdirectory = URL(fileURLWithPath: filepath).deletingLastPathComponent().appendingPathComponent("..").path



do {
	guard main.arguments.count == 0 else {
		exit(errormessage: "usage: \(filepath)")
	}
	
	try runAndPrint(
		"locmapper", "merge_xcode_locs",
		"--csv-separator=,",
		"--exclude-list=.git/,Scripts/",
		"--include-list=/en.lproj/",
		".", "Locs.lcm",
		"en.lproj", " English"
	)
} catch {
	exit(error)
}
