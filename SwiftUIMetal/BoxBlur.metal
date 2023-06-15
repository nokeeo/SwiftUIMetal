#include <metal_stdlib>
#include "SwiftUI/SwiftUI.h"
using namespace metal;

half4 SampleLayer(float2 position, SwiftUI::Layer layer) {
  position = metal::fma(position.x, layer.info[0], metal::fma(position.y, layer.info[1], layer.info[2]));
  position = metal::clamp(position, layer.info[3], layer.info[4]);
  return layer.tex.sample(metal::sampler(metal::filter::nearest), position);
}

[[ stitchable ]] half4 BoxBlur(float2 position,
                            SwiftUI::Layer layer,
                            float4 bounds,
                            float kRadius) {
  const int kPixelNumber = (kRadius * 2 + 1) * (kRadius * 2 + 1);
  half4 sum = half4(0, 0, 0, 1);
  for (int y = position.y - kRadius; y <= position.y + kRadius; y++) {
    if (y < 0 || y >= bounds.w) continue;
    for (int x = position.x - kRadius; x <= position.x + kRadius; x++) {
      if (x < 0 || x >= bounds.z) continue;
      sum += SampleLayer(float2(x, y), layer);
    }
  }
  
  return sum / (half)kPixelNumber;
}
