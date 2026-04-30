import QtQuick 2.0

// Screen shown on level completion
Rectangle {
    id: levelFinishedScreen

    anchors.fill: parent
    color: "#CC000000"
    visible: false

    property int score: 0

    signal restartRequested()

    Column {
        anchors.centerIn: parent
        spacing: 10

        Text {
            text: "LEVEL COMPLETE!"
            color: "lime"
            font.pixelSize: 32
            font.bold: true
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Text {
            text: "Score: " + levelFinishedScreen.score
            color: "white"
            font.pixelSize: 18
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Text {
            text: "Press Space to play again"
            color: "white"
            font.pixelSize: 14
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
}
