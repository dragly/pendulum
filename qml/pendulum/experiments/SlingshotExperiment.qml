import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1
import Box2D 1.1
import ".."
import "../controls"
import "../equipment"

Experiment {
    id: experimentRoot
    Component.onCompleted: {
        global.reset()
    }

    Item {
        anchors.fill: parent
        Rectangle {
            id: global
            anchors.fill: parent

            property bool dragged: false
            property point mousePosition: Qt.point(0,0)
            property Body body: null

            function reset() {
                ball.reset()
                currentTimeTimer.reset()
                statusText.text = ""
            }

            Text {
                id: statusText
                anchors.centerIn: parent
                text: ""
                font.family: "Linux Libertine"
                font.pixelSize: global.width * 0.1
            }

            Text {
                id: currentTimeText
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Time: " + (currentTimeTimer.elapsed/1000).toFixed(1)
                font.family: "Linux Libertine"
                font.pixelSize: experimentRoot.width * 0.015

                Timer {
                    id: currentTimeTimer
                    property int elapsed: 0
                    property int previousElapsed: 0
                    property double previousTime: 0

                    function reset() {
                        previousElapsed = 0
                        elapsed = 0
                    }

                    running: world.running
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
            }

            World {
                id: world
                anchors.fill: parent

                running: false

                Body {
                    id: ball
                    property bool hasCollidedWithCart: false
                    property bool hasCollidedWithOther: false
                    property point startPosition: Qt.point(world.width * 0.1, ground.y - world.height * 0.2)
                    property point mousePos
                    property real springConstant: 10

                    onStartPositionChanged: global.reset()

                    function reset() {
                        linearVelocity.x = 0
                        linearVelocity.y = 0
                        angularVelocity = 0
                        rotation = 0
                        x = startPosition.x
                        y = startPosition.y
                        hasCollidedWithCart = false
                        hasCollidedWithOther = false
                    }

                    width: parent.width * 0.05
                    height: width
                    bodyType: Body.Dynamic
                    fixtures: Circle {
                        radius: parent.width / 2
                        anchors.centerIn: parent
                        density: 1.0
                        restitution: 0.6
                        friction: 0.0
                    }
                    sleepingAllowed: false
                    //                    linearDamping: airResistanceSlider.value

                    Rectangle {
                        anchors.fill: parent
                        radius: width / 2
                        color: "#98F8F8"
                        border.color: "#90C0F8"
                        border.width: 2
                        MouseArea {
                            anchors.fill: parent
                            drag.target: ball
                            onPressed: {
                                slingshotLine.visible = true
                            }

                            onReleased: {
                                drag.target = null
                                ball.linearVelocity.x = ball.springConstant * (ball.startPosition.x - ball.x)
                                ball.linearVelocity.y = ball.springConstant * (ball.startPosition.y - ball.y)
                                world.running = true
                                slingshotLine.visible = false
                            }
                        }
                    }
                }

                Line {
                    id: slingshotLine
                    visible: false
                    startPoint: Qt.point(ball.startPosition.x + ball.width / 2, ball.startPosition.y + ball.width / 2)
                    endPoint: Qt.point(ball.x + ball.width / 2, ball.y + ball.width / 2)
                }

                Body {
                    id: ground
                    width: parent.width > 0 ? parent.width : 5
                    height: parent.width > 0 ? width * 0.08 : 5
                    anchors.bottom: parent.bottom
                    bodyType: Body.Static
                    fixtures: Box {
                        anchors.fill: parent
                        density: 1
                        friction: 0.0
                    }
                    sleepingAllowed: false

                    Rectangle {
                        anchors.fill: parent
                        color: "#E8E8E8"
                        border.color: "#B8B8B8"
                        border.width: 2
                    }
                }
            }
        }
    }
}
