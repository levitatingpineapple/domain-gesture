import SwiftUI

@available(iOS 18.0, *)
extension DomainXGesture {
	public class GestureRecognizer: UIGestureRecognizer, UIGestureRecognizerDelegate {
		enum Interaction {
			case pan(x: Double, isInitial: Bool)
			case pinch(leadingX: CGFloat, trailingX: CGFloat, isInitial: Bool)
		}
		
		var simultaneous: Bool
		var interaction: Interaction?
		private var retainedTouches = Set<UITouch>()
		private var initialInteraction = true
		
		init(simultaneous: Bool) {
			self.simultaneous = simultaneous
			super.init(target: nil, action: nil)
			self.delegate = self
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
		
		// MARK: UIGestureRecognizer overrides
		
		public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
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
		
		public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
			if !retainedTouches.intersection(touches).isEmpty {
				setInteraction(isInitial: initialInteraction)
				initialInteraction = false
				state = .changed
			}
		}
		
		public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
			retainedTouches = retainedTouches.subtracting(touches)
			if retainedTouches.isEmpty {
				interaction = nil
				state = .ended
			}
			else { setInteraction(isInitial: true) }
		}
		
		public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
			retainedTouches = retainedTouches.subtracting(touches)
			if retainedTouches.isEmpty {
				interaction = nil
				state = .cancelled
			}
			else { setInteraction(isInitial: true) }
		}
		
		// MARK: UIGestureRecognizerDelegate
		
		public func gestureRecognizer(
			_: UIGestureRecognizer,
			shouldRecognizeSimultaneouslyWith: UIGestureRecognizer
		) -> Bool { simultaneous }
	}
}
