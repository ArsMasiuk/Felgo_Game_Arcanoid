import Felgo 4.0
import QtQuick 2.0

GameWindow {
    id: gameWindow

    // You get free licenseKeys from https://felgo.com/licenseKey
    // With a licenseKey you can:
    //  * Publish your games & apps for the app stores
    //  * Remove the Felgo Splash Screen or set a custom one (available with the Pro Licenses)
    //  * Add plugins to monetize, analyze & improve your apps (available with the Pro Licenses)
    //licenseKey: "<generate one from https://felgo.com/licenseKey>"

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

        Rectangle {
            id: gameArea
            anchors.fill: parent
            color: "black"

            property real ballSpeedX: 3
            property real ballSpeedY: -3

            // Paddle
            Rectangle {
                id: paddle
                width: 100
                height: 15
                color: "white"
                radius: 5
                y: parent.height - 30
                x: parent.width / 2 - width / 2

                MouseArea {
                    anchors.fill: parent
                    drag.target: paddle
                    drag.axis: Drag.XAxis
                    drag.minimumX: 0
                    drag.maximumX: gameArea.width - paddle.width
                }
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
                model: 30
                Rectangle {
                    width: 50
                    height: 20
                    color: "steelblue"
                    border.color: "white"

                    x: (index % 10) * 60 + 10
                    y: Math.floor(index / 10) * 30 + 10

                    property bool destroyed: false
                    visible: !destroyed
                }
            }

            Timer {
                interval: 16
                running: true
                repeat: true
                onTriggered: {
                    // Move ball
                    ball.x += gameArea.ballSpeedX
                    ball.y += gameArea.ballSpeedY

                    // Wall collisions
                    if (ball.x <= 0 || ball.x + ball.width >= gameArea.width)
                        gameArea.ballSpeedX *= -1

                    if (ball.y <= 0)
                        gameArea.ballSpeedY *= -1

                    // Paddle collision
                    if (ball.y + ball.height >= paddle.y &&
                        ball.x + ball.width >= paddle.x &&
                        ball.x <= paddle.x + paddle.width) {
                        gameArea.ballSpeedY *= -1
                    }

                    // Bottom (reset)
                    if (ball.y > gameArea.height) {
                        ball.x = gameArea.width / 2
                        ball.y = gameArea.height / 2
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
