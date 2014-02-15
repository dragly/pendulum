import QtQuick 2.0
import Box2D 1.0
import QtQuick.Controls 1.1
import "experiments"

Rectangle {
    width: 1280
    height: 720
    Project {
        title: "Pendulum."
        anchors.fill: parent
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
