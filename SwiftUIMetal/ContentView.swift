import SwiftUI

struct ContentView: View {
  
  @State private var finalBlurRadius = 5.0;
  @State private var pendingBlurRadius = 0.0;
  
  var body: some View {
    let shaderFunction = ShaderFunction(library: .default, name: "BoxBlur")
    ZStack(alignment:.bottom){
      Image(.cat)
        .resizable(resizingMode: .stretch)
        .aspectRatio(contentMode: .fill)
        .layerEffect(Shader(function: shaderFunction, arguments: [.boundingRect, .float(finalBlurRadius)]), maxSampleOffset: CGSize(width: finalBlurRadius, height: finalBlurRadius))
        .ignoresSafeArea()
      
      Slider(value: $pendingBlurRadius, in:0...16, step:3, onEditingChanged: {editing in
        if (!editing) {
          finalBlurRadius = pendingBlurRadius
        }
      })
        .padding([.leading, .trailing], 50)
    }
  }
}

#Preview {
    ContentView()
}
