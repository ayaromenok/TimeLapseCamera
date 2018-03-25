import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Window 2.2
import QtMultimedia 5.9
import QtQuick.Layouts 1.1

ApplicationWindow {
    visible: true
    width: 640
    height: 360
    title: qsTr("TimeLapse Camera")

    property int dpi: Screen.pixelDensity * 25.4

    function dp(x){
        //console.log(dpi)
        if(dpi < 120) {
            console.log(x);
            return x;

        } else {
            console.log(x*(dpi/160));
            return x*(dpi/160);
        }
    }
    GridLayout {
        anchors.fill: parent
        rows: 1
        columns: 2
        rowSpacing: 0
        columnSpacing: 0
        Rectangle {
            color: "darkgrey"
            implicitWidth: parent.width-dp(160)
            implicitHeight: parent.height
        }
        Rectangle {
            color: "lightgrey"
            implicitWidth: dp(160)
            implicitHeight: parent.height
            Switch{
            }
        }
    }

}
