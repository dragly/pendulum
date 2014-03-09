#include <QtGui/QGuiApplication>
#include <QtQuick>
#include "qtquick2applicationviewer.h"
#include "latexrunner.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    qmlRegisterType<LatexRunner>("LatexPresentation", 1, 0, "LatexRunner");

    QtQuick2ApplicationViewer viewer;
//    viewer.setMainQmlFile(QStringLiteral("qrc:/qml/pendulum/main.qml"));
#ifdef Q_OS_ANDROID
    viewer.setSource(QUrl("qrc:/qml/pendulum/main.qml"));
#else
    viewer.setSource(QUrl("qml/pendulum/main.qml"));
#endif
    viewer.showExpanded();

    return app.exec();
}
