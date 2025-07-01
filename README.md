# Mastermind Game

A Swift terminal implementation of the classic Mastermind code-breaking game. Guess the 4-digit secret code (digits 1-6) and receive feedback with black pegs (correct digit in correct position) and white pegs (correct digit in wrong position).

## Project Structure
```
MastermindGame/
├── Package.swift
├── Sources/
│   ├── main.swift          # Entry point
│   ├── Models.swift        # Data models and error types
│   ├── APIClient.swift     # HTTP API communication
│   └── GameLogic.swift     # Game logic and user interface
└── README.md
```

## Setup & Run Instructions


**Build and run the project:**
   ```bash
   swift run
   ```

   **Alternative method:**
   ```bash
   swift build
   ./.build/debug/MastermindGame
   ```

### Game Commands
- Enter a 4-digit code (digits 1-6): Make a guess
- `new`: Start a new game
- `exit`: Quit the game

### Example Gameplay
```
Welcome to Mastermind!
Enter your guess (or 'exit'/'new'): 1234
Attempt #1: 1234
   Result: BBW
   Keep trying!
```