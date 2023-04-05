//
//  VoiceWaveView.swift
//  Voice Note
//
//  Created by iosdev on 5.4.2023.
//

import SwiftUI

struct WaveView: View {
    let topWaveColor = #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1)
    let bottomWaveColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 0.4897902533)
    
    var value: CGFloat
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(LinearGradient(colors: [Color(topWaveColor), Color(bottomWaveColor)], startPoint: .top, endPoint: .leading))
            .frame(width: (UIScreen.main.bounds.width - CGFloat(samples) * 20) / CGFloat(samples), height: value)
    }
}

struct WaveView_Previews: PreviewProvider {
    static var previews: some View {
        WaveView(value:50)
    }
}
