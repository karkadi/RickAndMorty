//
//  Uniforms.h
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 09/04/2025.
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
