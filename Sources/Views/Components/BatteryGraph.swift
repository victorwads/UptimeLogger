//
//  BatteryGraph.swift
//  UptimeLogger
//
//  Created by Victor Wads on 15/05/23.
//

import SwiftUI

struct BatteryGraph: View {

    @State var picker: Date = Date()
    @State var lowerValue: Double = 0
    @State var upperValue: Double = -1
    @State var showDetails = false
    let batteryLevels: [Date: Int]

    private let offsetT = CGFloat(10)
    private let offsetB = CGFloat(35)
    private let offsetL = CGFloat(35)
    private let offsetR = CGFloat(30)
    private var minDate: Date { sortedDates.first ?? Date() }
    private var maxDate: Date { sortedDates.last ?? Date() }
    private var maxValue: Double { Double(batteryLevels.count) }
    private var sortedDates: [Date] {
        batteryLevels.keys.sorted().enumerated().filter { index, _ in
            let index = Double(index)
            return upperValue == -1 || (index >= lowerValue && index <= upperValue)
        }.map { $0.element }
    }
    
    var body: some View {
        VStack {
            VStack(spacing: 0) {
                Slider(value: $lowerValue, in: 0...maxValue)
                Slider(value: $upperValue, in: 0...maxValue)
            }.padding(.horizontal)
            GeometryReader { geometry in
                let width = geometry.size.width - offsetR - offsetL
                let height = geometry.size.height - offsetT - offsetB
                let info = GraphInfo(
                    width: width, height: height,
                    xScale: width / CGFloat(maxDate.timeIntervalSince(minDate)),
                    yScale: height / 100
                )
                
                createLines(info)
                createInfos(info)
                
                let graphs = splitChargingStates()
                if(!graphs.isEmpty){
                    let chargingColorOffSet = level(graphs[0][0]) > level(graphs[0][1]) ? 1 : 0
                    ForEach(0..<graphs.count, id: \.self) { index in
                        let dates = graphs[index]
                        let isCharging = (index+chargingColorOffSet) % 2 == 0
                        createPath(info, dates: dates, start: index == 0, end: index == graphs.count-1)
                            .fill((isCharging ? Color.green : Color.red).opacity(0.2))
                    }
                }

                VStack {
                    Spacer()
                    HStack {
                        Text(formatDate(minDate))
                        Spacer()
                        Text(formatDate(maxDate))
                    }.font(.caption).foregroundColor(.gray).padding(5)
                }
            }
        }.onAppear {
            picker = maxDate
            upperValue = maxValue
        }
    }

    private func level(_ from: Date) -> Int {
        return batteryLevels[from]!
    }
    
    private func splitChargingStates() -> [[Date]] {
        var subArrays: [[Date]] = []
        if(sortedDates.count >= 2) {
            let first = level(sortedDates[0])
            var currentSubArray: [Date] = [sortedDates[0]]
            var isCharging = first < level(sortedDates[1])
            
            for i in 1..<sortedDates.count {
                let currentLevel = level(sortedDates[i])
                let previousLevel = level(sortedDates[i - 1])
                let currentCharging = currentLevel > previousLevel

                if isCharging == currentCharging {
                    currentSubArray.append(sortedDates[i])
                } else {
                    subArrays.append(currentSubArray)
                    isCharging = currentCharging
                    currentSubArray = [sortedDates[i-1], sortedDates[i]]
                }
            }
            subArrays.append(currentSubArray)
        }
        return subArrays
    }
    
