//
//  IntroView.swift
//  IntroApp
//
//  Created by Maxim Dmitrochenko on 4/23/25.
//

import SwiftUI

struct IntroView: View {
    /// View Properties
    @State private var activePage: Page = .page1
    @Binding var showIntro: Bool
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            
            VStack {
                Spacer(minLength: 0)
                
                MorphingSymbolView(symbol: activePage.rawValue, config: .init(font: .system(size: 150, weight: .bold), frame: .init(width: 250, height: 200), radius: 30, foregroundColor: .white))
                    .onTapGesture {
                        activePage = activePage.nextPage
                    }
                
                TextContents(size: size)
                
                Spacer(minLength: 0)
                
                IndicatorView()
                
                ContinueButton()
            }
            .frame(maxWidth: .infinity)
            .overlay(alignment: .top) {
                HeaderView()
            }
        }
        .background {
            Rectangle()
                .fill(Color.fitnessGreenMain.gradient)
                .ignoresSafeArea()
        }
    }
    
    ///Text Contents
    @ViewBuilder
    func TextContents(size: CGSize) -> some View {
        VStack(spacing: 8) {
            HStack(alignment: .top, spacing: 0) {
                ForEach(Page.allCases, id: \.rawValue) { page in
                    Text(page.title)
                        .lineLimit(1)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .kerning(1.1)
                        .frame(width: size.width)
                        .foregroundStyle(.white)
                }
            }
            /// Sliding Left/Right based on Active Page
            .offset(x: -activePage.index * size.width)
            .animation(.smooth(duration: 0.7, extraBounce: 0.1), value: activePage)
            
            HStack(alignment: .top, spacing: 0) {
                ForEach(Page.allCases, id: \.rawValue) { page in
                    Text(page.subTitle)
                        .font(.callout)
                        .multilineTextAlignment(.center)
                        .fontWeight(.semibold)
                        .frame(width: size.width)
                        .foregroundStyle(.white.opacity(0.8))
                }
            }
            /// Sliding Left/Right based on Active Page
            .offset(x: -activePage.index * size.width)
            .animation(.smooth(duration: 1.5, extraBounce: 0.1), value: activePage)
        }
        .padding(.top, 15)
        .frame(width: size.width, alignment: .leading)
    }
    
    ///Indicator View
    @ViewBuilder
    func IndicatorView() -> some View {
        HStack(spacing: 6) {
            ForEach(Page.allCases, id: \.rawValue) { page in
                Capsule()
                    .fill(.white.opacity(activePage == page ? 1 : 0.4))
                    .frame(width: activePage == page ? 25 : 8, height: 8)
            }
        }
        .animation(.smooth(duration: 0.5, extraBounce: 0), value: activePage)
        .padding(.bottom, 12)
    }
    
    ///Header View
    @ViewBuilder
    func HeaderView() -> some View {
        HStack {
            Button {
                activePage = activePage.previousPage
            } label: {
                Image(systemName: "chevron.left")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .contentShape(.rect)
            }
            .opacity(activePage != .page1 ? 1 : 0)
            
            Spacer(minLength: 0)
            
            Button("Skip") {
                activePage = .page5
            }
            .fontWeight(.semibold)
            .opacity(activePage != .page5 ? 1 : 0)
        }
        .animation(.snappy(duration: 0.35, extraBounce: 0), value: activePage)
        .padding(15)
        .foregroundStyle(.white)
    }
    
    ///Continue Button
    @ViewBuilder
    func ContinueButton() -> some View {
        Button {
            if activePage != .page5 {
                activePage = activePage.nextPage
            } else {
                showIntro.toggle()
            }
        } label: {
            Text(activePage != .page5 ? "Продолжить" : "Перейти к приложению")
                .contentTransition(.identity)
                .foregroundStyle(Color.fitnessGreenMain)
                .padding(.vertical, 15)
                .frame(maxWidth: activePage == .page1 ? 220 : 180)
                .background(.white, in: .capsule)
        }
        .padding(.bottom, 15)
        .animation(.smooth(duration: 0.5, extraBounce: 0), value: activePage)
    }
}

#Preview {
    IntroView(showIntro: .constant(true))
}
