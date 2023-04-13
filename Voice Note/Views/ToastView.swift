//
//  ToastView.swift
//  Voice Note
//
//  Created by iosdev on 13.4.2023.
//

import SwiftUI

enum ToastStyle {
    case error
    case warning
    case success
    case info
    
    var toastColor: Color {
        switch self {
            case .error: return Color.red
            case .warning: return Color.yellow
            case .info: return Color.blue
            case .success: return Color.green
        }
    }
    
    var iconToastDisplay: String {
        switch self {
            case .info: return "info.circle.fill"
            case .warning: return "exclamationmark.triangle.fill"
            case .success: return "checkmark.circle.fill"
            case .error: return "xmark.circle.fill"
        }
    }
}


struct ToastView: View {
    var type: ToastStyle
    var title: String
    var message: String
    var cancelPressed: (() -> Void)
    var body: some View {
        VStack() {
            HStack() {
                Image(systemName: type.iconToastDisplay)
                    .foregroundColor(type.toastColor)
                
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.system(size: 14, weight: .semibold))
                    
                    Text(message)
                        .font(.system(size: 12))
                        .foregroundColor(Color.black.opacity(0.6))
                }
                
                Spacer(minLength: 10)
                
                Button {
                    cancelPressed()
                } label: {
                    Image(systemName: "xmark")
                        .foregroundColor(Color.black)
                }
            }
            .padding()
        }
        .background(Color.white)
        .overlay(
            Rectangle()
                .fill(type.toastColor)
                .frame(width: 6)
                .clipped()
            , alignment: .leading
        )
        .frame(minWidth: 0, maxWidth: .infinity)
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.25), radius: 4, x: 0, y: 1)
        .padding(.horizontal, 16)
    }
}

struct ToastView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ToastView(type: .success, title: "test", message: "test is successful") {}
            ToastView(type: .info, title: "test", message: "test is successful") {}
        }
    }
}
