//
//  File.swift
//  
//
//  Created by Hetul Soni on 11/05/22.
//

import Foundation

class ACImageViewModel: ObservableObject {
    public enum ImageStateValue {
        case loading
        case nameIntials(nameInitials: String)
        case localImage(path: String?)
        case animated(url: URL)
        case webImage(url: URL)
        case failure
    }
    
    var imageURL: String?
    var nameInitials: String?
    
    @Published private(set) var currentImageState : ImageStateValue! = .loading {
        didSet {
            forcedUpdate.toggle()
        }
    }
    @Published private(set) var forcedUpdate: Bool = false {
        didSet {
            objectWillChange.send()
        }
    }
    
    init(imageURL: String? = nil, nameInitials: String?) {
        self.imageURL = imageURL
        self.nameInitials = nameInitials
    }
    
}

//MARK:- Other methods
extension ACImageViewModel {
    func setupState(isLocalImage: Bool = false) {
        if isLocalImage {
            currentImageState = .localImage(path: nil)
        }
        else if let imgString = imageURL, let imgURL = URL(string: imgString) {
            if FileManager.default.fileExists(atPath: imgURL.path) {
                if imgURL.pathExtension.lowercased().contains("gif") {
                    currentImageState = .animated(url: URL(fileURLWithPath: imgURL.path))
                }
                else {
                    currentImageState = .localImage(path: imgURL.path)
                }
            }
            else {
                currentImageState = .webImage(url: imgURL)
            }
        }
        else if let nameInitials = nameInitials {
            currentImageState = .nameIntials(nameInitials: nameInitials)
        }
        else {
            setFailure()
        }
    }
    
    func setFailure() {
        currentImageState = .failure
    }
    
}
