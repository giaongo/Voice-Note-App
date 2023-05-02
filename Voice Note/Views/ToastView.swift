import SwiftUI

/**
    A type that holds styling option
 */
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

/**
    A View that represent notification
 */
struct ToastView: View, Equatable {
    static func == (lhs: ToastView, rhs: ToastView) -> Bool {
        return lhs.title == rhs.title && lhs.message == rhs.message
    }
    
    var type: ToastStyle
    var title: String
    var message: String
    var cancelPressed: (() -> Void)
    var duration:Double = 3
    
    var body: some View {
        VStack() {
            HStack() {
                Image(systemName: type.iconToastDisplay)
                    .foregroundColor(type.toastColor)
                
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.system(size: 18, weight: .semibold))
                    
                    Text(message)
                        .font(.system(size: 17))
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

struct ToastViewModifier: ViewModifier {
    @Binding var toast: ToastView?
    @State private var workItem: DispatchWorkItem?
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay {
                VStack {
                    mainToastView()
                        .offset(y: 60)
                    Spacer()
                }.animation(.spring(),value:toast)
                    .transition(.move(edge: .top))
            }
        
            .onChange(of: toast) { value in
                showToast()
            }
    }
    
    @ViewBuilder func mainToastView() -> some View {
        if let toast = toast {
            VStack {
                ToastView(type: toast.type, title: toast.title, message: toast.message) {
                    dismissToast()
                }
                Spacer()
            }
        }
    }
    
    private func showToast() {
        guard let toast = toast else {return}
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        if toast.duration > 0 {
            workItem?.cancel()
            
            let task = DispatchWorkItem {
                dismissToast()
            }
            workItem = task
            DispatchQueue.main.asyncAfter(deadline: .now() + toast.duration, execute: task)
        }
    }
    
    private func dismissToast() {
        withAnimation {
            toast = nil
        }
        workItem?.cancel()
        workItem = nil
    }
}

extension View {
    func toastView(toast:Binding<ToastView?>) -> some View {
        self.modifier(ToastViewModifier(toast: toast))
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
