import Foundation

class MastermindGame {
    private let api = MastermindAPI()
    private var currentGameId: String?
    private var attemptCount = 0
    
    func start() async {
        printWelcomeMessage()
        await startNewGame()
        await gameLoop()
    }
    
    private func printWelcomeMessage() {
        print("Welcome to Mastermind!")
        print("Guess the 4-digit secret code (digits 1-6)")
        print("B = Correct digit in correct position")
        print("W = Correct digit in wrong position")
        print("Type 'exit' to quit, 'new' to start a new game\n")
    }
    
    private func startNewGame() async {
        do {
            print("🎮 Starting new game...")
            currentGameId = try await api.createGame()
            attemptCount = 0
            print("Game started! Game ID: \(currentGameId ?? "unknown")\n")
        } catch {
            print("Failed to start game: \(error.localizedDescription)")
            print("Please try again or type 'exit' to quit.")
        }
    }
    
    private func gameLoop() async {
        while true {
            print("Enter your guess (or 'exit'/'new'): ", terminator: "")
            
            guard let input = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines) else {
                continue
            }
            
            await handleUserInput(input)
        }
    }
    
    private func handleUserInput(_ input: String) async {
        switch input.lowercased() {
        case "exit":
            await cleanupAndExit()
            return
        case "new":
            await startNewGame()
        default:
            await processGuessInput(input)
        }
    }
    
    private func processGuessInput(_ input: String) async {
        do {
            try validateGuess(input)
            await processGuess(input)
        } catch {
            print("\(error.localizedDescription)")
        }
    }
    
    private func validateGuess(_ guess: String) throws {
        guard guess.count == 4 else {
            throw GameError.invalidGuessFormat
        }
        
        for char in guess {
            guard let digit = Int(String(char)), digit >= 1 && digit <= 6 else {
                throw GameError.invalidGuessFormat
            }
        }
    }
    
    private func processGuess(_ guess: String) async {
        guard let gameId = currentGameId else {
            print("No active game. Starting new game...")
            await startNewGame()
            return
        }
        
        do {
            attemptCount += 1
            let response = try await api.submitGuess(gameId: gameId, guess: guess)
            
            displayGuessResult(guess: guess, response: response)
            
            if response.black == 4 {
                handleGameWon()
                await startNewGame()
            } else {
                print("   Keep trying!\n")
            }
            
        } catch APIError.serverError(let message) where message.contains("404") || message.contains("not found") {
            print("Game session expired. Starting new game...")
            await startNewGame()
        } catch {
            print("Error submitting guess: \(error.localizedDescription)")
        }
    }
    
    private func displayGuessResult(guess: String, response: GuessResponse) {
        print("Attempt #\(attemptCount): \(guess)")
        print("   Result: \(formatResult(black: response.black, white: response.white))")
    }
    
    private func handleGameWon() {
        print("Congratulations! You cracked the code in \(attemptCount) attempts!")
        print("Starting new game...")
    }
    
    private func formatResult(black: Int, white: Int) -> String {
        let blackPegs = String(repeating: "B", count: black)
        let whitePegs = String(repeating: "W", count: white)
        let result = blackPegs + whitePegs
        return result.isEmpty ? "No matches" : result
    }
    
    private func cleanupAndExit() async {
        if let gameId = currentGameId {
            do {
                try await api.deleteGame(gameId: gameId)
                print("Game cleaned up successfully")
            } catch {
                print("Warning: Failed to cleanup game: \(error.localizedDescription)")
            }
        }
        print("Thanks for playing Mastermind!")
        exit(0)
    }
}