import QtQuick 2.0
import Box2D 1.1

Body {

//    property alias image: image.source

    bodyType: Body.Static
    fixtures: Box {
        anchors.fill: parent
        friction: 1.0
    }

    Rectangle {
        anchors.fill: parent
        color: "brown"
    }
}
