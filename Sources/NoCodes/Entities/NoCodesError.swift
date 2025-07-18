//
//  QonversionError.swift
//  Qonversion
//
//  Created by Suren Sarkisyan on 07.02.2024.
//

public struct NoCodesError: Error {
    public let type: NoCodesErrorType
    public let message: String
    public let error: Error?
    public let additionalInfo: [String: Any]?

    init(type: NoCodesErrorType, message: String? = nil, error: Error? = nil, additionalInfo: [String : Any]? = nil) {
        var errorMessage = message ?? type.message()
        if let noCodesError = error as? NoCodesError {
            errorMessage += "\n" + noCodesError.message
        } else if let error = error {
            errorMessage += "\n" + error.localizedDescription
        }

        self.type = type
        self.message = errorMessage
        self.error = error
        self.additionalInfo = additionalInfo
    }
    
    static func initializationError() -> NoCodesError {
        return NoCodesError(type: .sdkInitializationError)
    }
}
