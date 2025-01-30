import SwiftUI

public protocol ExpressibleByDouble: Comparable {
	var double: Double { get }
	init(_ double: Double)
}

extension TimeInterval: ExpressibleByDouble {
	public var double: Double { self }
	public init(_ double: Double) { self = double }
}

extension Date: ExpressibleByDouble {
	public var double: Double { timeIntervalSince1970 }
	public init(_ double: Double) { self = Date(timeIntervalSince1970: double) }
}
