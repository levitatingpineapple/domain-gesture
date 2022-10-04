// swift-tools-version: 5.7
import PackageDescription

let package = Package(
	name: "DomainGesture",
	platforms: [.iOS(.v16)],
	products: [.library(name: "DomainGesture", targets: ["DomainGesture"])],
	targets: [.target(name: "DomainGesture")]
)
