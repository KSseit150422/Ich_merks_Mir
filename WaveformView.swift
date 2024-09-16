//
//  WaveformView.swift
//  Ich_merks_Mir
//
//  Created by Karlheinz on 15.09.24.
//

import SwiftUI

struct WaveformView: View {
    @State private var barHeights: [CGFloat] = Array(repeating: 10, count: 10)
    @Binding var isRecording: Bool

    var body: some View {
        HStack(alignment: .center, spacing: 4) {
            ForEach(0..<barHeights.count, id: \.self) { index in
                RoundedRectangle(cornerRadius: 5)
                    .fill(isRecording ? Color.blue : Color.gray.opacity(0.5))
                    .frame(width: 5, height: barHeights[index])
            }
        }
        .onAppear(perform: startAnimating)
    }

    func startAnimating() {
        guard isRecording else { return }
        
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 0.2)) {
                for i in barHeights.indices {
                    barHeights[i] = CGFloat.random(in: 10...40)
                }
            }
        }
    }
}
