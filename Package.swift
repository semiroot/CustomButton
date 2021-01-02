// swift-tools-version:5.3
import PackageDescription

let package = Package(
	name: "CustomButton",
	platforms: [
		.macOS(.v10_14)
	],
	products: [
		.library(
			name: "CustomButton",
			targets: [
				"CustomButton"
			]
		)
	],
	targets: [
		.target(
			name: "CustomButton"
		)
	]
)
