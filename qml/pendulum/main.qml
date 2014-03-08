import QtQuick 2.0
import Box2D 1.0
import QtQuick.Controls 1.1
import "experiments"

Rectangle {
    id: rectRoot
    width: 1280
    height: 720

    FontLoader {
        source: "qrc:/fonts/roboto/Roboto-Light.ttf"
    }

    VisualItemModel {
        id: projectModel
        Project {
            anchors.fill: parent
            title: "Friction"
        }
        Project {
            anchors.fill: parent
            title: "Pendulum"
            IntroductionExperiment {

            }
            TimePeriodExperiment {

            }
            AirResistanceExperiment {

            }
            DoublePendulumExperiment {

            }
        }
    }

    Flickable {
        anchors.fill: parent
        contentHeight: parent.height
        contentWidth: parent.width
        flickableDirection: Flickable.VerticalFlick

        Text {
            id: contentsText
            anchors {
                top: parent.top
                left: parent.left
                topMargin: parent.height * 0.1
                leftMargin: parent.width * 0.2
            }
            text: "Contents"
            font.pixelSize: rectRoot.height * 0.12
            font.family: "Roboto"
            font.weight: Font.Light
        }

        Column {
            id: projectList
            anchors {
                top: contentsText.bottom
                left: contentsText.left
                right: parent.right
                rightMargin: parent.width * 0.1
                topMargin: parent.height * 0.07
            }
            height: 1000
            spacing: rectRoot.height * 0.02
            Repeater {
                model: projectModel.count
                delegate: Rectangle {
                    property Item item: projectModel.children[index]
                    width: projectList.width * 0.8
                    height: titleText.height
                    Text {
                        id: titleText
                        text: item.title
                        font.pixelSize: rectRoot.height * 0.05
                        font.family: "Roboto"
                        font.weight: Font.Light
                    }
                    Text {
                        id: arrowText
                        anchors {
                            baseline: titleText.baseline
                            right: parent.right
                        }
                        text: "〉"
                        font: titleText.font
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            projectView.selectedIndex = index
                            rectRoot.state = "project"
                        }
                    }
                }
            }
        }
    }
    SingleItem {
        id: projectView
        visible: false
        model: projectModel
        anchors.fill: parent
        height: 400
        Item {
            anchors.left: parent.left
            anchors.top: parent.top
            width: parent.width * 0.05
            height: parent.width * 0.05
            Text {
                text: "〈"
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                color: "grey"
                font.pixelSize: parent.height * 0.5
                font.family: "Roboto"
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    rectRoot.state = ""
                }
            }
        }
    }

    states: [
        State {
            name: "project"
            PropertyChanges {
                target: projectView
                visible: true
            }
            PropertyChanges {
                target: projectList
                visible: false
            }
            PropertyChanges {
                target: projectView.selectedProject
                state: "started"
            }
        }
    ]
}