    private func createPath(_ graph: GraphInfo, dates: [Date], start: Bool = false, end: Bool = false) -> Path {
        return Path { path in
            var point = CGPoint(x: 0, y: graph.height+offsetT+offsetB)
            for (i, date) in dates.enumerated() {
                let level = CGFloat(batteryLevels[date]!)
                let x = (CGFloat(date.timeIntervalSince(minDate)) * graph.xScale) + offsetL
                let y = graph.height - (level * graph.yScale) + offsetT
                if(i == 0){
                    if(start) {
                        point = CGPoint(x: 0, y: graph.height+offsetT+offsetB)
                        path.move(to: point)
                        path.addLine(to: CGPoint(x: 0, y: y))
                    } else {
                        point = CGPoint(x: x, y: graph.height+offsetT+offsetB)
                        path.move(to: point)
                        path.addLine(to: CGPoint(x: x, y: y))
                    }
                }
                point = CGPoint(x: x, y: y)
                path.addLine(to: point)
            }
            if(end) {
                path.addLine(to: CGPoint(x: graph.width+offsetL+offsetR, y: point.y))
                path.addLine(to: CGPoint(x: graph.width+offsetL+offsetR, y: graph.height+offsetT+offsetB))
            } else {
                path.addLine(to: CGPoint(x: point.x, y: graph.height+offsetT+offsetB))
            }
        }
    }
    
    private func createLines(_ graph: GraphInfo) -> some View {
        return ForEach(0..<11) { i in
            let percentage = CGFloat(i * 10)
            let y = graph.height - (percentage * graph.yScale) + offsetT
            
            Path { path in
                path.move(to: CGPoint(x: 0, y: y))
                path.addLine(to: CGPoint(x: graph.width+offsetL+offsetR, y: y))
            }.stroke(Color.gray.opacity(0.4), lineWidth: 0.5)

            Text("\(Int(percentage))%").font(.caption)
                .foregroundColor(.gray)
                .offset(x: 8, y: y - 6)
        }
    }

    private func createInfos(_ graph: GraphInfo) -> some View {
        return ForEach(sortedDates, id: \.self) { date in
            let level = CGFloat(batteryLevels[date]!)
            let x = (CGFloat(date.timeIntervalSince(minDate)) * graph.xScale) + offsetL
            let y = graph.height - (level * graph.yScale) + offsetT
            BatteryGraphText(
                date: formatDate(date),
                level: Int(level), x: x, y: y,
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
    let size = CGFloat(7)
    
    @State var hover = false

    var body: some View {
        Circle()
            .fill(Color.accentColor.opacity(0.001))
            .frame(width: size*2, height: size*2)
            .offset(x: x-size, y: y-size)
            .onHover { isHover in hover = isHover }
            .zIndex(1)
        Circle()
            .fill(Color.accentColor)
            .frame(width: size, height: size)
            .offset(x: x-(size/2), y: y-(size/2))
        VStack {
            let split = date.components(separatedBy: " ")
            Text(split.first!).font(.caption2).foregroundColor(.gray)
            Text(split.last!).font(.caption)
        }
        .multilineTextAlignment(.center)
        .padding(.vertical, 3)
        .padding(.horizontal, 8)
        .opacity(hover ? 1 : 0.001)
        .offset(x: x - 39, y: y - 44)
        .zIndex(2)

        Text("\(level)%").font(.subheadline).foregroundColor(.green)
            .padding(.vertical, 3)
            .padding(.horizontal, 5)
            .opacity(hover ? 1 : 0.001)
            .offset(x: x - 15, y: y + 8)
            .zIndex(2)
    }
}

#if DEBUG
func getValues(_ itens: Int = 20) -> [Date: Int] {
    var batteryLevels = [Date: Int]()

    let calendar = Calendar.current
    var startDate = Date()
    let initialLevel = Int(arc4random_uniform(100))
    var currentLevel = initialLevel
    var isCharging = false
    var last = initialLevel

    for _ in 0..<itens {
        let change = Int(arc4random_uniform(5) + 1)
        let date = calendar.date(byAdding: .second, value: Int(arc4random_uniform(2000) + 1), to: startDate)!

        if arc4random_uniform(30) == 0 { isCharging.toggle() }
        if currentLevel > 99 { isCharging = false; currentLevel = 100}
        if isCharging { currentLevel += 10 } else { currentLevel -= change }
        if currentLevel < 1 { currentLevel = 0 }

        if(last != currentLevel) { batteryLevels[date] = currentLevel }
        last = currentLevel
        startDate = date
    }

    return batteryLevels
}

struct BatteryGraph_Previews: PreviewProvider {
    static var previews: some View {
        BatteryGraph(batteryLevels: getValues(300))
        BatteryGraph(showDetails: true, batteryLevels: getValues(20))
    }
}
#endif
