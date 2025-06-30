import Foundation

class MastermindAPI {
    private let baseURL = "https://mastermind.darkube.app"
    
    func createGame() async throws -> String {
        guard let url = URL(string: "\(baseURL)/game") else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        if httpResponse.statusCode == 200 {
            let gameResponse = try JSONDecoder().decode(CreateGameResponse.self, from: data)
            return gameResponse.game_id
        } else {
            let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
            throw APIError.serverError(errorResponse.error)
        }
    }
    
    func submitGuess(gameId: String, guess: String) async throws -> GuessResponse {
        guard let url = URL(string: "\(baseURL)/guess") else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let guessRequest = GuessRequest(game_id: gameId, guess: guess)
        let requestData = try JSONEncoder().encode(guessRequest)
        request.httpBody = requestData
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        if httpResponse.statusCode == 200 {
            return try JSONDecoder().decode(GuessResponse.self, from: data)
        } else {
            let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
            throw APIError.serverError(errorResponse.error)
        }
    }
    
    func deleteGame(gameId: String) async throws {
        guard let url = URL(string: "\(baseURL)/game/\(gameId)") else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        if httpResponse.statusCode != 204 {
            throw APIError.serverError("Failed to delete game")
        }
    }
}