//
//  UIImageView+Extensions.swift
//  SpaceXDirectoryApp
//
//  Created by Kirill Berezhnoy on 18.12.2023.
//

import UIKit

extension UIImageView {
    func load(url: String?) {
        DispatchQueue.global().async {
            if let url = url {
                if let imageUrl = URL(string: url) {
                    let semaphore = DispatchSemaphore(value: 0)
                    var image: UIImage?
                    URLSession.shared.dataTask(with: imageUrl) { data, response, error in
                        defer {
                            semaphore.signal()
                        }
                        if let error = error {
                            print("Ошибка при загрузке изображения: \(error)")
                            return
                        }
                        if let data = data {
                            image = UIImage(data: data)
                        }
                    }.resume()
                    semaphore.wait()
                    DispatchQueue.main.async {
                        self.image = image
                    }
                } else {
                    DispatchQueue.main.async {
                        self.image = UIImage(named: "notFoundImage")
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.image = UIImage(named: "notFoundImage")
                }
            }
        }
    }
}
