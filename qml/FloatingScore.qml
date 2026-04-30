import QtQuick 2.0

// A score popup which is dynamically created at the position of a destroyed brick.
// It floats downward while fading out, then cleans itself up.
Text {
    id: floatingScore

    property real startX: 0
    property real startY: 0

    x: startX
    y: startY
    color: "yellow"
    font.pixelSize: 14
    font.bold: true

    opacity: 1

    ParallelAnimation {
        id: floatAnimation
        running: false

        NumberAnimation {
            target: floatingScore
            property: "y"
            to: floatingScore.startY + 40
            duration: 600
            easing.type: Easing.OutQuad
        }

        NumberAnimation {
            target: floatingScore
            property: "opacity"
            to: 0
            duration: 600
            easing.type: Easing.InQuad
        }

        onStopped: floatingScore.destroy()
    }

    Component.onCompleted: floatAnimation.start()
}