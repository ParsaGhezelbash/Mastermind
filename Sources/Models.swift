import Foundation

struct CreateGameResponse: Codable {
    let game_id: String
}

struct GuessRequest: Codable {
    let game_id: String
    let guess: String
}

struct GuessResponse: Codable {
    let black: Int
    let white: Int
}

struct ErrorResponse: Codable {
    let error: String
}

enum APIError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case serverError(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response"
        case .serverError(let message):
            return "Server error: \(message)"
        }
    }
}

enum GameError: Error, LocalizedError {
    case invalidInput
    case invalidGuessFormat
    
    var errorDescription: String? {
        switch self {
        case .invalidInput:
            return "Invalid input"
        case .invalidGuessFormat:
            return "Invalid guess format. Please enter 4 digits between 1-6"
        }
    }
}
