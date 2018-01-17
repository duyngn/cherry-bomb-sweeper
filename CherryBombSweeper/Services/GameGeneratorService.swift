//
//  GameServices.swift
//  C4Sweeper
//
//  Created by Duy Nguyen on 1/10/18.
//  Copyright © 2018 Duy.Ninja. All rights reserved.
//

import Foundation

class GameGeneratorService: NSObject {
    typealias GenerateNewGameCompletionHandler = (_ newGame: Game) -> Void
    typealias GenerateMineFieldCompletionHandler = (_ mineField: MineField) -> Void
    
    static let shared = GameGeneratorService()
    
    private let generatorQueue: DispatchQueue = DispatchQueue(label: "gameGeneratorQueue")
    
    var gameOptions: GameOptions
    var preloadedGame: Game?
    
    fileprivate override init() {
        self.gameOptions = GameOptions()
    }
    
    func preloadGame(forced: Bool = false) {
        self.generatorQueue.async {
            if forced || self.preloadedGame == nil {
                self.generateGame { (newGame) in
                    // Can ignore this handler since newGame was already captured
                    self.preloadedGame = newGame
                }
            }
        }
    }
    
    func generateNewGame(completionHandler: @escaping GenerateNewGameCompletionHandler) {
        self.generatorQueue.async {
            if let preloadedGame = self.preloadedGame {
                // return preloaded
                completionHandler(preloadedGame)
                
                // now preload another one
                self.preloadedGame = nil
                self.preloadGame()
            } else {
                self.generateGame { (newGame) in
                    completionHandler(newGame)
                    
                    // Since we didn't have a game preloaded, let's preload now
                    self.preloadGame()
                }
            }
        }
    }
    
    private func generateGame(completionHandler: @escaping GenerateNewGameCompletionHandler) {
        self.generateMineField { [weak self, completionHandler] (mineField) in
            guard let `self` = self else { return }
            
            let newGame = Game(mineField: mineField, gameOptions: self.gameOptions)
            
            completionHandler(newGame)
        }
    }
    
    private func generateMineField(completionHandler: @escaping GenerateMineFieldCompletionHandler) {
        let rows = self.gameOptions.rowCount
        let columns = self.gameOptions.columnCount
        let mines = self.gameOptions.minesCount
        
        // Construct the empty field
        let mineField = MineField.constructAndPopulateMineField(rows: rows, columns: columns, mines: mines)
        
        completionHandler(mineField)
    }
}
