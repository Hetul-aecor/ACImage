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
    
    @Published private(set) var currentImageState : ImageStateValue! = .loading
    
    init(imageURL: String? = nil, nameInitials: String?) {
        self.imageURL = imageURL
        self.nameInitials = nameInitials
    }
    
}

//MARK:- Other methods
extension ACImageViewModel {
    func setupState(isLocalImage: Bool = false) {
        if isLocalImage {
            self.currentImageState = .localImage(path: nil)
        }
        else if let imgString = imageURL, let imgURL = URL(string: imgString) {
            if FileManager.default.fileExists(atPath: imgURL.path) {
                if imgURL.pathExtension.lowercased().contains("gif") {
                    self.currentImageState = .animated(url: URL(fileURLWithPath: imgURL.path))
                }
                else {
                    self.currentImageState = .localImage(path: imgURL.path)
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
        objectWillChange.send()
    }
    
    func setFailure() {
        self.currentImageState = .failure
    }
}
