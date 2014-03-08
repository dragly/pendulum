import QtQuick 2.0

Rectangle {
    property alias model: repeater.model
    property int selectedIndex: 0
    property Project selectedProject: model.children[selectedIndex] ? model.children[selectedIndex] : null
    width: 100
    height: 62
    color: "lightblue"

    Component.onCompleted: {
        refreshSelection()
    }

    onSelectedIndexChanged: {
        refreshSelection()
    }

    function refreshSelection() {
        for(var i in model.children) {
            if(parseInt(i) === selectedIndex) {
                model.children[i].visible = true
            } else {
                model.children[i].visible = false
            }
        }
    }

    Repeater {
        id: repeater
    }
}
