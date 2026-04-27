import QtQuick 2.0

Rectangle {
    id: gameOverScreen

    anchors.fill: parent
    color: "#CC000000"
    visible: false

    property int score: 0

    signal restartRequested()

    Column {
        anchors.centerIn: parent
        spacing: 10

        Text {
            text: "GAME OVER"
            color: "red"
            font.pixelSize: 32
            font.bold: true
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Text {
            text: "Score: " + gameOverScreen.score
            color: "white"
            font.pixelSize: 18
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Text {
            text: "Press Space to restart"
            color: "white"
            font.pixelSize: 14
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
}

