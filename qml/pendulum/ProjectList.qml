import QtQuick 2.0

Rectangle {
    default property alias projects: projectList.children
    width: 100
    height: 62

    VisualItemModel {
        id: projectList
    }

    Rectangle {
        anchors.fill: bar
        color: "lightblue"
        opacity: 0.5
    }

    Row {
        id: bar
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }
        height: 200

        Repeater {
            model: projectList.count
            delegate: Item {
                property Item item: projectList.children[index]
                width: 300
                height: 100
                Text {
                    anchors.fill: parent
                    text: item.title
                }
            }
        }
    }
    Item {
        anchors {
            top: bar.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        Repeater {
            model: projectList
        }
    }
}
