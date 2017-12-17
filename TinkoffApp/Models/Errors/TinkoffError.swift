import UIKit

enum TinkoffError: Error {

    private static let jsonSerializationErrorMessage = "Произошла ошибка сериализации ответа сервера"

    case jsonSerializationError
    case customError(String)

    public var errorDescription: String {
        switch self {
        case .jsonSerializationError:
            return TinkoffError.jsonSerializationErrorMessage
        case .customError(let errorMessage):
            return errorMessage
        }
    }

}
