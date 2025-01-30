# DomainXGesture

`DomainXGesture` uses `.chartXScale(domain:)` modifier,
in combination with `UIKit` based gesture recognizer to control the `Chart`'s horizontal domain.

### Preview

https://user-images.githubusercontent.com/28978251/193827937-6f1fd1a8-692a-48d7-acb9-a3aba8718aec.mp4

### Example

```swift
import SwiftUI
import Charts
import DomainGesture

struct DataPoint: Hashable, Identifiable {
    let date: Date
    let value: Double
    var id: Date { date }
}

func future(after seconds: Int = .zero) -> Date {
    Date.distantFuture.addingTimeInterval(TimeInterval(seconds))
}

let dataPoints = (0..<1000).map { seconds in
    DataPoint(
        date: future(after: seconds),
        value: .random(in: 0...10)
    )
}

struct ChartView: View {
    @State var domain: ClosedRange<Date> = future()...future(after: 1000)
    
    var body: some View {
        Chart(dataPoints.filter { domain.contains($0.date) }) { dataPoint in
            LineMark(
                x: .value("Date", dataPoint.date),
                y: .value("Value", dataPoint.value)
            )
        }
        .chartXScale(domain: domain)
        .gesture(DomainXGesture(domain: $domain))
    }
}
```
