import SwiftUI

extension Overlay {
	class GestureView: UIView {
		let perform: (DomainGestureRecognizer.Interaction) -> Void
		
		init(perform: @escaping (DomainGestureRecognizer.Interaction) -> Void) {
			self.perform = perform
			super.init(frame: .zero)
			addGestureRecognizer(
				DomainGestureRecognizer(
					target: self,
					action: #selector(handle)
				)
			)
			backgroundColor = .clear
		}
		
		required init?(coder: NSCoder) { fatalError("Missing Coder") }
		
		@objc func handle(_ recognizer: DomainGestureRecognizer) {
			if let interaction = recognizer.interaction { perform(interaction) }
		}
	}
}
