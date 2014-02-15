import QtQuick 2.0
import LatexPresentation 1.0

Image {
    property string text: "No text specified"
    property string color: parent.textColor != undefined ? parent.textColor : "black"
    property alias forceCompile: latexRunner.forceCompile
    property bool centered: true
    property alias dpi: latexRunner.dpi

    height: width * sourceSize.height / sourceSize.width
    smooth: true

    Component.onCompleted: {
        var latexText = text
        console.log("Running")
        var imageFileName = latexRunner.createFormula(latexText, color, centered)
        source = imageFileName
    }

    LatexRunner {
        id: latexRunner
        dpi: 150
        forceCompile: false
    }
}
