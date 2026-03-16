//
//  Shared.metal
//  MetalKitUI
//
//  Created by Arkadiy KAZAZYAN on 12/03/2026.
//

#include "Shared.h"

vertex FragmentInput vertex_main(uint vertexID [[vertex_id]]) {
    float4 vertices[] = {
        float4(-1.0, -1.0, 0.0, 1.0),
        float4( 1.0, -1.0, 0.0, 1.0),
        float4(-1.0,  1.0, 0.0, 1.0),
        float4( 1.0,  1.0, 0.0, 1.0)
    };
    return { vertices[vertexID] };
}
