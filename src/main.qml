import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Window 2.2
import QtMultimedia 5.9
import QtQuick.Layouts 1.3
import QtQml 2.2

ApplicationWindow {
    visible: true
    width: 640
    height: 360
    title: qsTr("TimeLapse Camera")

    property int dpi: Screen.pixelDensity * 25.4
    property var timerMultVal : 1000; //default - sec
    property var imageCount: 0;

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
    function updateTimerValues(){

        switch (cbTimerValueType.currentIndex){
        case 0:
            console.log("msec");
            timerMultVal = 1;
            lbIntervalValue.text = (tfTimerValue.text + " msec");
            break;
        case 1:
            console.log("sec");
            timerMultVal = 1000;
            lbIntervalValue.text = (tfTimerValue.text + " sec");
            break;
        case 2:
            console.log ("min");
            timerMultVal = 60000;
            lbIntervalValue.text = (tfTimerValue.text + " min");
            break;
        }
        camTimer.interval = Number(tfTimerValue.text)*timerMultVal;
    }
    Timer {
        id: camTimer
        interval: 1000
        running: false;
        repeat: true;
        onTriggered: {
            console.log("timer event");
            //if (imageCount == 0)
            mmCamera.searchAndLock();
            mmCamera.imageCapture.captureToLocation("/storage/emulated/0/DCIM/Camera");
            //mmCamera.imageCapture;
            imageCount++;
        }
    }
    GridLayout {
        anchors.fill: parent
        rows: 1
        columns: 2
        rowSpacing: 0
        columnSpacing: 0
        Rectangle {
            color: "lightgrey"
            implicitWidth: parent.width-dp(190)
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
        Rectangle {
            color: "lightgrey"
            implicitWidth: dp(190)
            implicitHeight: parent.height
            GridLayout {
                id: gridLoUI
                rows: 4
                columns: 2
                anchors.fill: parent
                rowSpacing: 2
                columnSpacing: 5
                Label {
                    id: lbAppName
                    Layout.row: 1
                    Layout.columnSpan: 2
                    Layout.fillWidth: true
                    text: qsTr("TimeLapse Camera")
                    horizontalAlignment: Text.AlignHCenter
                }

                Switch{
                    id: swStart
                    Layout.row: 2
                    Layout.columnSpan: 2
                    Layout.fillWidth: true
                    text: qsTr("Start")
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    onToggled: {
                        if (swStart.checked){
                            console.log(Number(tfTimerValue.text))
                            updateTimerValues()
                            camTimer.start()
                            console.log("timer on")
                        }
                        else {
                            camTimer.stop()
                            console.log("timer off")
                        }
                    }

                }

                TextField {
                    id: tfTimerValue
                    text: qsTr("2")
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

                GroupBox {
                    Layout.row: 4
                    Layout.columnSpan: 2
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    id: gbStatusBar
                    title: qsTr("info")
                    GridLayout {
                        id: gridLoInfo
                        anchors.fill: parent
                        columns: 2
                        rows: 3
                        //rowSpacing: 2
                        //columnSpacing: 5
                        Label {
                            id: lbSavedTo
                            text: qsTr("Save to:")
                        }
                        Label {
                            id: lbSavedToValue
                            width: parent.width-dp(80)
                            text: qsTr("Internal")
                        }
                        Label {
                            id: lbInterval
                            text: qsTr("Timer:")
                        }
                        Label {
                            id: lbIntervalValue
                            width: parent.width-dp(80)
                            text: qsTr("1 sec")
                        }
                        Label {
                            id: lbFileName
                            text: qsTr("name:")
                        }
                        Label {
                            id: lbFileNameValue
                            width: parent.width-dp(160)
                            text: qsTr("NAME_0000.jpg")
                        }
                        Label {
                            id: lbMakePicture
                            text: qsTr("Shot:")
                        }
                        Label {
                            id: lbMakePictureValue
                            width: parent.width-dp(160)
                            text: qsTr("wait timer")
                        }
                    }
                }

            }
        }
    }

}
