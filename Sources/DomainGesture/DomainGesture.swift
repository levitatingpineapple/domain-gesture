import SwiftUI
import Charts

public struct DomainGesture<C: View>: View {
	@Binding var domain: ClosedRange<Double>
	let onEnded: () -> Void
	@ViewBuilder var chart: () -> C

	public var body: some View {
		ZStack(alignment: .topLeading) {
			chart()
			Overlay(domain: $domain, onEnded: onEnded)
		}
	}
}

extension DomainGesture {
	public init(
		_ domain: Binding<ClosedRange<Double>>,
		onEnded: @escaping () -> Void = { },
		chart: @escaping () -> C
	) { self.init(domain: domain, onEnded: onEnded, chart: chart) }
}
