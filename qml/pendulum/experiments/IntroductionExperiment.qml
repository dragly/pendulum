import QtQuick 2.0
import QtQuick.Controls 1.1
import Box2D 1.1
import ".."
Experiment {
    lefts: Column {
        anchors.fill: parent
        anchors.margins: parent.width * 0.05
        spacing: parent.width * 0.05
        Text {
            text: "The pendulum to the right consists of a ball, " +
                  "a massless rod and an attachement point. " +
                  "The length of the rope and the acceleration of gravity determines the frequency " +
                  "of the pendulum. You may drag the ball to interact with it."
            width: parent.width
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            font.family: "Linux Libertine"
            font.pixelSize: parent.width * 0.04
        }
        Button {
            text: "Reset"
            onClicked: {
                global.reset()
            }
        }
    }
    rights: global

    Rectangle {
        id: global
        anchors.fill: parent
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
            ball.x = mount.x + ropeJoint.length
            ball.y = mount.y
            ball.linearVelocity = Qt.point(0,0)
        }

        World {
            id: world
            anchors.fill: parent

            Line {
                startPoint: Qt.point(ball.x, ball.y)
                endPoint: Qt.point(mount.x, mount.y)
                color: "grey"
            }

            Line {
                opacity: global.joint !== null
                startPoint: global.mousePosition
                endPoint: global.body ? Qt.point(global.body.x, global.body.y) : Qt.point(0,0)
                color: "#F898C8"
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
                width: parent.width * 0.05
                height: width
                bodyType: Body.Dynamic
                fixtures: Circle {
                    anchors.fill: parent
                    density: 500
                    restitution: 0.5
                    friction: 0.0
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
                length: global.width * 0.3
            }

            Body {
                id: anchor
                x:300
                y: 300
                width: 10
                height: 10
            }
        }
    }
}
