import QtQuick 2.0
import QtGraphicalEffects 1.0

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
            child.height = experimentsColumn.height
        }
    }

    function resetRunning() {
        for(var i in experimentsColumn.children) {
            var child = experimentsColumn.children[i]
            if(currentExperiment == i) {
                child.running = true
            } else {
                child.running = false
            }
        }
    }

    onCurrentExperimentChanged: {
        if(currentExperiment >= experimentsColumn.children.length) {
            currentExperiment = experimentsColumn.children.length - 1
            endRectangleAnimation.restart()
        } else if(currentExperiment < 0) {
            currentExperiment = 0
            startRectangleAnimation.restart()
        }
        resetRunning()
    }

    state: "welcome"
    Component.onCompleted: {
        state = "started"
        resetRunning()
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
                target: experimentsColumn
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
                target: experimentsColumn
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
                        target: experimentsColumn
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
                }
            }
        }
    ]

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
                    currentExperiment += 1
                    dragStarted = false
                } else if(diffX > projectRoot.width / 4) {
                    currentExperiment -= 1
                    dragStarted = false
                }
            }
        }

        onReleased: {
            dragStarted = false
        }
    }

    Row {
        id: experimentsColumn
        x: - projectRoot.width * currentExperiment
        width: parent.width * children.length
        anchors.top: parent.top
        height: parent.height
        onHeightChanged: {
            layoutChildren()
        }
        onChildrenChanged: {
            layoutChildren()
        }
        Behavior on x {
            NumberAnimation {
                duration: 500
                easing.overshoot: 0.5
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
//        color: "grey"

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
//        color: "grey"

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
//        anchors.centerIn: parent
//        x: parent.width / 2 - width / 2
//        y: parent.height / 2 - height / 2
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
            console.log("Skip")
            transition.enabled = false
            projectRoot.state = "tmp"
            projectRoot.state = "started"
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

        width: parent.width / 20
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

        width: parent.width / 20
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
}
