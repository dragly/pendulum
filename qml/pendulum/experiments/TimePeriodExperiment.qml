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
            text: "Period of a pendulum"
            width: parent.width
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            font.family: "Roboto"
            font.pixelSize: experimentRoot.width * 0.04
        }

        Text {
            text: "<p>The relation between a pendulum's period, T, and its length, L, is for small angles approximated by "
            width: parent.width
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            font.family: "Linux Libertine"
            font.pixelSize: experimentRoot.width * 0.018
        }
        Image {
            source: "pendulum-period.png"
            fillMode: Image.PreserveAspectFit
            sourceSize.width: width * 1.4
            width: parent.width / 5
//            height: width
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Text {
            text: "<p>where g is the acceleration of gravity. " +
                  "In this experiment, g = " + world.gravity.y.toFixed(1) +
                  " m/s². This means that all other properties of the experiment, " +
                  "such as the initial velocity or the mass of the pendulum " +
                  "won't affect the period, as long as the angles " +
                  "are always small.</p><br>" +
                  "<p>The sliders allow you to set the length " +
                  "of the pendulum and the initial velocity of the ball " +
                  "before restarting the experiment " +
                  "by clicking the Go! button.</p><br>" +
                  "<p>See if you can make the period of the pendulum become " +
                  "approximately 3 seconds with a small angle.</p>"
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
                ball.y = mount.y + ropeLengthSlider.value
                ropeJoint.length = ropeLengthSlider.value
                ball.targetVelocity = Qt.point(initialVelocitySlider.value,0)
                ball.linearVelocity = ball.targetVelocity
                periodTimer.reset()
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

                Timer {
                    id: periodTimer
                    property int elapsed: 0
                    property int previousElapsed: 0
                    property double previousTime: 0

                    function lap() {
                        previousElapsed = elapsed
                        elapsed = 0
                        previousTimeText.blink()
                    }

                    function reset() {
                        previousElapsed = 0
                        elapsed = 0
                    }

                    running: experimentRoot.running
                    interval: 50
                    repeat: true
                    onTriggered: {
                        var currentTime = Date.now()
                        if(previousTime > 0) {
                            var diff = currentTime - previousTime
                            elapsed += diff
                        }
                        previousTime = currentTime
                    }
                }

                Text {
                    id: currentTimeText
                    anchors.top: parent.top
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Current period: " + (periodTimer.elapsed/1000).toFixed(1)
                    font.family: "Linux Libertine"
                    font.pixelSize: experimentRoot.width * 0.015
                }

                Text {
                    id: previousTimeText
                    anchors.top: currentTimeText.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Previous period: " + (periodTimer.previousElapsed/1000).toFixed(1)
                    font.family: "Linux Libertine"
                    font.pixelSize: experimentRoot.width * 0.015

                    function blink() {
                        previousTimeAnimation.restart()
                    }
                    ColorAnimation {
                        id: previousTimeAnimation
                        duration: 800
                        property: "color"
                        target: previousTimeText
                        from: "orange"
                        to: "black"
                        easing.type: Easing.OutQuad
                    }
                }

                Text {
                    id: wellDoneText
                    anchors.centerIn: parent
                    anchors.verticalCenterOffset: parent.width * 0.2
                    color: "green"
                    text: "Well done!"
                    font.family: "Linux Libertine"
                    font.pixelSize: experimentRoot.width * 0.03
                    visible: Math.abs(periodTimer.previousElapsed - 3000) < 300 ? true : false
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
                    onXChanged: {
                        if(y > mount.y) {
                            if(x > global.width / 2 && prevX <= global.width / 2) {
                                periodTimer.lap()
                                // Regain energy
                                linearVelocity = targetVelocity
                            } else if(x <= global.width / 2 && prevX > global.width / 2) {
                                // Regain energy
                                linearVelocity = Qt.point(-targetVelocity.x, 0)
                            }
                        }

                        prevX = x
                    }

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
                id: initialVelocitySlider
                anchors {
                    horizontalCenter: parent.horizontalCenter
                }
                width: global.width * 0.5
                label: "Initial velocity:"
                comment: (initialVelocitySlider.value / 32).toFixed(1) + " m/s"
                slider.minimumValue: 10
                slider.maximumValue: 300
                slider.value: 50
                font.family: "Linux Libertine"
                font.pixelSize: experimentRoot.width * 0.015
            }
            LabeledSlider {
                id: ropeLengthSlider
                anchors {
                    horizontalCenter: parent.horizontalCenter
                }
                width: global.width * 0.5
                label: "Rod length:"
                comment: (ropeLengthSlider.value / 32).toFixed(1) + " m"
                slider.minimumValue: 50
                slider.maximumValue: 200
                slider.value: 100
                font.family: "Linux Libertine"
                font.pixelSize: experimentRoot.width * 0.015
            }
            Button {
                id: resetButton
                text: "Go!"
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
