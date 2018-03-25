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
            implicitWidth: parent.width-dp(190)
            implicitHeight: parent.height
            Rectangle {
                color: "grey"
                implicitWidth: parent.width
                implicitHeight: parent.height
                Camera {
                    id: mmCamera
                    captureMode: Camera.CaptureStillImage
                    imageCapture{
                        onImageCaptured:{
                            console.log("onImageCaptured");
                            console.log(mmCamera.imageCapture.capturedImagePath)
                            lbFileNameValue.text = mmCamera.imageCapture.capturedImagePath
                        }
                        onImageSaved:{
                            console.log("onImageSaved");
                        }
                    }
                }
                VideoOutput {
                    id: videoOutput
                    source: mmCamera
                    anchors.fill: parent
                }
            }
        }
        Rectangle {
            color: "lightgrey"
            implicitWidth: dp(190)
            implicitHeight: parent.height
            GridLayout {
                id: gridLoUI
                rows: 5
                columns: 2
                anchors.fill: parent
                rowSpacing: 2
                columnSpacing: 5
                Rectangle {
                    Layout.row: 1
                    Layout.columnSpan:2
                    Label {
                        id: lbAppName
                        text: qsTr("TimeLapse Camera")
                        horizontalAlignment: Text.AlignHCenter
                    }
                }

                Rectangle {
                    Layout.row: 1
                    Layout.columnSpan:2
                    Switch{
                        id: swStart
                        text: qsTr("Start")
                    }
                }

                TextField {
                    id: tfTimerValue
                    text: qsTr("10")
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    horizontalAlignment: Text.AlignRight
                    Layout.maximumWidth: dp(50)
                    Layout.minimumWidth: dp(50)
                    Layout.preferredWidth: dp(50)
                    onTextChanged: {
                        console.log("timer value changed")
                    }
                }

                ComboBox {
                    id: cbTimerValueType
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    rightPadding: 20
                    model: ["msec", "sec", "min"]
                    currentIndex: 1
                    Layout.maximumWidth: dp(100)
                    Layout.preferredWidth: dp(100)
                    Layout.minimumWidth: dp(100)
                    onCurrentIndexChanged: {
                        console.log("sec\min changed")
                    }

                }
                Button{
                    text: "Test"
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                }
                Button{
                    text: "More"
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                }
            }
        }
    }

}
