//
//  ProgressCircleView.swift
//  FitnessApp
//
//  Created by Maxim Dmitrochenko on 1/20/25.
//

//
//  ProgressCircleView.swift
//  FitnessApp
//
//  Created by Maxim Dmitrochenko on 4/22/25.
//

import SwiftUI

struct ProgressCircleView: View {
    @Binding var progress: Int
    var goal: Int
    var colorMain: Color
    var colorTail: Color
    var imageName: String?
    
    private let lineWidth: CGFloat = 20
    private let imageSize: CGFloat = 12
    
    private var gradient: LinearGradient {
        LinearGradient(colors: [colorMain, colorTail], startPoint: .leading, endPoint: .trailing)
    }
    
    var body: some View {
        GeometryReader { geometry in
            let radius = (min(geometry.size.width, geometry.size.height) - lineWidth) / 2
            
            ZStack {
                Circle()
                    .stroke(colorMain.opacity(0.3), style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                
                Circle()
                    .trim(from: 0, to: min(CGFloat(progress) / CGFloat(goal), 1))
                    .rotation(Angle(degrees: -90))
                    .stroke(gradient, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                    .shadow(radius: 5)
                
                if progress > goal {
                    Circle()
                        .trim(from: 0, to: CGFloat(progress - goal) / CGFloat(goal))
                        .rotation(Angle(degrees: -90))
                        .stroke(gradient, style: StrokeStyle(lineWidth: lineWidth / 2, lineCap: .round))
                        .shadow(radius: 5)
                }
                
                if let imageName = imageName {
                    Image(systemName: imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: imageSize, height: imageSize)
                        .bold()
                        .foregroundColor(.black)
                        .offset(y: -radius - 10)
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

#Preview {
    ProgressCircleView(progress: .constant(370), goal: 360, colorMain: .red, colorTail: .orange, imageName: "flame.fill")
}
