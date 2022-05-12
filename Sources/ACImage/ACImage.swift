//
//  RemoteImage.swift
//
//
//  Created by Pinal Prajapati on 08/02/22.
//

import SwiftUI
import SDWebImage
import SDWebImageSwiftUI

public struct ACImage: View {
    
    let imageObj : UIImage?
    let contentMode : ContentMode
    let isZoomAllowed: Bool    
    
    let loadingImage : Image
    let failureImage : Image
    
    let size: CGSize
    
    @StateObject var viewModel: ACImageViewModel
    
    public init(_ url: String? = nil, imageObj : UIImage? = nil, contentMode : ContentMode = .fill, isZoomAllowed: Bool = false, nameInitials: String? = nil, loadingImage : Image, failureImage: Image, size: CGSize) {
        
        self.imageObj = imageObj
        
        self.contentMode = contentMode
        self.isZoomAllowed = isZoomAllowed
        
        self.loadingImage = loadingImage
        self.failureImage = failureImage
        
        self.size = size
        
        _viewModel = StateObject(wrappedValue: ACImageViewModel(imageURL: url, nameInitials: nameInitials))
        
    }
    
    public var body: some View {
        if #available(iOS 15.0, *) {
            makeBody()
        }
        else {
            if viewModel.forcedUpdate {
                makeBody()
            }
            else {
                makeBody()
            }
        }
    }
    
    @ViewBuilder func makeBody() -> some View {
        switch viewModel.currentImageState {
            
        case .nameIntials(let nameInitials):
            makeInitialsView(nameInitials)
            
        case .animated(let data):
            makeLocalAnimatedImageView(data)
                .manageZoom(isZoomAllowed: isZoomAllowed)
            
        case .localImage(let path):
            if let imagePath = path {
                if let img = UIImage(contentsOfFile: imagePath) {
                    makeLocalImageView(img)
                        .manageZoom(isZoomAllowed: isZoomAllowed)
                }
                else {
                    makeFailureImage()
                }
            }
            else {
                if let img = imageObj {
                    makeLocalImageView(img)
                        .manageZoom(isZoomAllowed: isZoomAllowed)
                }
            }
            
        case .webImage(let url):
            makeRemoteImageView(url)
                .manageZoom(isZoomAllowed: isZoomAllowed)
            
        case .failure:
            makeFailureImage()
            
        default:
            makeLoadingView()
                .onAppear {
                    DispatchQueue.main.async {
                        self.viewModel.setupState(isLocalImage: (self.imageObj != nil))
                    }
                }
        }
    }
}

extension ACImage {
    
    /// make Remote Image UI
    @ViewBuilder private func makeRemoteImageView(_ imageURL: URL)->some View {
        WebImage(url: imageURL)
            .onFailure(perform: { _ in
                DispatchQueue.main.async {
                    self.viewModel.setFailure()
                }
            })
            .resizable() // Resizable like SwiftUI.Image, you must use this modifier or the view will use the image bitmap size
            .placeholder {
                makeLoadingView()
            }
            .indicator(.activity) // Activity Indicator
            .aspectRatio(contentMode: contentMode)
            .frame(width: size.width, height: size.height, alignment: .center)
            .clipped()
    }
    
    /// make Animated Image UI
    @ViewBuilder private func makeLocalAnimatedImageView(_ url: URL)->some View {
        GIFView(url: url)
            .frame(width: size.width, height: size.height, alignment: .center)
            .scaledToFill()
            .clipped()
    }
    
    /// make Loading UI
    @ViewBuilder private func makeLocalImageView(_ image: UIImage)->some View {
        Image(uiImage: image)
            .resizable()
            .aspectRatio(contentMode: contentMode)
            .frame(width: size.width, height: size.height, alignment: .center)
            .clipped()
    }
    
    /// make Loading UI
    @ViewBuilder private func makeLoadingView()->some View {
        VStack{
            loadingImage
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: size.width * 0.5, height: size.height * 0.5, alignment: .center)
        }
        .frame(width: size.width, height: size.height, alignment: .center)
        .clipped()
    }
    
    /// make Failure UI
    @ViewBuilder private func makeFailureImage()->some View {
        VStack{
            failureImage
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: size.width * 0.5, height: size.height * 0.5, alignment: .center)
        }
        .frame(width: size.width, height: size.height, alignment: .center)
        .clipped()
    }
    
    /// Make initials UI
    @ViewBuilder private func makeInitialsView(_ value: String)->some View {
        VStack(alignment: .center){
            Text(value)
                .padding(4)
                .minimumScaleFactor(0.001)
                .lineLimit(1)
        }
        .frame(width: size.width, height: size.height, alignment: .center)
    }
}
