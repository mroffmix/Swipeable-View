import SwiftUI



public struct SwipebleView<T,Content: View>: View  where T: SwipebleViewModel{
    
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var viewModel: T
    @State var frame: CGSize = .zero
    @State private var actions: EditActions?
    
    
    
    let content: Content
    
    public init(@ViewBuilder content: () -> Content, viewModel: T, geometryProxy: GeometryProxy) {
        self.content = content()
        
        self.viewModel = viewModel
        
    }
    
    private func makeView(_ geometry: GeometryProxy) -> some View {
        print(geometry.size.width, geometry.size.height)
        
        DispatchQueue.main.async { self.frame = geometry.size }
        
        return content
            .frame(width: geometry.size.width)
    }
    
    public var body: some View {
        
        return GeometryReader { (geometry) in
            ZStack {
                HStack {
                    Spacer().frame(width: geometry.size.width * (1 - CGFloat(min(4, viewModel.actions.actions.count)) * 0.231), height: 1, alignment: .center)
                    EditActions(viewModel: viewModel.actions, height: geometry.size.height)
                }
                
                self.makeView(geometry)
                    .frame(maxHeight: .infinity)
            }
            
            .offset(x: viewModel.dragOffset.width)
            
            .frame(height: frame.height, alignment: .center)
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
                            print("\(actions?.frameSize.width)")
                            if value.translation.width < 0 && value.translation.height > -30 && value.translation.height < 30 {
                                viewModel.dragOffset = CGSize.init(
                                    width: -1*(geometry.size.width * (CGFloat(min(4, viewModel.actions.actions.count)) * 0.2) + CGFloat(viewModel.actions.actions.count * 20)),
                                    height: 0)
                                
                                // viewModel.dragOffset = CGSize.init(width: -1 * (actions?.frameSize.width ?? 0), height: 0)
                            }
                            else if value.translation.width > 0 && value.translation.height > -30 && value.translation.height < 30 {
                                viewModel.dragOffset = CGSize.zero
                            }
                        }
                    }
            )
        }
    }
}

class example: SwipebleViewModel {
    @Published var dragOffset: CGSize = CGSize.zero
    @Published var actions: EditActionsVM = EditActionsVM([], maxActions: 4)
}
@available(iOS 14.0, *)
struct SwipebleView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { reader in
            VStack {
                Spacer()
                SwipebleView(content: {
                    HStack {
                        Spacer()
                        Text("View content")
                        Spacer()
                    }.padding()
                    .background(Color.blue)
                    
                }, viewModel: example(), geometryProxy: reader)
                
                Spacer()
            }
        }
        
    }
}
