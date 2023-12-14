//
//  GameScene.swift
//  GPE
//
//  Created by LorenzoSpinosa on 13/12/23.
//

import Foundation
import SpriteKit

class GameScene: SKScene,SKPhysicsContactDelegate{
    
    var hero = SKSpriteNode()
    let herTexture = SKTexture(imageNamed: "margherito")
    
    enum bitMask: UInt32 {
        case hero = 0b1 // 1
        case ground = 0b10 //2
    }
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        
        for node in self.children {
            if node.name == "PlatformMap" {
                if let someTileMap = node as? SKTileMapNode {
                    giveTileMapPhysicsBody(map: someTileMap)
                    someTileMap.removeFromParent()
                    break
                }
            }
        }

        
        addHero()
        
       
    }
    
    // MARK: AddHero
    func addHero() {
        
        hero = childNode(withName: "margherito") as! SKSpriteNode
        
        hero.physicsBody = SKPhysicsBody(texture: herTexture, size: hero.size)
        hero.physicsBody?.categoryBitMask = bitMask.hero.rawValue
        hero.physicsBody?.contactTestBitMask = bitMask.ground.rawValue
        hero.physicsBody?.collisionBitMask = bitMask.ground.rawValue
        hero.physicsBody?.allowsRotation = false
        
          }
    
    func giveTileMapPhysicsBody(map : SKTileMapNode){
        let tileMap = map
        let startLocation : CGPoint = tileMap.position
        let tileSize = tileMap.tileSize
        let halfWidth = CGFloat(tileMap.numberOfColumns) / 2.0 * tileSize.width
        let halfHeight = CGFloat(tileMap.numberOfRows) / 2.0 * tileSize.height
        
        for col in 0..<tileMap.numberOfColumns {
            for row in 0..<tileMap.numberOfRows {
                giveTileMapPhysicsBody(map: tileMap, col: col, row: row)
            }
        }

        func giveTileMapPhysicsBody(map: SKTileMapNode, col: Int, row: Int) {
            // Verifica se c'è una definizione di tile alla colonna e riga specificate
            if let tileDefinition = tileMap.tileDefinition(atColumn: col, row: row) {
                
                // Recupera le texture associate alla definizione del tile
                let tileArray = tileDefinition.textures
                let tileTextures = tileArray[0]
                
                // Calcola la posizione del tile nella scena
                let x = CGFloat(col) * tileSize.width - halfWidth + (tileSize.width / 2)
                let y = CGFloat(row) * tileSize.height - halfHeight + (tileSize.height / 2)
                
                // Crea un nodo sprite utilizzando le texture del tile
                let tileNode = SKSpriteNode(texture: tileTextures)
                
                // Imposta la posizione del nodo tile
                tileNode.position = CGPoint(x: x, y: y)
                
                // Crea un corpo fisico per il tile utilizzando le sue texture
                tileNode.physicsBody = SKPhysicsBody(texture: tileTextures, size: CGSize(width: tileTextures.size().width, height: tileTextures.size().height))
                
                // Imposta le maschere di bit di categoria, contatto e collisione per le interazioni fisiche
                tileNode.physicsBody?.categoryBitMask = bitMask.ground.rawValue
                tileNode.physicsBody?.contactTestBitMask = bitMask.hero.rawValue
                tileNode.physicsBody?.collisionBitMask = bitMask.hero.rawValue
                
                // Configura le proprietà fisiche per il tile
                tileNode.physicsBody?.affectedByGravity = false
                tileNode.physicsBody?.isDynamic = false
                tileNode.physicsBody?.friction = 1
                
                // Imposta la z-position, anchor point e posizione del nodo tile nella scena
                tileNode.zPosition = 20
                tileNode.anchorPoint = .zero
                tileNode.position = CGPoint(x: tileNode.position.x, y: tileNode.position.y)
                
                // Aggiunge il nodo tile alla scena
                self.addChild(tileNode)
            }
        }
    }
    
}
