import UIKit

class ImageDownloaderService: NSObject {

    let config: ImageDownloaderServiceConfig

    init(config: ImageDownloaderServiceConfig) {
        self.config = config
    }

    func downloadImage(named name: String) {
        print("Download Started")
        guard let url = URL(string: config.downloadImagesURL) else {
            return
        }
        getDataFromUrl(url: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async {
                // imageView.image = UIImage(data: data)
            }
        }
    }

    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
}
