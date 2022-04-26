//
//  View+Extension.swift
//  
//
//  Created by Pinal Prajapati on 17/02/22.
//

import SwiftUI

extension View {
    public func manageZoom(isZoomAllowed: Bool) -> some View {
        self.modifier(ZoomableViewModifier(isZoomAllowed: isZoomAllowed))
    }
}
