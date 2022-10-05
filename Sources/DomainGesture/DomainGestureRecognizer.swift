import SwiftUI

class DomainGestureRecognizer: UIGestureRecognizer {
	enum Interaction {
		case pan(x: Double, isInitial: Bool)
		case pinch(leadingX: CGFloat, trailingX: CGFloat, isInitial: Bool)
	}
	
	var interaction: Interaction?
	private var retainedTouches = Set<UITouch>()
	private var initialInteraction = true
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
		switch retainedTouches.count + touches.count {
		case 1:
			retainedTouches = retainedTouches.union(touches)
			initialInteraction = true
			state = .began
		case 2:
			retainedTouches = retainedTouches.union(touches)
			initialInteraction = true
			state = .changed
		default: break
		}
	}
	
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
		if !retainedTouches.intersection(touches).isEmpty {
			setInteraction(isInitial: initialInteraction)
			initialInteraction = false
			state = .changed
		}
	}
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
		retainedTouches = retainedTouches.subtracting(touches)
		if retainedTouches.isEmpty {
			interaction = nil
			state = .ended
		}
		else { setInteraction(isInitial: true) }
	}
	
	override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
		retainedTouches = retainedTouches.subtracting(touches)
		if retainedTouches.isEmpty {
			interaction = nil
			state = .cancelled
		}
		else { setInteraction(isInitial: true) }
	}
	
	private func setInteraction(isInitial: Bool) {
		if let view {
			let locations = retainedTouches.map { $0.location(in: view).x / view.frame.width }
			switch locations.count {
			case 1:
				interaction = .pan(
					x: locations.first!,
					isInitial: isInitial
				)
			case 2:
				interaction = .pinch(
					leadingX: locations.min()!,
					trailingX: locations.max()!,
					isInitial: isInitial
				)
			default: fatalError("No interaction for \(retainedTouches.count) touches.")
			}
		}
	}
}
