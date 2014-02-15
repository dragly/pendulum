import QtQuick 2.0
import QtQuick.Controls 1.1

Column {
    id: labeledSliderRoot
    property alias label: labelLabel.text
    property alias comment: commentLabel.text
    property alias slider: theSlider
    property alias font: labelLabel.font
    property alias value: theSlider.value
    spacing: 0
    Label {
        id: labelLabel
        anchors {
            horizontalCenter: parent.horizontalCenter
        }
        text: "Initial velocity:"
    }
    Slider {
        id: theSlider
        minimumValue: 10
        maximumValue: 200
        value: 50
        width: labeledSliderRoot.width
    }
    Label {
        id: commentLabel
        anchors {
            horizontalCenter: parent.horizontalCenter
        }
        text: (theSlider.value / 32).toFixed(1) + " m/s"
        font.family: labelLabel.font.family
        font.pixelSize: labelLabel.font.pixelSize
    }
}
