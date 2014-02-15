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
            text: "Double pendulum"
            width: parent.width
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            font.family: "Linux Libertine"
            font.pixelSize: experimentRoot.width * 0.04
        }

        Text {
            text: "<p>You may " +
                  "play with a double pendulum and their lengths " +
                  "in this experiment.</p>"
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

            property alias ropeLength: ropeJoint.length
            property bool dragged: false
            property point mousePosition: Qt.point(0,0)
            property MouseJoint joint: null
            property Body body: null

            Component.onCompleted: {
                reset()
            }

            Component {
                id: jointComponent
                MouseJoint {
                    world: world
                    bodyA: anchor
                    dampingRatio: 0.8
                    target: Qt.point(350.0,200.0);
                    maxForce: 10000
                }
            }
            MouseArea {
                id: mouseArea
                onPressed: {
                    global.mousePosition = Qt.point(mouse.x, mouse.y)
                    global.createJoint(mouse.x,mouse.y);
                }
                onReleased: {
                    global.mousePosition = Qt.point(mouse.x, mouse.y)
                    global.destroyJoint();
                }

                onPositionChanged: {
                    global.mousePosition = Qt.point(mouse.x, mouse.y)
                    if(global.dragged == true)
                    {
                        global.joint.target = Qt.point(mouse.x,mouse.y);
                    }
                }
                anchors.fill: parent
            }

            function createJoint(x,y) {
                if(global.joint != null) destroyJoint();
                var body = global.body;
                if(body == null) return;
                var mouseJoint = jointComponent.createObject(world);
                mouseJoint.target = Qt.point(x,y);
                mouseJoint.bodyB = body;
                mouseJoint.world = world;
                mouseJoint.maxForce = body.getMass() * 3000.0;
                global.dragged = true;
                global.joint = mouseJoint;
            }

            function destroyJoint() {
                if(global.dragged == false) return;
                if(global.joint != null) {
                    global.dragged = false;
                    global.joint.destroy();
                    global.joint = null;
                    global.body = null;
                }
            }

            function reset() {
                ball.x = mount.x
                ball.y = mount.y + 100
                ball2.x = ball.x
                ball2.y = ball.y + 100
                ropeJoint.length = Qt.binding(function() {return rodLength1Slider.value})
                ropeJoint2.length = Qt.binding(function() {return rodLength2Slider.value})
                ball.linearVelocity = Qt.point(50,0)
                ball2.linearVelocity = Qt.point(-50,0)
            }

            World {
                id: world
                anchors.fill: parent
                running: experimentRoot.running

                Body {
                    id: anchor
                    x:300
                    y: 300
                    width: 10
                    height: 10
                }

                Line {
                    startPoint: Qt.point(ball.x, ball.y)
                    endPoint: Qt.point(mount.x, mount.y)
                    color: "grey"
                }

                Line {
                    startPoint: Qt.point(ball2.x, ball2.y)
                    endPoint: Qt.point(ball.x, ball.y)
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
                    width: parent.width * 0.07
                    height: width
                    bodyType: Body.Dynamic
                    fixtures: Circle {
                        anchors.fill: parent
                        density: 500
                        restitution: 0.5
                        friction: 0.0
                    }
                    sleepingAllowed: false
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
                    id: ball2
                    width: parent.width * 0.07
                    height: width
                    bodyType: Body.Dynamic
                    fixtures: Circle {
                        anchors.fill: parent
                        density: 500
                        restitution: 0.5
                        friction: 0.0
                    }
                    sleepingAllowed: false
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

                DistanceJoint {
                    id: ropeJoint
                    world: world
                    bodyA: ball
                    bodyB: mount
                }

                DistanceJoint {
                    id: ropeJoint2
                    world: world
                    bodyA: ball2
                    bodyB: ball
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
                id: rodLength1Slider
                anchors {
                    horizontalCenter: parent.horizontalCenter
                }
                width: global.width * 0.5
                label: "Rod length 1:"
                comment: (value / 32).toFixed(1) + " m"
                slider.minimumValue: parent.width * 0.2
                slider.maximumValue: parent.width * 0.4
                slider.value: 1000
                font.family: "Linux Libertine"
                font.pixelSize: experimentRoot.width * 0.015
            }
            LabeledSlider {
                id: rodLength2Slider
                anchors {
                    horizontalCenter: parent.horizontalCenter
                }
                width: global.width * 0.5
                label: "Rod length 2:"
                comment: (value / 32).toFixed(1) + " m"
                slider.minimumValue: parent.width * 0.2
                slider.maximumValue: parent.width * 0.4
                slider.value: 1000
                font.family: "Linux Libertine"
                font.pixelSize: experimentRoot.width * 0.015
            }
            Button {
                id: resetButton
                text: "Reset"
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
