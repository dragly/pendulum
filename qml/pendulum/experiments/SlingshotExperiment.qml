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
                for(var i = 0; i < blockRepeater.model; i++) {
                    if(blockRepeater.itemAt(i)) {
                        blockRepeater.itemAt(i).reset()
                    }
                }
            }

            MouseArea {
                anchors.fill: parent
                onPressed: {
                    ball.reset()
                }
            }

            World {
                id: world
                anchors.fill: parent

                running: experimentRoot.running

                Body {
                    id: ball
                    property bool hasCollidedWithCart: false
                    property bool hasCollidedWithOther: false
                    property point startPosition: Qt.point(world.width * 0.1, ground.y - world.height * 0.2)
                    property point mousePos
                    property real springConstant: 10
                    fixedRotation: false

                    onStartPositionChanged: global.reset()

                    function reset() {
                        ballMouseArea.enabled = true
                        linearVelocity.x = 0
                        linearVelocity.y = 0
                        angularVelocity = 0
                        rotation = 0
                        x = startPosition.x
                        y = startPosition.y
                        hasCollidedWithCart = false
                        hasCollidedWithOther = false
                        gravityScale = 0
                    }

                    width: parent.width * 0.05
                    height: width
                    bodyType: Body.Dynamic
                    fixtures: Circle {
                        id: ballFixture
                        radius: parent.width / 2
                        anchors.centerIn: parent
                        density: 10.0
                        restitution: 0.6
                        friction: 1.0
                    }
                    sleepingAllowed: false
                    //                    linearDamping: airResistanceSlider.value

                    Rectangle {
                        id: ballRect
                        anchors.fill: parent
                        radius: width / 2
                        color: "#98F8F8"
                        border.color: "#90C0F8"
                        border.width: 2
                        MouseArea {
                            id: ballMouseArea
                            anchors.fill: parent
                            drag.target: ball
                            onPressed: {
                                slingshotLine.visible = true
                            }

                            onReleased: {
                                ballMouseArea.enabled = false
                                ball.gravityScale = 1
                                ball.linearVelocity.x = ball.springConstant * (ball.startPosition.x - ball.x)
                                ball.linearVelocity.y = ball.springConstant * (ball.startPosition.y - ball.y)
                                slingshotLine.visible = false
                            }
                        }
                        Rectangle {
                            x: parent.width * 0.5
                            y: parent.height * 0.1
                            width: parent.width * 0.1
                            height: width
                            radius: width / 2
                            color: "#90C0F8"
                        }
                    }
                }

                Repeater {
                    id: blockRepeater
                    property int total: 25
                    property int columns: 5
                    model: total
                    delegate: Body {
                        function reset() {
                            x = world.width * 0.6 + width * parseInt(index % blockRepeater.columns)
                            y = ground.y - height * (1 + parseInt(index / blockRepeater.columns))
                        }
                        width: world.width > 0 ? world.width * 0.04 : 5
                        height: world.width > 0 ? world.width * 0.04 : 5
                        bodyType: Body.Dynamic
                        fixtures: Box {
                            anchors.fill: parent
                            density: 2
                            friction: 1.0
                            restitution: 0.4
                        }
                        Rectangle {
                            anchors.fill: parent
                            color: "#FEABCD"
                            border.color: "#FEFECD"
                            border.width: 2
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
                        friction: 1.0
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
