import Felgo
import QtQuick
import QtQuick.Window


GameWindow {

  // this rectangle fills the whole screen with grey
  Rectangle {
    color: "#f0f0f0"
    anchors.fill: parent
  }

  Scene {

    property int score: 0

    Text {
        text: "Score: " + score
        color: "white"
        font.pixelSize: 20
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 10
    }

    /*
    Text {
      text: "Some Test"

      font.pixelSize: 16
      anchors.centerIn: parent
    }
    */
  }
}
