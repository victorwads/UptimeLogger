//
//  BatteryGraph.swift
//  UptimeLogger
//
//  Created by Victor Wads on 15/05/23.
//

import SwiftUI

struct BatteryGraph: View {
    let batteryLevels: [Date: Int] // Dicionário com data/hora e porcentagem da bateria
    let offsetT = CGFloat(20)
    let offsetL = CGFloat(45)
    let offsetR = CGFloat(45)

    fileprivate func createPath(_ graphWidth: CGFloat, _ graphHeight: CGFloat) -> Path {
        let sortedDates = batteryLevels.keys.sorted()
        let minDate = sortedDates.first!
        let maxDate = sortedDates.last!

        return Path { path in
            let xScale = graphWidth / CGFloat(maxDate.timeIntervalSince(minDate))
            let yScale = graphHeight / 100.0
            
            var point = CGPoint(x: offsetL, y: graphHeight+offsetT)
            path.move(to: point)
            for (_, date) in sortedDates.enumerated() {
                let x = (CGFloat(date.timeIntervalSince(minDate)) * xScale) + offsetL
                let y = graphHeight - (CGFloat(batteryLevels[date]!) * yScale) + offsetT
                point = CGPoint(x: x, y: y)
                
                path.addLine(to: point)
                path.addArc(
                    center: point, radius: 2,
                    startAngle: .degrees(0), endAngle: .degrees(360),clockwise: true
                )
            }
            path.addLine(to: CGPoint(x: graphWidth+offsetL+offsetR, y: point.y))
            path.addLine(to: CGPoint(x: graphWidth+offsetL+offsetR, y: graphHeight+offsetT))
        }
    }
    
    var body: some View {

        GeometryReader { geometry in
            let graphHeight = geometry.size.height-offsetT
            let graphWidth = geometry.size.width-offsetR-offsetL
            let sortedDates = batteryLevels.keys.sorted()
            let minDate = sortedDates.first!
            let maxDate = sortedDates.last!
            let yScale = graphHeight / 100.0

            createPath(graphWidth, graphHeight)
                .fill(Color.green.opacity(0.2))
            
            createPath(graphWidth, graphHeight)
                .stroke(Color.green.opacity(0.8), lineWidth: 2)
            
            ForEach(1..<11) { i in
                let percentage = i * 10
                let y = graphHeight - (CGFloat(percentage) * graphHeight / 100) + offsetT
                
                Path { path in
                    path.move(to: CGPoint(x: 0, y: y))
                    path.addLine(to: CGPoint(x: graphWidth+offsetL+offsetR, y: y))
                }
                .stroke(Color.gray.opacity(0.4), lineWidth: 0.5)
                
                Text("\(percentage)%")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .offset(x: 8, y: y - 6)
            }
            
            ForEach(Array(batteryLevels.keys.enumerated()), id: \.1) { (index, date) in
                let level = batteryLevels[date]!
                let x = (CGFloat(date.timeIntervalSince(minDate)) * graphWidth / CGFloat(maxDate.timeIntervalSince(minDate)))
                let y = graphHeight - (CGFloat(level) * yScale)
                let dateString = formatDate(date)
                BatteryGraphText(
                    date: dateString,
                    level: level, x: x + offsetL, y: y + offsetT
                )
            }
        }
    }
    
    fileprivate func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .medium
        return formatter.string(from: date)
    }
}

struct BatteryGraphText: View {
    
    let date: String
    let level: Int
    let x: CGFloat
    let y: CGFloat

    let max = 95
    
    @State var hover = false

    var body: some View {
        Circle()
            .fill(.green)
            .frame(width: 8, height: 8)
            .offset(
                x: x-4,
                y: y-4
            ).onHover { isHover in
                hover=isHover
            }
        Text(date)
            .font(.caption)
            .foregroundColor(.white)
            .padding(.vertical, 5)
            .padding(.horizontal, 10)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.black.opacity(0.6))
            )
            .opacity(hover ? 1 : 0.001)
            .animation(.default)
            .offset(
                x: x - 32,
                y: y - 30
            )

    }
}

                 
func getValues() -> [Date: Int] {
    var batteryLevels = [Date: Int]()

    let calendar = Calendar.current
    var startDate = Date().addingTimeInterval(-3600 * 24 * 7)
    let initialLevel = 35 // nível inicial de bateria
    var currentLevel = initialLevel
    var isCharging = false

    for _ in 0..<10 {
        let randomInterval = TimeInterval(arc4random_uniform(2000) + 1)
        
        let randomProbability = arc4random_uniform(20)
        if randomProbability == 0 {
            isCharging.toggle()
        }

        if isCharging {
            currentLevel += Int(arc4random_uniform(5) + 1)
        } else {
            currentLevel -= Int(arc4random_uniform(6) + 1)
        }

        if currentLevel > 99 {
            isCharging = false
            currentLevel = 100
        }
        if currentLevel < 1 {
            currentLevel = 0
        }
        let date = calendar.date(byAdding: .second, value: Int(randomInterval), to: startDate)!
        batteryLevels[date] = currentLevel
        
        startDate=date
    }

    return batteryLevels
}

struct BatteryGraph_Previews: PreviewProvider {
    
    static var previews: some View {

        BatteryGraph(batteryLevels: getValues())
        
    }
}
