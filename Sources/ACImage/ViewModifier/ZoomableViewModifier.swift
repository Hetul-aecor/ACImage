//
//  ZoomableViewModifier.swift
//  
//
//  Created by Pinal Prajapati on 17/02/22.
//

import SwiftUI

struct ZoomableViewModifier: ViewModifier {
    let isZoomAllowed: Bool
    @State var scale: CGFloat = 1.0
    @State var anchor: UnitPoint = .center
    @State var offset: CGSize = .zero
    @State var isPinching: Bool = false
    
    func body(content: Content) -> some View {
        if isZoomAllowed {
            content
                .scaleEffect(scale, anchor: anchor)
                .offset(offset)
                .overlay(ZoomableView(scale: $scale, anchor: $anchor, offset: $offset, isPinching: $isPinching))
        }
        else{
            content
        }
    }
}
