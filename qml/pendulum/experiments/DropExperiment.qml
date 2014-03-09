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

    lefts: Column {
        anchors.fill: parent
        spacing: parent.width * 0.01
        Text {
            text: "Dropping a ball onto a sliding box"
            width: parent.width
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            font.family: "Roboto"
            font.pixelSize: experimentRoot.width * 0.04
        }

        Text {
            text: "<p>The box to the right is sliding on a frictionless " +
                  "surface with a starting velocity of v = " +
                  (cart.startVelocity / 32).toFixed(1) + " m/s. " +
                  "Set the timer so that the ball falls onto " +
                  "the cart as it passes by.</p>" +
                  "<p>The constant of gravity is g = 10.0 m/s².</p>"
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
                bottomMargin: experimentRoot.height * 0.05
            }

            property bool dragged: false
            property point mousePosition: Qt.point(0,0)
            property Body body: null
            property bool running: false

            function reset() {
                ball.reset()
                cart.reset()
                currentTimeText.reset()
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
                property double elapsed: 0
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Time: " + (elapsed).toFixed(1)
                font.family: "Linux Libertine"
                font.pixelSize: experimentRoot.width * 0.015

                function reset() {
                    elapsed = 0
                }

//                Timer {
//                    id: currentTimeTimer
//                    property int elapsed: 0
//                    property int previousElapsed: 0
//                    property double previousTime: 0

//                    function reset() {
//                        previousElapsed = 0
//                        elapsed = 0
//                    }

//                    running: world.running
//                    interval: 50
//                    repeat: true
//                    onTriggered: {
//                        var currentTime = Date.now()
//                        if(previousTime > 0) {
//                            var diff = currentTime - previousTime
//                            elapsed += diff
//                        }
//                        previousTime = currentTime
//                    }
//                }
            }

            World {
                id: world
                anchors.fill: parent

                running: experimentRoot.running && global.running

                onStepped: {
                    currentTimeText.elapsed += world.timeStep
                    if(currentTimeText.elapsed > timerSlider.value) {
                        ball.gravityScale = 1
                    }
                }

                Body {
                    id: ball
                    property bool hasCollidedWithCart: false
                    property bool hasCollidedWithOther: false
                    property point startPosition: Qt.point(world.width * 0.8, ground.y - world.width * 0.5)

                    onStartPositionChanged: global.reset()

                    function reset() {
                        linearVelocity.x = 0
                        linearVelocity.y = 0
                        angularVelocity = 0
                        rotation = 0
                        x = startPosition.x
                        y = startPosition.y
                        gravityScale = 0
                        hasCollidedWithCart = false
                        hasCollidedWithOther = false
                    }

                    width: parent.width * 0.05
                    height: width
                    bodyType: Body.Dynamic
                    fixtures: Circle {
                        onBeginContact: {
                            if(!ball.hasCollidedWithOther && !ball.hasCollidedWithCart) {
                                if(other === cartFixture) {
                                    ball.hasCollidedWithCart = true
                                    statusText.text = "Success!"
                                    statusText.color = "green"
                                } else {
                                    ball.hasCollidedWithOther = true
                                    statusText.text = "Try again..."
                                    statusText.color = "darkred"
                                }
                            }
                        }
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
                            propagateComposedEvents: true
                            onPressed: {
                                global.body = parent.parent
                                mouse.accepted = false
                            }
                        }
                    }
                }

                Body {
                    id: cart
                    property point startPosition: Qt.point(world.width * 0.1, world.height - ground.height - cart.height)
                    property real startVelocity: world.width * 0.1

                    onStartPositionChanged: global.reset()

                    function reset() {
                        linearVelocity.x = startVelocity
                        linearVelocity.y = 0
                        angularVelocity = 0
                        rotation = 0
                        x = startPosition.x
                        y = startPosition.y
                    }

                    width: parent.width * 0.15 + 5
                    height: width * 0.7 + 5
                    bodyType: Body.Dynamic
                    fixtures: Box {
                        id: cartFixture
                        anchors.fill: parent
                        density: 100.0
                        restitution: 0.6
                        friction: 0.0
                    }
                    sleepingAllowed: false
                    //                    linearDamping: airResistanceSlider.value

                    Rectangle {
                        id: cartRect
                        anchors.fill: parent
                        color: "#98F8F8"
                        border.color: "#90C0F8"
                        border.width: 2
                    }
                }

                Body {
                    id: ground
                    width: parent.width + 5
                    height: parent.width * 0.08 + 5
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

                Ruler {
                    id: cartDistanceRuler
                    x: cart.startPosition.x + cart.width / 2
                    width: (ball.startPosition.x + ball.width / 2) - (cart.startPosition.x  + cart.width / 2)
                    height: ground.height * 0.7
                    anchors.verticalCenter: ground.verticalCenter
                }

                Ruler {
                    x: ball.startPosition.x + ball.width + height
                    y: ball.startPosition.y + ball.width / 2 - linesHeight
                    width: (ground.y - ball.startPosition.y - ball.width - cart.height - 4)
                    height: cartDistanceRuler.height
                    angle: 90
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
                id: timerSlider
                anchors {
                    horizontalCenter: parent.horizontalCenter
                }
                width: global.width * 0.5
                label: "Drop delay:"
                comment: (value).toFixed(1) + " s"
                slider.minimumValue: 0.1
                slider.maximumValue: 10.0
                slider.value: 1.0
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
                    global.running = true
                }
            }
        }
    }
}
