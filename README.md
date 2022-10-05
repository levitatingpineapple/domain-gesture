# Domain Gesture

```swift
DomainGesture(
    domain: Binding<ClosedRange<Double>>,
    chart: () -> View
)
```
`DomainGesture` view builder uses `.chartXScale(domain:)` modifier,
in combination with `UIKit` based gesture overlay to control the `Chart`'s horizontal domain.

### Preview
https://user-images.githubusercontent.com/28978251/193827937-6f1fd1a8-692a-48d7-acb9-a3aba8718aec.mp4

### Usage Example
```swift
import SwiftUI
import Charts
import DomainGesture

struct DataPoint: Hashable {
    let x: Double
    let y: Double
}

struct ChartView: View {
    @State var domain: ClosedRange<Double> = 0...100
    @State var dataPoints = (0..<100).map {
        DataPoint(
            x: Double($0),
            y: .random(in: 0...10)
        )
    }
    
    var dataPointsInDomain: Array<DataPoint> {
        dataPoints.filter { domain.contains($0.x) }
    }
    
    var body: some View {
        DomainGesture($domain) {
            Chart(dataPointsInDomain, id: \.self) {
                LineMark(
                    x: .value("X", $0.x),
                    y: .value("Y", $0.y)
                )
            }.chartXScale(domain: domain)
        }.padding()
    }
}
```
