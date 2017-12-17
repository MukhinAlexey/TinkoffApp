import UIKit

enum TinkoffError: Error {

    private static let jsonSerializationErrorMessage = "Произошла ошибка сериализации ответа сервера"
    private static let cantGetPictureErrorMessage = "Произошла ошибка получения фотографии"

    case jsonSerializationError
    case cantGetPictureError
    case customError(String)

    public var errorDescription: String {
        switch self {
        case .jsonSerializationError:
            return TinkoffError.jsonSerializationErrorMessage
        case .cantGetPictureError:
            return TinkoffError.cantGetPictureErrorMessage
        case .customError(let errorMessage):
            return errorMessage
        }
    }

}
