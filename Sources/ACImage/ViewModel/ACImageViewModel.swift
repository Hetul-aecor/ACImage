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
    let nameInitials: String?
    let urlType: URLType
    
    @Published private(set) var currentImageState : ImageStateValue! = .loading
    @Published private(set) var forcedUpdate: Bool = false
    
    init(imageURL: String? = nil, nameInitials: String?, urlType: URLType) {
        self.imageURL = imageURL
        self.nameInitials = nameInitials
        self.urlType = urlType
    }
    
}

//MARK:- Other methods
extension ACImageViewModel {
    func setupState(isLocalImage: Bool = false) {
        switch urlType {
        case .youtube, .youtubeEmbeded:
            prepareThumbnailURL(type: urlType)
            if let imgString = imageURL, let url = URL(string: imgString) {
                currentImageState = .webImage(url: url)
            }
            else {
                setFailure()
            }
            forcedUpdate.toggle()
            objectWillChange.send()
        case .image:
            if let imgString = imageURL, let imgURL = URL(string: imgString) {
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
                forcedUpdate.toggle()
                objectWillChange.send()
            }
            else if let nameInitials = nameInitials {
                currentImageState = .nameIntials(nameInitials: nameInitials)
                forcedUpdate.toggle()
                objectWillChange.send()
            }
            else {
                setFailure()
            }
        case .none:
            currentImageState = .localImage(path: nil)
            forcedUpdate.toggle()
            objectWillChange.send()
        }
    }
    
    func setFailure() {
        currentImageState = .failure
        forcedUpdate.toggle()
        objectWillChange.send()
    }
    
}

extension ACImageViewModel {
    /// prepares thumbnail url
    public func prepareThumbnailURL(type: URLType) {
        switch type {
        case .youtube:
            guard let url = imageURL?.removingPercentEncoding else {
                return
            }
            do {
                let regex = try NSRegularExpression(pattern: "((?<=(v|V)/)|(?<=be/)|(?<=(\\?|\\&)v=)|(?<=embed/))([\\w-]++)", options: .caseInsensitive)
                let range = NSRange(location: 0, length: url.count)
                if let matchRange = regex.firstMatch(in: url, options: .reportCompletion, range: range)?.range {
                    let matchLength = (matchRange.lowerBound + matchRange.length) - 1
                    if range.contains(matchRange.lowerBound) &&
                        range.contains(matchLength) {
                        let start = url.index(url.startIndex, offsetBy: matchRange.lowerBound)
                        let end = url.index(url.startIndex, offsetBy: matchLength)
                        let videoId = String(url[start...end])
                        imageURL = "https://img.youtube.com/vi/\(videoId)/hqdefault.jpg"
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
            
        case .youtubeEmbeded:
            guard let videoId = URL(string: self.imageURL ?? "")?.lastPathComponent else {
                return
            }
            imageURL = "https://img.youtube.com/vi/\(videoId)/hqdefault.jpg"
        default:
            break
        }
    }
}
