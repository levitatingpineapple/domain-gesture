import SwiftUI

public struct DomainXGesture<Bound: ExpressibleByDouble>: UIGestureRecognizerRepresentable {
	@Binding var domain: ClosedRange<Bound>
	let simultaneous: Bool
	let onEnded: () -> Void
	
	@State private var leading: Double?
	@State private var leadingValue: Double?
	@State private var trailingValue: Double?
	
	/// A gesture for panning the chart's X domain.
	/// - Parameters:
	///   - domain: A binding to the domain. Must conform to `ExpressibleByDouble`.
	///   - simultaneous: Allows the gesture to be recognized simultaneously with other gestures.
	///     Useful when placing the chart in a vertical scroll view.
	///   - onEnded: A block that gets executed when the gesture ends.
	public init(
		domain: Binding<ClosedRange<Bound>>,
		simultaneous: Bool = false,
		onEnded: @escaping () -> () = {}
	) {
		self._domain = domain
		self.simultaneous = simultaneous
		self.onEnded = onEnded
	}
	
	public func makeUIGestureRecognizer(context: Context) -> GestureRecognizer {
		GestureRecognizer(simultaneous: simultaneous)
	}
	
	public func updateUIGestureRecognizer(_ recognizer: GestureRecognizer, context: Context) {
		recognizer.simultaneous = simultaneous
	}
	
	public func handleUIGestureRecognizerAction(_ recognizer: GestureRecognizer, context: Context) {
		let lowerBound = domain.lowerBound.double
		let upperBound = domain.upperBound.double
		switch recognizer.interaction {
		case .pan(let x, let isInitial):
			if isInitial { leading = x }
			if let leading {
				let offset = (upperBound - lowerBound) * (leading - x)
				domain = Bound(lowerBound + offset)...Bound(upperBound + offset)
				self.leading = x
			}
		case .pinch(let leadingX, let trailingX, let isInitial):
			if leadingX == trailingX { return }
			if isInitial {
				let m = upperBound - lowerBound
				leadingValue = (m * leadingX) + lowerBound
				trailingValue = (m * trailingX) + lowerBound
			}
			if let leadingValue, let trailingValue {
				let m = (trailingValue - leadingValue) / (trailingX - leadingX)
				let b = leadingValue - m * leadingX
				domain = Bound(b)...Bound(b + m)
			}
		case nil:
			onEnded()
		}
	}
}

