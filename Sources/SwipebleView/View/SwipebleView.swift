import SwiftUI



public struct SwipebleView<T,Content: View>: View  where T: SwipebleViewModel{
    
    var proxy: GeometryProxy
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var viewModel: T
    @State var frame: CGSize = .zero
    
    let content: Content
    
    public init(@ViewBuilder content: () -> Content, viewModel: T, geometryProxy: GeometryProxy) {
        self.content = content()
        self.viewModel = viewModel
        self.proxy = geometryProxy
        
        
    }
    
    private func makeView(_ geometry: GeometryProxy) -> some View {
            print(geometry.size.width, geometry.size.height)

            DispatchQueue.main.async { self.frame = geometry.size }

            return content
                .frame(width: geometry.size.width, height: geometry.size.height)
        }
    
    public var body: some View {
        
        ZStack {
            
            
            HStack {
                Spacer().frame(width: proxy.size.width * (1 - CGFloat(min(4, viewModel.actions.actions.count)) * 0.231), height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                EditActions(viewModel: viewModel.actions, height: frame.height)
                
            }
            GeometryReader { (geometry) in
                self.makeView(geometry)
                    .frame(maxHeight: frame.height)
            }
            
            .offset(x: viewModel.dragOffset.width)
        }
        .frame(height: frame.height, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        .onTapGesture(count: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/, perform: {
            withAnimation {
                viewModel.dragOffset = CGSize.zero
            }
        })
        
        .gesture(
            DragGesture(minimumDistance: 3.0, coordinateSpace: .local)
                .onEnded { value in
                    
                    withAnimation {
                        print(viewModel.dragOffset)
                        if value.translation.width < 0 && value.translation.height > -30 && value.translation.height < 30 {
                            viewModel.dragOffset = CGSize.init(width: -1*(proxy.size.width * (CGFloat(min(4, viewModel.actions.actions.count)) * 0.2)), height: 0)
                        }
                        else if value.translation.width > 0 && value.translation.height > -30 && value.translation.height < 30 {
                            viewModel.dragOffset = CGSize.zero
                        }
                    }
                }
        )
    }
}
class example: SwipebleViewModel {
    @Published var dragOffset: CGSize = CGSize.zero
    @Published var actions: EditActionsVM = EditActionsVM([])
}
@available(iOS 14.0, *)
struct SwipebleView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
                GeometryReader { reader in
                    SwipebleView(content: {
                        Text("text")
                    }, viewModel: example(), geometryProxy: reader)
                }
        }

    }
}
