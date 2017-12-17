import UIKit

class ImageDownloadService: NSObject {

    private let config: ImageDownloaderServiceConfig
    private let networkService: NetworkService
    private let reachability = Reachability()!

    init(config: ImageDownloaderServiceConfig, networkService: NetworkService) {
        self.config = config
        self.networkService = networkService
    }

    func downloadImage(named name: String,
                       withLastModified lastModified: String?,
                       withPixelSize pixelSize: String,
                       completition: @escaping (UIImage?, String?, Error?) -> Void) {
        print("Download Started")

        var lastModifiedToSend: String

        if lastModified == nil {
            lastModifiedToSend = ""
        } else {
            lastModifiedToSend = lastModified!
        }

        let url = config.downloadImagesURL.appending("\(pixelSize)/\(name)")

        guard  reachability.connection != .none else {
            return completition(getImageData(with: name), nil, nil)
        }

        networkService.makeCall(withMethod: "GET",
                                toUrl: url,
                                lastModified: lastModifiedToSend)
        { imageData, headers, error in

            if (imageData == nil && headers == nil && error == nil) {
                print("КАРТИНКА НЕ ОБНОВЛЯЛАСЬ")
                return completition(self.getImageData(with: name), lastModifiedToSend, nil)
            }

            guard
                error == nil,
                let imageData = imageData,
                let headers = headers
                else {
                    return completition(nil, nil, TinkoffError.cantGetPictureError)
            }
            print("Download Finished")
            self.save(imageData, withName: name)
            completition(UIImage(data: imageData), headers["Last-Modified"] as! String, error)
        }
    }

    private func save(_ imageData: Data, withName name: String) {
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                         .userDomainMask,
                                                         true)[0] as NSString).appendingPathComponent(name)
        let image = UIImage(data: imageData)
        let imageData = UIImageJPEGRepresentation(image!, 1.0)
        fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)
    }

    private func getDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }

    private func getImageData(with name: String) -> UIImage? {
        let fileManager = FileManager.default
        let imagePath = (self.getDirectoryPath() as NSString).appendingPathComponent(name)
        if fileManager.fileExists(atPath: imagePath) {
            print("ФАЙЛ СУЩЕСТВУЕТ")
            return UIImage(contentsOfFile: imagePath)
        } else {
            print("ФАЙЛ НЕ СУЩЕСТВУЕТ")
            return nil
        }
    }
}
