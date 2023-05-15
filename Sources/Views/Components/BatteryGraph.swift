//
//  BatteryGraph.swift
//  UptimeLogger
//
//  Created by Victor Wads on 15/05/23.
//

import SwiftUI

struct BatteryGraph: View {

    @State var showDetails = false
    let batteryLevels: [Date: Int]

    private let offsetT = CGFloat(20)
    private let offsetL = CGFloat(45)
    private let offsetR = CGFloat(45)

    private var sortedDates: [Date] { batteryLevels.keys.sorted() }
    private var minDate: Date { sortedDates.first! }
    private var maxDate: Date { sortedDates.last! }
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width - offsetR - offsetL
            let height = geometry.size.height - offsetT
            let info = GraphInfo(
                width: width, height: width,
                xScale: width / CGFloat(maxDate.timeIntervalSince(minDate)),
                yScale: height / 100.0
            )
            
            createPath(info).fill(Color.accentColor.opacity(0.2))
            createPath(info).stroke(Color.accentColor.opacity(0.8), lineWidth: 2)
            createLines(info)
            createInfos(info)
        }
    }

    private func createPath(_ graph: GraphInfo) -> Path {
        return Path { path in
            var point = CGPoint(x: offsetL, y: graph.height+offsetT)
            path.move(to: point)
            for (_, date) in sortedDates.enumerated() {
                let x = (CGFloat(date.timeIntervalSince(minDate)) * graph.xScale) + offsetL
                let y = graph.height - (CGFloat(batteryLevels[date]!) * graph.yScale) + offsetT
                point = CGPoint(x: x, y: y)
                path.addLine(to: point)
            }
            path.addLine(to: CGPoint(x: graph.width+offsetL+offsetR, y: point.y))
            path.addLine(to: CGPoint(x: graph.width+offsetL+offsetR, y: graph.height+offsetT))
        }
    }
    
    private func createLines(_ graph: GraphInfo) -> some View {
        return ForEach(1..<11) { i in
            let percentage = i * 10
            let y = graph.height - (CGFloat(percentage) * graph.height / 100) + offsetT
            
            Path { path in
                path.move(to: CGPoint(x: 0, y: y))
                path.addLine(to: CGPoint(x: graph.width+offsetL+offsetR, y: y))
            }.stroke(Color.gray.opacity(0.4), lineWidth: 0.5)

            Text("\(percentage)%").font(.caption)
                .foregroundColor(.gray)
                .offset(x: 8, y: y - 6)
        }
    }

    private func createInfos(_ graph: GraphInfo) -> some View {
        return ForEach(Array(batteryLevels.keys.enumerated()), id: \.1) { (index, date) in
            let level = batteryLevels[date]!
            let x = (CGFloat(date.timeIntervalSince(minDate)) * graph.xScale)
            let y = graph.height - (CGFloat(level) * graph.yScale)
            let dateString = formatDate(date)
            BatteryGraphText(
                date: dateString,
                level: level, x: x + offsetL, y: y + offsetT,
                hover: showDetails
            )
        }
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        return formatter.string(from: date)
    }
}

fileprivate struct GraphInfo {
    var width: CGFloat
    var height: CGFloat
    let xScale: CGFloat
    let yScale: CGFloat
}

fileprivate struct BatteryGraphText: View {
    let date: String
    let level: Int
    let x: CGFloat
    let y: CGFloat

    let max = 95
    
    @State var hover = false

    var body: some View {
        Circle()
            .fill(Color.accentColor)
            .frame(width: 10, height: 10)
            .offset(x: x-5, y: y-5)
            .onHover { isHover in hover = isHover }
        VStack {
            let split = date.components(separatedBy: " ")
            Text(split.first!).font(.caption2).foregroundColor(.gray)
            Text(split.last!).font(.caption).foregroundColor(.white)
        }
        .multilineTextAlignment(.center)
        .padding(.vertical, 3)
        .padding(.horizontal, 8)
        .background(
            RoundedRectangle(cornerRadius: 6)
                .fill(Color.black.opacity(0.6))
        )
        .opacity(hover ? 1 : 0.001)
        .animation(.linear(duration: 0.2))
        .offset(x: x - 39, y: y - 44)
    }
}

#if DEBUG
func getValues() -> [Date: Int] {
    var batteryLevels = [Date: Int]()

    let calendar = Calendar.current
    var startDate = Date()
    let initialLevel = Int(arc4random_uniform(100))
    var currentLevel = initialLevel
    var isCharging = false
    var last = initialLevel

    for _ in 0..<5 {
        let change = Int(arc4random_uniform(5) + 1)
        let date = calendar.date(byAdding: .second, value: Int(arc4random_uniform(2000) + 1), to: startDate)!

        if arc4random_uniform(30) == 0 { isCharging.toggle() }
        if isCharging { currentLevel += 10 } else { currentLevel -= change }
        if currentLevel > 99 { isCharging = false; currentLevel = 100}
        if currentLevel < 1 { currentLevel = 0 }
        
        if(last != currentLevel) { batteryLevels[date] = currentLevel }
        last = currentLevel
        startDate = date
    }

    return batteryLevels
}

struct BatteryGraph_Previews: PreviewProvider {
    static var previews: some View {
        let values = getValues()
        BatteryGraph(batteryLevels: values)
        BatteryGraph(showDetails: true, batteryLevels: values)
    }
}
#endif
