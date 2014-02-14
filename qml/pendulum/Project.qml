import QtQuick 2.0

Rectangle {
    id: projectRoot
    default property alias experiments: experimentsColumn.children
    property alias title: welcomeText.text
    property int currentExperiment: 0
    width: 100
    height: 62

    onWidthChanged: layoutChildren()
    onHeightChanged: layoutChildren()

    function layoutChildren() {
        for(var i in experimentsColumn.children) {
            var child = experimentsColumn.children[i]
            child.width = projectRoot.width
            child.height = projectRoot.height
        }
    }

    onCurrentExperimentChanged: {
        if(currentExperiment >= experimentsColumn.children.length) {
            currentExperiment = 0
        } else if(currentExperiment < 0) {
            currentExperiment = experimentsColumn.children.length - 1
        }
    }

    states: [
        State {
            name: "welcome"
            PropertyChanges {
                target: welcomeAnimation
                running: true
            }
        },
        State {
            name: "started"
            PropertyChanges {
                target: welcomeText
                visible: false
            }
            PropertyChanges {
                target: whiteOverlay
                visible: false
            }
            PropertyChanges {
                target: skipArea
                enabled: false
            }
        }
    ]

    Component.onCompleted: {
        state = "welcome"
    }

    SequentialAnimation {
        id: welcomeAnimation
        NumberAnimation { target: welcomeText; property: "opacity"; duration: 3000; easing.type: Easing.InOutQuad; from: 0; to: 1; }
        ParallelAnimation {
            NumberAnimation { target: welcomeText; property: "scale"; duration: 2000; easing.type: Easing.InOutQuad; from: 1; to: 0.8 }
            NumberAnimation { target: welcomeText; property: "opacity"; duration: 2000; easing.type: Easing.InOutQuad; from: 1; to: 0; }
            NumberAnimation { target: whiteOverlay; property: "opacity"; duration: 2000; easing.type: Easing.InOutQuad; from: 1; to: 0; }
        }
        onStopped: {
            state = "started"
        }
    }

    transitions: [
        Transition {
            NumberAnimation { property: "opacity"; duration: 2000; easing.type: Easing.InOutQuad }
        }
    ]

    Row {
        id: experimentsColumn
        x: - projectRoot.width * currentExperiment
        y: 0
        width: parent.width * children.length
        height: parent.height
        onChildrenChanged: {
            layoutChildren()
        }
        Behavior on x {
            NumberAnimation {
                duration: 400
                easing.type: Easing.InOutQuad
            }
        }
    }

    Rectangle {
        id: nextButton
        anchors {
            right: parent.right
            bottom: parent.bottom
        }
        width: parent.width * 0.05
        height: width
        color: "grey"

        MouseArea {
            anchors.fill: parent
            onClicked: {
                currentExperiment += 1
            }
        }
    }

    Rectangle {
        id: previousButton
        anchors {
            left: parent.left
            bottom: parent.bottom
        }
        width: parent.width * 0.05
        height: width
        color: "grey"

        MouseArea {
            anchors.fill: parent
            onClicked: {
                currentExperiment -= 1
            }
        }
    }

    Rectangle {
        id: whiteOverlay
        color: "white"
        anchors.fill: parent
        opacity: 1
    }

    Text {
        id: welcomeText
        anchors.centerIn: parent
        text: "Welcome."
        color: Qt.rgba(0.3, 0.3, 0.3, 1.0)
        font.family: "Linux Libertine"
        font.weight: Font.Light
        font.pixelSize: parent.width * 0.05
    }

    MouseArea {
        id: skipArea
        anchors.fill: parent
        onClicked: {
            projectRoot.state = "started"
        }
    }
}
