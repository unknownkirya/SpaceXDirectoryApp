//
//  UIImageView+Extensions.swift
//  SpaceXDirectoryApp
//
//  Created by Kirill Berezhnoy on 18.12.2023.
//

import UIKit

// MARK: - UIImageView
extension UIImageView {
    
    // MARK: - Private static property
    private static var imageCache = NSCache<NSString, UIImage>()
    
    // MARK: - Public method
    func load(url: String?, completion: (() -> Void)? = nil) {

        image = nil
        
        guard let urlString = url else {
            self.image = UIImage(named: "notFoundImage")
            return
        }

        if let cachedImage = UIImageView.imageCache.object(forKey: urlString as NSString) {
            image = cachedImage
            completion?()
            return
        }
        
        guard let imageUrl = URL(string: urlString) else {
            self.image = UIImage(named: "notFoundImage")
            completion?()
            return
        }
        
        DispatchQueue.global().async {
            let task = URLSession.shared.dataTask(with: imageUrl) { [weak self] (data, response, error) in
                guard let self = self, let data = data, error == nil else {
                    self?.image = UIImage(named: "notFoundImage")
                    completion?()
                    return
                }

                if let downloadedImage = UIImage(data: data) {
                    UIImageView.imageCache.setObject(downloadedImage, forKey: urlString as NSString)
                    
                    DispatchQueue.main.async {
                        self.image = downloadedImage
                        completion?()
                    }
                }
            }
            task.resume()
        }
    }
}
