import QtQuick 2.0
import QtGraphicalEffects 1.0

Rectangle {
    id: projectRoot
    default property alias experiments: experimentsRow.children
    property bool running: false
    property alias title: welcomeText.text
    property int currentExperimentIndex: 0
    width: 100
    height: 62

    Component.onCompleted: {
        resetRunning()
    }

    onRunningChanged: resetRunning()

//    function layoutChildren() {
//        for(var i in experimentsRow.children) {
//            var child = experimentsRow.children[i]
//            child.width = projectRoot.width
//            child.height = experimentsRow.height
//        }
//    }

    function resetRunning() {
        for(var i in experimentsRow.children) {
            var child = experimentsRow.children[i]
            if(projectRoot.running && currentExperimentIndex === parseInt(i)) {
                child.running = true
            } else {
                child.running = false
            }
        }
    }

    onCurrentExperimentIndexChanged: {
        if(currentExperimentIndex >= experimentsRow.children.length) {
            currentExperimentIndex = experimentsRow.children.length - 1
            endRectangleAnimation.restart()
        } else if(currentExperimentIndex < 0) {
            currentExperimentIndex = 0
            startRectangleAnimation.restart()
        }
        resetRunning()
    }

    state: "welcome"

    MouseArea {
        id: nextExperimentArea
        property bool dragStarted: false
        property point mouseStart
        anchors.fill: parent
        onPressed: {
            dragStarted = true
            mouseStart = Qt.point(mouse.x, mouse.y)
        }
        onPositionChanged: {
            if(dragStarted) {
                var diffX = mouse.x - mouseStart.x
                var diffY = mouse.y - mouseStart.y
                if(diffX < -projectRoot.width / 4) {
                    currentExperimentIndex += 1
                    dragStarted = false
                } else if(diffX > projectRoot.width / 4) {
                    currentExperimentIndex -= 1
                    dragStarted = false
                }
            }
        }

        onReleased: {
            dragStarted = false
        }
    }

    Row {
        id: experimentsRow
        x: - projectRoot.width * currentExperimentIndex
        width: parent.width * children.length
        anchors.top: parent.top
        height: parent.height
        Behavior on x {
            NumberAnimation {
                duration: 500
                easing.overshoot: 0.5
                easing.type: Easing.InOutQuad
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
        text: "Welcome."
        color: Qt.rgba(0.3, 0.3, 0.3, 1.0)
        font.family: "Roboto"
        font.weight: Font.Light
        font.pixelSize: parent.width * 0.05
    }

    MouseArea {
        id: skipArea
        anchors.fill: parent
        onClicked: {
            transition.enabled = false
            projectRoot.state = "tmp"
            projectRoot.state = "started"
            projectRoot.running = true
            skipArea.enabled = false
        }
    }

    RadialGradient {
        id: startRectangle

        anchors {
            left: parent.left
            top: parent.top
            bottom: parent.bottom
        }
        horizontalOffset: -width * 0.8

        gradient: Gradient {
            GradientStop {
                position: 0
                color: "#98F8F8"
            }
            GradientStop {
                position: 1
                color: "transparent"
            }
        }

        width: parent.width / 15
        opacity: 0
        SequentialAnimation {
            id: startRectangleAnimation
            NumberAnimation {
                target: startRectangle
                property: "opacity"
                from: 0
                to: 1
                duration: 200
            }
            NumberAnimation {
                target: startRectangle
                property: "opacity"
                from: 1
                to: 0
                duration: 600
            }
        }
    }

    RadialGradient {
        id: endRectangle

        anchors {
            right: parent.right
            top: parent.top
            bottom: parent.bottom
        }
        horizontalOffset: width * 0.8

        gradient: Gradient {
            GradientStop {
                position: 0
                color: "#98F8F8"
            }
            GradientStop {
                position: 1
                color: "transparent"
            }
        }

        width: parent.width / 15
        opacity: 0
        SequentialAnimation {
            id: endRectangleAnimation
            NumberAnimation {
                target: endRectangle
                property: "opacity"
                from: 0
                to: 1
                duration: 200
            }
            NumberAnimation {
                target: endRectangle
                property: "opacity"
                from: 1
                to: 0
                duration: 600
            }
        }
    }

    states: [
        State {
            name: "welcome"
            AnchorChanges {
                target: welcomeText
                anchors.horizontalCenter: projectRoot.horizontalCenter
                anchors.verticalCenter: projectRoot.verticalCenter
            }
            PropertyChanges {
                target: welcomeText
                opacity: 0
            }
            PropertyChanges {
                target: experimentsRow
                anchors.topMargin: projectRoot.height
            }
        },
        State {
            name: "started"
            AnchorChanges {
                target: welcomeText
                anchors.bottom: projectRoot.top
            }
            PropertyChanges {
                target: welcomeText
                opacity: 1
            }
            PropertyChanges {
                target: whiteOverlay
                opacity: 0
            }
            PropertyChanges {
                target: experimentsRow
                anchors.topMargin: 0
            }
        }
    ]

    transitions: [
        Transition {
            id: transition
            from: "welcome"
            to: "started"
            SequentialAnimation {
                NumberAnimation {
                    target: welcomeText
                    property: "opacity"
                    duration: 2000
                    easing.type: Easing.InOutQuad
                }
                ParallelAnimation {
                    AnchorAnimation {
                        duration: 2000
                        easing.type: Easing.InOutQuad
                    }
                    NumberAnimation {
                        target: experimentsRow
                        properties: "anchors.topMargin"
                        duration: 2000
                        easing.type: Easing.InOutQuad
                    }
                    NumberAnimation {
                        target: whiteOverlay
                        property: "opacity"
                        duration: 2000
                        easing.type: Easing.InOutQuad
                    }
                }
            }
            onRunningChanged: {
                if(!running) {
                    skipArea.enabled = false
                    projectRoot.running = true
                }
            }
        }
    ]
}
