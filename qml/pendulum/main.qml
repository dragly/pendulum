import QtQuick 2.0
import Box2D 1.0
import QtQuick.Controls 1.1

Rectangle {
    width: 1280
    height: 720
    Project {
        anchors.fill: parent
        Experiment {
            lefts: Column {
                height: parent.height
                width: parent.width / 2
                spacing: parent.width * 0.05
                Text {
                    text: "<h1>Pendulum</h1>" +
                          "The slider below allows you to set the rope length " +
                          "of the pendulum. See if you can make it have a period " +
                          "of 2 seconds."
                    width: parent.width
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    font.family: "Linux Libertine"
                    font.pixelSize: parent.width * 0.04
                }
                Slider {
                    id: ropeLengthSlider
                    minimumValue: 50
                    maximumValue: 200
                    value: 100
                    width: parent.width
                }

                Button {
                    text: "Reset"
                    onClicked: {
                        ropeLengthSlider.value = 100
                        experiment.reset()
                    }
                }
            }
            rights: Pendulum {
                id: experiment
                ropeLength: ropeLengthSlider.value
                anchors {
                    top: parent.top
                    bottom: parent.bottom
                }
                width: Math.max(100, parent.width / 2)
            }
        }
        Rectangle {
            color: "yellow"
        }
        Rectangle {
            color: "green"
        }
    }
}
