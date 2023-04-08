//
//  VoiceWaveView.swift
//  Voice Note
//
//  Created by iosdev on 5.4.2023.
//

import SwiftUI

struct WaveView: View {
    let topWaveColor = #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1)
    let bottomWaveColor = #colorLiteral(red: 0.3236978054, green: 0.1063579395, blue: 0.574860394, alpha: 0.7069759748)
    
    var value: CGFloat
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(LinearGradient(colors: [Color(topWaveColor), Color(bottomWaveColor)], startPoint: .top, endPoint: .leading))
            .frame(width: (UIScreen.main.bounds.width - CGFloat(samples) * 15) / CGFloat(samples), height: value)
    }
}

struct WaveView_Previews: PreviewProvider {
    static var previews: some View {
        WaveView(value:50)
    }
}
