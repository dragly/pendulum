import QtQuick 2.0
import QtGraphicalEffects 1.0

Item {
    property bool textBelow: false
    property real linesHeight: height - (lines.y + lines.height / 2)
    property alias angle: rotationTransform.angle
    width: 100
    height: 30

    transform: Rotation {
        id: rotationTransform
        origin.y: lines.y + lines.height / 2
    }

    Item {
        id: lines
        anchors {
            left: parent.left
            right: parent.right
            bottom: textBelow ? undefined : parent.bottom
            top: textBelow ? parent.top : undefined
        }
        height: parent.height / 2

        Rectangle {
            id: leftEdge
            anchors {
                top: parent.top
                bottom: parent.bottom
                left: parent.left
            }
            width: 1
            color: "#555"
        }
        Rectangle {
            id: rightEdge
            anchors {
                top: parent.top
                bottom: parent.bottom
                right: parent.right
            }
            width: 1
            color: "#555"
        }
        LinearGradient {
            id: line
            anchors {
                left: parent.left
                right: parent.right
                verticalCenter: parent.verticalCenter
            }
            height: 1
            start: Qt.point(0,0)
            end: Qt.point(width,0)
            gradient: Gradient {
                GradientStop {
                    position: 0
                    color: "#555"
                }

                GradientStop {
                    position: 0.3
                    color: "#cccccc"
                }

                GradientStop {
                    position: 0.5
                    color: "#dddddd"
                }

                GradientStop {
                    position: 0.7
                    color: "#cccccc"
                }

                GradientStop {
                    position: 1
                    color: "#555"
                }
            }
        }
    }
    Text {
        anchors {
            bottom: textBelow ? undefined : lines.top
            bottomMargin: -lines.height / 4 + parent.angle / 90 * width / 2
            top: textBelow ? lines.bottom : undefined
            topMargin: -lines.height / 4 + parent.angle / 90 * width / 2
            horizontalCenter: parent.horizontalCenter
        }
        text: (parent.width / 32).toFixed(1) + " m"
        font.pixelSize: parent.height / 2
        font.family: "Linux Libertine"
        font.weight: Font.Light
        rotation: -parent.angle
    }
}
