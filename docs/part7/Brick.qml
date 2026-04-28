import QtQuick 2.0

Rectangle {
    id: brick

    border.color: "white"

    property int hitPoints: 1
    property bool destroyed: false

    color: hitPoints >= 2 ? "magenta" : "steelblue"
    visible: opacity > 0

    // Fade + scale out when destroyed
    opacity: destroyed ? 0 : 1
    scale: destroyed ? 1.5 : 1

    Behavior on opacity {
        NumberAnimation { duration: 200; easing.type: Easing.OutQuad }
    }

    Behavior on scale {
        NumberAnimation { duration: 200; easing.type: Easing.OutQuad }
    }

    // Flash white on hit
    Rectangle {
        id: flashOverlay
        anchors.fill: parent
        color: "white"
        opacity: 0

        SequentialAnimation {
            id: flashAnimation
            NumberAnimation { target: flashOverlay; property: "opacity"; to: 0.8; duration: 50 }
            NumberAnimation { target: flashOverlay; property: "opacity"; to: 0; duration: 150 }
        }
    }

    function hit() {
        hitPoints -= 1

        if (hitPoints <= 0) {
            destroyed = true
            return 10
        }

        // Flash on non-destroying hit
        flashAnimation.start()

        if (hitPoints >= 1)
            return 5

        return 0
    }

    function collides(bx, by, bw, bh) {
        if (destroyed)
            return false

        return bx < brick.x + brick.width &&
               bx + bw > brick.x &&
               by < brick.y + brick.height &&
               by + bh > brick.y
    }
}
