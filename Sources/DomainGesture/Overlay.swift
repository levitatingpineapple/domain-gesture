import SwiftUI

struct Overlay: UIViewRepresentable {
	@Binding var domain: ClosedRange<Double>
	let onEnded: () -> ()
	
	@State private var leading: Double?
	@State private var leadingValue: Double?
	@State private var trailingValue: Double?
	
	func makeUIView(context: Context) -> UIView {
		View() {
			switch $0 {
			case .pan(let x, let isInitial):
				if isInitial { leading = x }
				if let leading {
					let offset = (domain.upperBound - domain.lowerBound) * (leading - x)
					domain = domain.lowerBound + offset...domain.upperBound + offset
					self.leading = x
				}
			case .pinch(let leadingX, let trailingX, let isInitial):
				if leadingX == trailingX { return }
				if isInitial {
					let m = domain.upperBound - domain.lowerBound
					leadingValue = (m * leadingX) + domain.lowerBound
					trailingValue = (m * trailingX) + domain.lowerBound
				}
				if let leadingValue, let trailingValue {
					let m = (trailingValue - leadingValue) / (trailingX - leadingX)
					let b = leadingValue - m * leadingX
					domain = b...b + m
				}
			case nil:
				onEnded()
			}
		}
	}
	
	func updateUIView(_: UIView, context: Context) { }
}
