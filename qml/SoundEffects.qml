import Felgo 4.0
import QtQuick 2.0

Item {
    // Export sound effects
    property alias paddle: sfxPaddle
    property alias brickHit: sfxBrickHit
    property alias brickDestroy: sfxBrickDestroy
    property alias wall: sfxWall
    property alias loseLife: sfxLoseLife
    property alias gameOver: sfxGameOver
    property alias levelComplete: sfxLevelComplete
    property alias launch: sfxLaunch

    // Link effects to assets
    GameSoundEffect {
        id: sfxPaddle
        source: Qt.resolvedUrl("../assets/sounds/paddle.wav")
    } 
    GameSoundEffect {
        id: sfxBrickHit
        source: Qt.resolvedUrl("../assets/sounds/brick_hit.wav")
    }
    GameSoundEffect {
        id: sfxBrickDestroy
        source: Qt.resolvedUrl("../assets/sounds/brick_destroy.wav")
    }
    GameSoundEffect {
        id: sfxWall
        source: Qt.resolvedUrl("../assets/sounds/wall.wav")
    }
    GameSoundEffect {
        id: sfxLoseLife
        source: Qt.resolvedUrl("../assets/sounds/lose_life.wav")
    }
    GameSoundEffect {
        id: sfxGameOver
        source: Qt.resolvedUrl("../assets/sounds/game_over.wav")
    }
    GameSoundEffect {
        id: sfxLevelComplete
        source: Qt.resolvedUrl("../assets/sounds/level_complete.wav")
    }
    GameSoundEffect {
        id: sfxLaunch
        source: Qt.resolvedUrl("../assets/sounds/launch.wav")
    }
    
}
