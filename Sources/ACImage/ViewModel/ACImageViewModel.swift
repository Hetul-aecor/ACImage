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
            objectWillChange.send()
        }
        else if let imgString = imageURL, let imgURL = URL(string: imgString) {
            if FileManager.default.fileExists(atPath: imgURL.path) {
                if imgURL.pathExtension.lowercased().contains("gif") {
                    self.currentImageState = .animated(url: URL(fileURLWithPath: imgURL.path))
                    objectWillChange.send()
                }
                else {
                    self.currentImageState = .localImage(path: imgURL.path)
                    objectWillChange.send()
                }
            }
            else {
                self.currentImageState = .webImage(url: imgURL)
                objectWillChange.send()
            }
        }
        else if let nameInitials = nameInitials {
            self.currentImageState = .nameIntials(nameInitials: nameInitials)
            objectWillChange.send()
        }
        else {
            self.currentImageState = .failure
            objectWillChange.send()
        }
        objectWillChange.send()
    }
    
    func setFailure() {
        self.currentImageState = .failure
        objectWillChange.send()
    }
}
