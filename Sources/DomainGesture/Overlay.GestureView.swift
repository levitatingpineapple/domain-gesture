import SwiftUI

extension Overlay {
	class View: UIView, UIGestureRecognizerDelegate {
		let perform: (DomainGestureRecognizer.Interaction?) -> Void
		
		init(perform: @escaping (DomainGestureRecognizer.Interaction?) -> Void) {
			self.perform = perform
			super.init(frame: .zero)
			backgroundColor = .clear
			let recognzer = DomainGestureRecognizer(
				target: self,
				action: #selector(handle)
			)
			addGestureRecognizer(recognzer)
			recognzer.delegate = self
		}
		
		required init?(coder: NSCoder) { fatalError("Missing Coder") }
		
		@objc func handle(_ recognizer: DomainGestureRecognizer) {
			switch recognizer.state {
			case .changed, .ended, .cancelled:
				perform(recognizer.interaction)
			default: break
			}
			
		}
		
		func gestureRecognizer(
			_: UIGestureRecognizer,
			shouldRecognizeSimultaneouslyWith: UIGestureRecognizer
		) -> Bool { true }
	}
}
