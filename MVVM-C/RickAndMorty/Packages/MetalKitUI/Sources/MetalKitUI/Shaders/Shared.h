//
//  Shared.h
//  MetalKitUI
//
//  Created by Arkadiy KAZAZYAN on 12/03/2026.
//
#pragma once
#include <metal_stdlib>

struct Uniforms {
    float time;
    float2 resolution;
    float2 mouse;
};

struct FragmentInput {
    float4 position [[position]];
};
