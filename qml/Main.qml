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

        Keys.onPressed: function(event) {
            if (event.key === Qt.Key_Left)
                gameArea.leftPressed = true

            if (event.key === Qt.Key_Right)
                gameArea.rightPressed = true

            if (event.key === Qt.Key_Space && gameArea.ballStuck) {
                gameArea.ballStuck = false
                event.accepted = true
            }
        }

        Keys.onReleased: function(event) {
            if (event.key === Qt.Key_Left)
                gameArea.leftPressed = false

            if (event.key === Qt.Key_Right)
                gameArea.rightPressed = false
        }

        Rectangle {
            id: gameArea
            anchors.fill: parent
            color: "black"

            // game variables
            property real ballSpeedX: 3
            property real ballSpeedY: 3
            property bool ballStuck: true

            property real paddleSpeed: 6
            property bool leftPressed: false
            property bool rightPressed: false

            property int score: 0

            property int cols: 10
            property int rows: 3
            property real brickSpacing: 4

            property real brickWidth: (width - (cols + 1) * brickSpacing) / cols
            property real brickHeight: 20


            // Paddle
            Rectangle {
                id: paddle
                width: 100
                height: 15
                color: "white"
                radius: 5
                y: parent.height - 30
                x: parent.width / 2 - width / 2

                /*MouseArea {
                    anchors.fill: parent
                    drag.target: paddle
                    drag.axis: Drag.XAxis
                    drag.minimumX: 0
                    drag.maximumX: gameArea.width - paddle.width
                }*/
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
            }

            // Bricks
            Repeater {
                model: gameArea.cols * gameArea.rows

                Rectangle {
                    width: gameArea.brickWidth
                    height: gameArea.brickHeight

                    color: "steelblue"
                    border.color: "white"

                    property int col: index % gameArea.cols
                    property int row: Math.floor(index / gameArea.cols)

                    x: gameArea.brickSpacing + col * (gameArea.brickWidth + gameArea.brickSpacing)
                    y: gameArea.brickSpacing + row * (gameArea.brickHeight + gameArea.brickSpacing)

                    property bool destroyed: false
                    visible: !destroyed
                }
            }

            Timer {
                interval: 16
                running: true
                repeat: true

                onTriggered: {
                    // Paddle movement
                    if (gameArea.leftPressed)
                        paddle.x -= gameArea.paddleSpeed

                    if (gameArea.rightPressed)
                        paddle.x += gameArea.paddleSpeed

                    // Clamp inside screen
                    if (paddle.x < 0)
                        paddle.x = 0

                    if (paddle.x + paddle.width > gameArea.width)
                        paddle.x = gameArea.width - paddle.width



                    // Ball movement
                    if (gameArea.ballStuck) {
                        // Stick ball to paddle
                        ball.x = paddle.x + paddle.width / 2 - ball.width / 2
                        ball.y = paddle.y - ball.height - 2
                        return
                    }

                    // Move ball
                    ball.x += gameArea.ballSpeedX
                    ball.y += gameArea.ballSpeedY

                    // Walls
                    if (ball.x <= 0 || ball.x + ball.width >= gameArea.width)
                        gameArea.ballSpeedX *= -1

                    if (ball.y <= 0){
                        ball.y = 1
                        gameArea.ballSpeedY *= -1
                    }

                    // Paddle collision
                    if (ball.y + ball.height >= paddle.y &&
                        ball.x + ball.width >= paddle.x &&
                        ball.x <= paddle.x + paddle.width) {
                        gameArea.ballSpeedY *= -1
                    }

                    // Bottom → reset and stick again
                    if (ball.y > gameArea.height) {
                        gameArea.ballStuck = true
                    }




                    // Brick collisions
                    for (let i = 0; i < gameArea.children.length; i++) {
                        let item = gameArea.children[i]
                        if (item.destroyed !== undefined && !item.destroyed) {
                            if (ball.x < item.x + item.width &&
                                ball.x + ball.width > item.x &&
                                ball.y < item.y + item.height &&
                                ball.y + ball.height > item.y) {

                                item.destroyed = true
                                gameArea.ballSpeedY *= -1
                                break
                            }
                        }
                    }
                }
            }
        }
    }
}
