//
//  UIImageView+Extensions.swift
//  SpaceXDirectoryApp
//
//  Created by Kirill Berezhnoy on 18.12.2023.
//

import UIKit

// MARK: - UIImageView
extension UIImageView {
    
    private static var imageCache = NSCache<NSString, UIImage>()
    
    func load(url: String?, completion: (() -> Void)? = nil) {
        // Очищаем изображение, чтобы избежать мерцания старого изображения при переиспользовании ячейки
        image = nil
        
        guard let urlString = url else {
            self.image = UIImage(named: "notFoundImage")
            return
        }
        
        // Проверяем, есть ли изображение в кэше
        if let cachedImage = UIImageView.imageCache.object(forKey: urlString as NSString) {
            image = cachedImage
            completion?()
            return
        }
        
        // Преобразуем строку в URL
        guard let imageUrl = URL(string: urlString) else {
            self.image = UIImage(named: "notFoundImage")
            completion?()
            return
        }
        
        // Создаем URLSessionDataTask для загрузки изображения
        DispatchQueue.global().async {
            let task = URLSession.shared.dataTask(with: imageUrl) { [weak self] (data, response, error) in
                guard let self = self, let data = data, error == nil else {
                    self?.image = UIImage(named: "notFoundImage")
                    completion?()
                    return
                }
                
                // Создаем изображение из полученных данных
                if let downloadedImage = UIImage(data: data) {
                    // Кэшируем изображение
                    UIImageView.imageCache.setObject(downloadedImage, forKey: urlString as NSString)
                    
                    // Передаем изображение на основной поток для обновления UI
                    DispatchQueue.main.async {
                        self.image = downloadedImage
                        completion?()
                    }
                }
            }
            // Запускаем задачу и сохраняем ее для возможности отмены
            task.resume()
        }
    }
}
