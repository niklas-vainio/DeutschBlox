//
//  HistoryLineGraph.swift
//  GermanLearning
//
//  Created by Niklas on 01/08/2021.
//  This view is for the line graphs to be shown on the usage history page
//  Takes in a general list of y-axis values


import SwiftUI

struct HistoryLineGraph: View {
    // Take in a list of y-values
    var yValues: [Int]
    
    // Take in a line colour
    var lineColor: Color
    
    // Take in a starting date to show labels relative to
    var startDate: Date
    
    // Store the location of the current tap (or nil if not tapping)
    @State var tapLocation: CGPoint?
    
    var body: some View {
        // Set up tap and drag gestures which store the current position to tapLocation
        let tap = TapGesture().onEnded { tapLocation = nil }
        let drag = DragGesture(minimumDistance: 0, coordinateSpace: .local)
            .onChanged { value in
                tapLocation = value.location
            }.sequenced(before: tap)
        
        // View contents
        GeometryReader {geometry in
            // Compute constants for width etc
            let width = geometry.size.width
            let height = geometry.size.height
            
            let maxY: Int = yValues.max()!
            let minY : Int = 0
            
            let xIncrement: CGFloat = width / CGFloat(yValues.count - 1)
            
            ZStack(alignment: Alignment(horizontal: .leading, vertical: .top)) {
                // Path for the lines
                Path { path in
                    path.move(to: CGPoint(
                        x: 0,
                        y: scaleToGraph(yValue: yValues[0], maxY: maxY, minY: minY, height: height)
                    ))
                    
                    for i in 1..<yValues.count {
                        path.addLine(to: CGPoint(
                            x: CGFloat(i) * xIncrement,
                            y: scaleToGraph(yValue: yValues[i], maxY: maxY, minY: minY, height: height)
                        ))
                    }
                }
                .stroke(lineColor, style: StrokeStyle(lineWidth: 3.0, lineCap: .round, lineJoin: .round))
            
                // Second path for the fill
                Path { path in
                    path.move(to: CGPoint(
                        x: 0,
                        y: scaleToGraph(yValue: yValues[0], maxY: maxY, minY: minY, height: height)
                    ))
                    
                    for i in 1..<yValues.count {
                        path.addLine(to: CGPoint(
                            x: CGFloat(i) * xIncrement,
                            y: scaleToGraph(yValue: yValues[i], maxY: maxY, minY: minY, height: height)
                        ))
                    }
                    
                    // To bottom right
                    path.addLine(to: CGPoint(
                        x: width,
                        y: height
                    ))
                    
                    // To bottom left
                    path.addLine(to: CGPoint(
                        x: 0,
                        y: height
                    ))
                }
                .fill(LinearGradient(
                        gradient: Gradient(colors: [
                            lineColor.opacity(0.5),
                            lineColor.opacity(0.1)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                ))
            
                // If tap location is not nil, draw line to show selected data point
                if let location = tapLocation {
                    // Snap position to nearest entry and constrain
                    let selectedIndexRaw = Int(location.x / xIncrement)
                    let selectedIndex = min(max(selectedIndexRaw, 0), yValues.count - 1)
                    let xPos = CGFloat(selectedIndex) * xIncrement
                    
                    // Vertical line up to point
                    Path {path in
                        path.move(to: CGPoint(x: xPos, y: 0))
                        path.addLine(to: CGPoint(x: xPos, y: height))
                    }
                    .stroke(Color.gray, style: StrokeStyle(lineWidth: 2.0, lineCap: .round))
                    
                    // Label showing selected date
                    Text(getDateLabel(index: selectedIndex))
                        .foregroundColor(lineColor)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .position(x: width / 2, y: -35)
                    
                    // Label showing number for the selected date
                    Text("\(yValues[selectedIndex])")
                        .foregroundColor(lineColor)
                        .fontWeight(.bold)
                        .position(x: xPos, y: -15)
                
                    // Circle at point on graph
                    Circle()
                        .fill(lineColor)
                        .frame(width: 10, height: 10)
                        .position(x: xPos, y: scaleToGraph(yValue: yValues[selectedIndex], maxY: maxY, minY: minY, height: height))
                }
                
            }
            .gesture(drag)
        }
        
        
    }
    
    func scaleToGraph(yValue: Int, maxY: Int, minY: Int, height: CGFloat) -> CGFloat {
        // Scales a raw y value (as an integer) into a height on the graph (as a souble)
        
        let yAdjusted = yValue - minY
        let heightLevel = CGFloat(yAdjusted) / CGFloat(maxY - minY)
        
        return height * (1 - heightLevel)
    }
    
    func getDateLabel(index: Int) -> String {
        // Returns the string for a date which is a given number of days after the start date
        let selectedDate = Calendar.current.date(byAdding: .day, value: index, to: startDate)!
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        
        return dateFormatter.string(from: selectedDate)
    }
    
}

struct HistoryLineGraph_Previews: PreviewProvider {
    static var previews: some View {
        HistoryLineGraph(
            yValues: [1,2,3,4,5,2,3,4,3,4,2,3,2,9,2,3],
            lineColor: .pink,
            startDate: Date()
        )
    }
}
