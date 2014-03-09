import QtQuick 2.0

Rectangle {
    property alias lefts: lefty.children
    property alias rights: righty.children
    property bool active: false
    property bool running: false
    width: 100
    height: 62
    Row {
        anchors.fill: parent
        anchors.margins: parent.width * 0.05
        Item {
            id: lefty
            width: parent.width / 2
            height: parent.height
        }
        Item {
            id: righty
            width: parent.width / 2
            height: parent.height
        }
    }
}
