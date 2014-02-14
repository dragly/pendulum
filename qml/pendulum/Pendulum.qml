import QtQuick 2.0
import Box2D 1.1

Rectangle {
    width: 800
    height: 600
    id: global
    property alias ropeLength: ropeJoint.length
    property bool dragged: false
    property point mousePosition: Qt.point(0,0)
    property MouseJoint joint: null
    property Body body: null

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
            mousePosition = Qt.point(mouse.x, mouse.y)
            global.createJoint(mouse.x,mouse.y);
        }
        onReleased: {
            mousePosition = Qt.point(mouse.x, mouse.y)
            global.destroyJoint();
        }

        onPositionChanged: {
            mousePosition = Qt.point(mouse.x, mouse.y)
            if(global.dragged == true)
            {
                global.joint.target = Qt.point(mouse.x,mouse.y);
            }
        }
        anchors.fill: parent
    }

    function reset() {
        ball.x = 100
        ball.y = 250
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

    World {
        id: world
        anchors.fill: parent

        Body {
            id: mount
            x: 150
            y: 10
            width: 40
            height: width
            bodyType: Body.Static
            fixtures: Circle {
                anchors.fill: parent
                density: 0.5
                restitution: 0.5
                friction: 0.5
            }

            Rectangle {
                width: parent.width
                height: parent.height
                radius: width / 2
                color: "darkgrey"
                x: - radius
                y: - radius
            }
        }

        Body {
            id: ball
            x: 250
            y: 10
            width: 40
            height: width
            bodyType: Body.Dynamic
            fixtures: Circle {
                anchors.fill: parent
                density: 0.5
                restitution: 0.5
                friction: 0.5
            }

            Rectangle {
                width: parent.width
                height: parent.height
                radius: width / 2
                color: "darkgrey"
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

        Line {
            startPoint: Qt.point(ball.x, ball.y)
            endPoint: Qt.point(mount.x, mount.y)
        }

        Line {
            opacity: global.joint !== null
            startPoint: global.mousePosition
            endPoint: global.body ? Qt.point(global.body.x, global.body.y) : Qt.point(0,0)
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
