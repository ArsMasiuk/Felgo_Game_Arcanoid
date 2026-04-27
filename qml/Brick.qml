import QtQuick 2.0

Rectangle {
    id: brick

    border.color: "white"

    property int hitPoints: 1
    property bool destroyed: false

    color: hitPoints >= 2 ? "magenta" : "steelblue"
    visible: !destroyed

    function hit() {
        hitPoints -= 1

        if (hitPoints <= 0) {
            destroyed = true
            return 10
        }

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