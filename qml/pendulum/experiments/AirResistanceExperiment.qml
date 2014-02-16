import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1
import Box2D 1.1
import ".."
import "../controls"

Experiment {
    id: experimentRoot
    lefts: Column {
        anchors.fill: parent
        spacing: parent.width * 0.01
        Text {
            text: "Air resistance"
            width: parent.width
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            font.family: "Linux Libertine"
            font.pixelSize: experimentRoot.width * 0.04
        }

        Text {
            text: "<p>The energy of a pendulum is not conserved " +
                  "if there is friction or air resistance in the " +
                  "system.</p><br>" +
                  "<p>In this experiment we have added a drag " +
                  "force that you may control by changing the " +
                  "drag coefficient D. The force is given as</p>"
            width: parent.width
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            font.family: "Linux Libertine"
            font.pixelSize: experimentRoot.width * 0.018
        }

        Image {
            source: "air-resistance.svg"
            fillMode: Image.PreserveAspectFit
            sourceSize.width: width * 1.4
            width: parent.width / 5
//            height: width
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Text {
            text: "<p>where v is the velocity of the ball.</p><br>" +
                  "<p>Use the sliders to adjust the level of " +
                  "air resistance for this pendulum.</p><br>" +
                  "<p>What does the initial velocity have to be to " +
                  "for the ball to make a complete loop? " +
                  "The length of the rod is " +
                  (global.rodLength / 32).toFixed(1) + " m</p>"
            width: parent.width
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            font.family: "Linux Libertine"
            font.pixelSize: experimentRoot.width * 0.018
        }
    }
    rights: Item {
        anchors.fill: parent
        Rectangle {
            id: global
            property real rodLength: parent.width * 0.3
            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
                bottom: buttonRow.top
            }

            Component.onCompleted: {
                reset()
            }

            function reset() {
                ball.x = mount.x
                ball.y = mount.y + rodLength
                ropeJoint.length = rodLength
                ball.targetVelocity = Qt.point(initialVelocitySlider.value,0)
                ball.linearVelocity = ball.targetVelocity
            }

            World {
                id: world
                anchors.fill: parent
                running: experimentRoot.running

                Line {
                    startPoint: Qt.point(ball.x, ball.y)
                    endPoint: Qt.point(mount.x, mount.y)
                    color: "grey"
                }

                Body {
                    id: mount
                    x: parent.width / 2
                    y: parent.height / 3
                    width: parent.width * 0.01
                    height: width
                    bodyType: Body.Static
                    fixtures: Circle {
                        anchors.fill: parent
                        density: 0.5
                        restitution: 0.5
                        friction: 0.0
                    }

                    Rectangle {
                        width: parent.width
                        height: parent.height
                        radius: width / 2
                        color: "grey"
                        x: - radius
                        y: - radius
                    }
                }

                Body {
                    id: ball
                    property double prevX: 0
                    property point targetVelocity

                    width: parent.width * 0.05
                    height: width
                    bodyType: Body.Dynamic
                    fixtures: Circle {
                        anchors.fill: parent
                        density: 500
                        restitution: 0.5
                        friction: 0.0
                    }
//                    linearDamping: airResistanceSlider.value

                    Rectangle {
                        width: parent.width
                        height: parent.height
                        radius: width / 2
                        color: "#98F8F8"
                        border.color: "#90C0F8"
                        border.width: 2
                        x: - radius
                        y: - radius
                    }
                }

                DistanceJoint {
                    id: ropeJoint
                    world: world
                    bodyA: ball
                    bodyB: mount
                    length: global.rodLength
                }

                onStepped: {
                    var v = ball.linearVelocity
                    var d = airResistanceSlider.value
                    var force = Qt.point(-v.x * d,
                                         -v.y * d)
                    ball.applyForce(force, Qt.point(0,0))
                }
            }
        }
        Column {
            id: buttonRow
            anchors {
                horizontalCenter: parent.horizontalCenter
                bottom: parent.bottom
            }
            spacing: experimentRoot.width * 0.01
            LabeledSlider {
                id: airResistanceSlider
                anchors {
                    horizontalCenter: parent.horizontalCenter
                }
                width: global.width * 0.5
                label: "Air resistance coefficient:"
                comment: value.toFixed(1) + " kg/m"
                slider.minimumValue: 0.1
                slider.maximumValue: 1.0
                slider.value: 0
                font.family: "Linux Libertine"
                font.pixelSize: experimentRoot.width * 0.015
            }
            LabeledSlider {
                id: initialVelocitySlider
                anchors {
                    horizontalCenter: parent.horizontalCenter
                }
                width: global.width * 0.5
                label: "Initial velocity:"
                comment: (value / 32).toFixed(1) + " m/s"
                slider.minimumValue: 50
                slider.maximumValue: 1000
                slider.value: 200
                font.family: "Linux Libertine"
                font.pixelSize: experimentRoot.width * 0.015
            }
            Button {
                id: resetButton
                text: "Launch again"
                anchors {
                    horizontalCenter: parent.horizontalCenter
                }
                onClicked: {
                    global.reset()
                }
            }
        }
    }
}
