This is an experimental project to test the features of QML for
physics apps. In the first iteration, it will include a few
mechanics examples, using the Box2D engine to drive many of them,
in addition to simple javascript code.

# Prerequisites

You need to have Qt 5.2 or above installed and use the following
Box2D repository:

  git clone http://github.com/dragly/qml-box2d
  mkdir build
  cd build
  <path to Qt5.2>/bin/qmake ../qml-box2d/
  make
  make install
