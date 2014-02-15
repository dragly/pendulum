#include <QtGui/QGuiApplication>
#include <QtQuick>
#include "qtquick2applicationviewer.h"
#include "latexrunner.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    qmlRegisterType<LatexRunner>("LatexPresentation", 1, 0, "LatexRunner");

    QtQuick2ApplicationViewer viewer;
    viewer.setMainQmlFile(QStringLiteral("qml/pendulum/main.qml"));
    viewer.showExpanded();

    return app.exec();
}
