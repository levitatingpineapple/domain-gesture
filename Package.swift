// swift-tools-version: 6.0
import PackageDescription

let package = Package(
	name: "DomainGesture",
	platforms: [.iOS(.v18)],
	products: [.library(name: "DomainGesture", targets: ["DomainGesture"])],
	targets: [.target(name: "DomainGesture")]
)
