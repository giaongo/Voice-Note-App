//
//  AudioConfirmationView.swift
//  Voice Note
//
//  Created by iosdev on 5.4.2023.
//

import SwiftUI

struct AudioConfirmationView: View {
    @EnvironmentObject var speechRecognizer: SpeechRecognizer
    var body: some View {
        VStack{
            Text("\(speechRecognizer.transcriptionText)").font(.headline).fontWeight(.bold).padding(.horizontal,10)
        }
    }
}

struct AudioConfirmationView_Previews: PreviewProvider {
    static var previews: some View {
        AudioConfirmationView().environmentObject(SpeechRecognizer())
    }
}
