import UIKit

enum TinkoffError: Error {

    private static let furstTimeAuthorizationErrorMessage = "Для корректной работы приложения вы должны оказаться хотя бы раз в онлайне, сейчас вы оффлай"
    private static let jsonSerializationErrorMessage = "Произошла ошибка сериализации ответа сервера"
    private static let cantGetPictureErrorMessage = "Произошла ошибка получения фотографии"

    case furstTimeAuthorizationError
    case jsonSerializationError
    case cantGetPictureError
    case customError(String)

    public var errorDescription: String {
        switch self {
        case .furstTimeAuthorizationError:
            return TinkoffError.furstTimeAuthorizationErrorMessage
        case .jsonSerializationError:
            return TinkoffError.jsonSerializationErrorMessage
        case .cantGetPictureError:
            return TinkoffError.cantGetPictureErrorMessage
        case .customError(let errorMessage):
            return errorMessage
        }
    }

}
