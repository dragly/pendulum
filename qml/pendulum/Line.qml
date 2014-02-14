import QtQuick 2.0

Canvas {
    id:canvas
    property color color: "cyan"
    property real lineWidth: 1.5
    property point startPoint: Qt.point(0,0)
    property point endPoint: Qt.point(100,100)
    antialiasing: true

    x: Math.min(startPoint.x, endPoint.x)
    y: Math.min(startPoint.y, endPoint.y)
    width: Math.max(startPoint.x, endPoint.x) - x + 4
    height: Math.max(startPoint.y, endPoint.y) - y + 4

    onLineWidthChanged:requestPaint();
    onStartPointChanged: requestPaint();
    onEndPointChanged: requestPaint();

    function relativeX(x) {
        return x - canvas.x;
    }
    function relativeY(y) {
        return y - canvas.y;
    }

    onPaint: {
        var ctx = canvas.getContext('2d');
        ctx.save();
        ctx.clearRect(0, 0, canvas.width, canvas.height);
        ctx.strokeStyle = canvas.color;
        ctx.lineWidth = canvas.lineWidth;

        ctx.beginPath();
        ctx.moveTo(relativeX(startPoint.x), relativeY(startPoint.y));
        ctx.lineTo(relativeX(endPoint.x), relativeY(endPoint.y));
        ctx.stroke();
        ctx.restore();
    }
}
