/*!
    \mainpage Arcanoid Game Tutorial

    Welcome to Arcanoid documentation.
*/

import Felgo 4.0
import QtQuick 2.0

GameWindow {
    id: gameWindow

    activeScene: scene

    // the size of the Window can be changed at runtime by pressing Ctrl (or Cmd on Mac) + the number keys 1-8
    // the content of the logical scene size (480x320 for landscape mode by default) gets scaled to the window size based on the scaleMode
    // you can set this size to any resolution you would like your project to start with, most of the times the one of your main target device
    // this resolution is for iPhone 4 & iPhone 4S
    screenWidth: 960
    screenHeight: 640

    Scene {
        id: scene

        // the "logical size" - the scene content is auto-scaled to match the GameWindow size
        width: 480
        height: 320

        focus: true   // IMPORTANT: enables key handling
        Component.onCompleted: forceActiveFocus()

        Rectangle {
            id: gameArea
            anchors.fill: parent
            color: "black"

            // Game variables
            property int score: 0
            property int lives: 5
            property bool gameOver: false
            property bool levelFinished: false

            // Initialization function to reset the game state
            function initGame() {
                score = 0
                lives = 5
                gameOver = false
                levelFinished = false
                ball.ballStuck = true
                ball.ballSpeedX = 3
                ball.ballSpeedY = 3
                paddle.x = gameArea.width / 2 - paddle.width / 2

                for (let i = 0; i < bricks.count; i++) {
                    let item = bricks.itemAt(i)
                    if (item) {
                        let row = Math.floor(i / bricks.cols)
                        item.hitPoints = row === 0 ? 2 : 1
                        item.destroyed = false
                    }
                }
            }

            Component.onCompleted: initGame()

            // Score display
            Text {
                text: "Score: " + gameArea.score
                color: "white"
                font.pixelSize: 14
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.margins: 2
            }

            // Lives display
            Text {
                text: "Lives: " + gameArea.lives
                color: "white"
                font.pixelSize: 14
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.margins: 2
            }

            // Paddle
            Rectangle {
                id: paddle
                width: 100
                height: 15
                color: "white"
                radius: 5
                y: parent.height - 30
                x: parent.width / 2 - width / 2

                property real paddleSpeed: 6
                property bool leftPressed: false
                property bool rightPressed: false
            }

            // Ball
            Rectangle {
                id: ball
                width: 12
                height: 12
                radius: 6
                color: "red"
                x: parent.width / 2
                y: parent.height / 2

                property real ballSpeedX: 3
                property real ballSpeedY: 3
                property bool ballStuck: true
            }

            // Bricks
            Repeater {
                id: bricks
                model: bricks.cols * bricks.rows

                property int cols: 10
                property int rows: 3
                property real brickSpacing: 4
                property real brickWidth: (gameArea.width - (cols + 1) * brickSpacing) / cols
                property real brickHeight: 20

                Brick {
                    width: bricks.brickWidth
                    height: bricks.brickHeight

                    property int col: index % bricks.cols
                    property int row: Math.floor(index / bricks.cols)

                    x: bricks.brickSpacing + col * (bricks.brickWidth + bricks.brickSpacing)
                    y: bricks.brickSpacing + row * (bricks.brickHeight + bricks.brickSpacing) + 20
                }
            }

            Timer {
                interval: 16
                running: !gameArea.gameOver && !gameArea.levelFinished
                repeat: true

                onTriggered: {
                    // Paddle movement
                    if (paddle.leftPressed)
                        paddle.x -= paddle.paddleSpeed

                    if (paddle.rightPressed)
                        paddle.x += paddle.paddleSpeed

                    // Clamp inside screen
                    if (paddle.x < 0)
                        paddle.x = 0

                    if (paddle.x + paddle.width > gameArea.width)
                        paddle.x = gameArea.width - paddle.width



                    // Ball movement
                    if (ball.ballStuck) {
                        ball.x = paddle.x + paddle.width / 2 - ball.width / 2
                        ball.y = paddle.y - ball.height - 2
                        return
                    }

                    // Move ball
                    ball.x += ball.ballSpeedX
                    ball.y += ball.ballSpeedY

                    // Walls
                    if (ball.x <= 0 || ball.x + ball.width >= gameArea.width)
                        ball.ballSpeedX *= -1

                    if (ball.y <= 0){
                        ball.y = 1
                        ball.ballSpeedY *= -1
                    }

                    // Paddle collision
                    if (ball.y + ball.height >= paddle.y &&
                        ball.x + ball.width >= paddle.x &&
                        ball.x <= paddle.x + paddle.width) {
                        ball.ballSpeedY *= -1
                    }

                    // Bottom → lose a life and stick again
                    if (ball.y > gameArea.height) {
                        gameArea.lives -= 1
                        if (gameArea.lives <= 0) {
                            gameArea.lives = 0
                            ball.ballStuck = true
                            gameArea.gameOver = true
                        } else {
                            ball.ballStuck = true
                        }
                    }

                    // Brick collisions
                    for (let i = 0; i < bricks.count; i++) {
                        let item = bricks.itemAt(i)
                         if (item && item.collides(ball.x, ball.y, ball.width, ball.height)) {
                            let points = item.hit()
                            gameArea.score += points
                            gameArea.spawnFloatingScore(
                                item.x + item.width / 2 - 10,
                                item.y,
                                points
                            )
                            ball.ballSpeedY *= -1

                            // Check if all bricks destroyed
                            if (gameArea.checkLevelFinished()) {
                                gameArea.levelFinished = true
                                ball.ballStuck = true
                            }

                            break
                        }
                    }
                }
            }

            // Floating score component
            Component {
                id: floatingScoreComponent
                FloatingScore {}
            }

            function spawnFloatingScore(px, py, points) {
                if (points <= 0) return
                var item = floatingScoreComponent.createObject(gameArea, {
                    "text": "+" + points,
                    "startX": px,
                    "startY": py
                })
            }

            function checkLevelFinished() {
                for (let i = 0; i < bricks.count; i++) {
                    let item = bricks.itemAt(i)
                    if (item && !item.destroyed)
                        return false
                }
                return true
            }
        }

        // Game Over screen
        GameOverScreen {
            id: gameOverScreen
            score: gameArea.score
            visible: gameArea.gameOver

            onRestartRequested: gameArea.initGame()
        }

        // Level Finished screen
        LevelFinishedScreen {
            id: levelFinishedScreen
            score: gameArea.score
            visible: gameArea.levelFinished

            onRestartRequested: gameArea.initGame()
        }

        Keys.onPressed: function(event) {
            if (event.key === Qt.Key_Left)
                paddle.leftPressed = true

            if (event.key === Qt.Key_Right)
                paddle.rightPressed = true

            if (event.key === Qt.Key_Space) {
                if (gameArea.gameOver || gameArea.levelFinished) {
                    gameArea.initGame()
                    event.accepted = true
                } else if (ball.ballStuck) {
                    ball.ballStuck = false
                    event.accepted = true
                }
            }
        }

        Keys.onReleased: function(event) {
            if (event.key === Qt.Key_Left)
                paddle.leftPressed = false

            if (event.key === Qt.Key_Right)
                paddle.rightPressed = false
        }
    }
}
