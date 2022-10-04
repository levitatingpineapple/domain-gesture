import SwiftUI
import Charts

public struct DomainGesture<C: View>: View {
	@Binding var domain: ClosedRange<Double>
	@ViewBuilder var chart: () -> C
	@State private var plotSize: CGSize?

	public var body: some View {
		ZStack(alignment: .topLeading) {
			chart()
				.chartXScale(domain: domain)
				.chartPlotStyle {
					$0.background(
						GeometryReader {
							Color.clear.preference(
								key: PlotSizePreferenceKey.self,
								value: $0.size
							)
						}
					)
				}
			Overlay(domain: $domain)
				.frame(
					maxWidth: plotSize?.width,
					maxHeight: plotSize?.height
				)
		}.onPreferenceChange(PlotSizePreferenceKey.self) { plotSize = $0 }
	}
}

extension DomainGesture {
	struct PlotSizePreferenceKey: PreferenceKey {
		static var defaultValue: CGSize { .zero }
		static func reduce(value: inout CGSize, nextValue: () -> CGSize) { }
	}
}

extension DomainGesture {
	public init(
		_ domain: Binding<ClosedRange<Double>>,
		chart: @escaping () -> C
	) { self.init(domain: domain, chart: chart) }
}
