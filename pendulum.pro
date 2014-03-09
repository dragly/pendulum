# Add more folders to ship with the application, here
folder_01.source = qml/pendulum
folder_01.target = qml
folder_02.source = fonts/roboto
folder_02.target = fonts
DEPLOYMENTFOLDERS = folder_01 folder_02

# Additional import path used to resolve QML modules in Creator's code model
QML_IMPORT_PATH =

# The .cpp file which was generated for your project. Feel free to hack it.
SOURCES += main.cpp \
latexrunner.cpp

HEADERS += latexrunner.h

# Installation path
# target.path =

# Please do not modify the following two lines. Required for deployment.
include(qtquick2applicationviewer/qtquick2applicationviewer.pri)
qtcAddDeployment()

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android

OTHER_FILES += \
    android/AndroidManifest.xml \
    README.md

android {
    RESOURCES += \
        resources.qrc
}
