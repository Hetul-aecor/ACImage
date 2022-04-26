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
    
    public enum ImageStateValue {
        case loading,nameIntials(nameInitials: String), localImage(img: UIImage), animated(url: URL), webImage(url: URL), failure
    }
    
    @State private var currentImageState : ImageStateValue! = .loading
    let imageURL: String?
    let imageObj : UIImage?
    let contentMode : ContentMode
    let isZoomAllowed: Bool
    let nameInitials: String?
    
    let loadingImage : Image
    let failureImage : Image
    
    let size: CGSize
    
    public init(_ url: String? = nil, imageObj : UIImage? = nil, contentMode : ContentMode = .fill, isZoomAllowed: Bool = false, nameInitials: String? = nil, loadingImage : Image, failureImage: Image, size: CGSize) {
        
        self.imageURL = url
        self.imageObj = imageObj
        
        self.contentMode = contentMode
        self.isZoomAllowed = isZoomAllowed
        self.nameInitials = nameInitials
        
        self.loadingImage = loadingImage
        self.failureImage = failureImage
        
        self.size = size
        
    }
    
    public var body: some View {
        switch currentImageState {
            
        case .nameIntials(let nameInitials):
            makeInitialsView(nameInitials)
            
        case .animated(let data):
            makeLocalAnimatedImageView(data)
                .manageZoom(isZoomAllowed: isZoomAllowed)
            
        case .localImage(let img):
            makeLocalImageView(img)
                .manageZoom(isZoomAllowed: isZoomAllowed)
            
        case .webImage(let url):
            makeRemoteImageView(url)
                .manageZoom(isZoomAllowed: isZoomAllowed)
            
        case .failure:
            makeFailureImage()
            
        default:
            makeLoadingView()
                .onAppear {
                    DispatchQueue.main.async {
                        self.setupState()
                    }
                }
        }
    }
    
}

extension ACImage {
    fileprivate func setupState(){
        
        if let img = imageObj {
            self.currentImageState = .localImage(img: img)
        }
        else if let imgString = imageURL,let imgURL = URL(string: imgString) {
            if FileManager.default.fileExists(atPath: imgURL.path){
                if imgURL.pathExtension.lowercased().contains("gif") {
                    self.currentImageState = .animated(url: URL(fileURLWithPath: imgURL.path))
                }
                else if let img = UIImage.init(contentsOfFile: imgURL.path){
                    self.currentImageState = .localImage(img: img)
                }
                else{
                    self.currentImageState = .failure
                }
            }
            else{
                self.currentImageState = .webImage(url: imgURL)
            }
        }
        else if let nameInitials = nameInitials {
            self.currentImageState = .nameIntials(nameInitials: nameInitials)
        }
        else{
            self.currentImageState = .failure
        }
    }
}

extension ACImage {
    
    /// make Remote Image UI
    @ViewBuilder private func makeRemoteImageView(_ imageURL: URL)->some View {
        WebImage(url: imageURL)
            .onFailure(perform: { _ in
                DispatchQueue.main.async {
                    self.currentImageState = .failure
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
