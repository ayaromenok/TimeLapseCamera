import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Window 2.2
import QtMultimedia 5.9
import QtQuick.Layouts 1.3
import QtQml 2.2
import FileIO 1.0

ApplicationWindow {
    visible: true
    width: 640
    height: 360
    title: qsTr("TimeLapse Camera")

    property int dpi: Screen.pixelDensity * 25.4
    property var timerMultVal : 1000; //default - sec
    property var imageCount: 0;
    property var atStart: 0;
    property string saveToPath: "/storage/emulated/0/DCIM";

    FileIO{
        id: fio
    }

    function getCurrentDir()
    {
        console.log(fio.getCurrentDir())
        return fio.getCurrentDir()
    }
    function dp(x){
        //console.log(dpi)
        //        if(dpi < 120) {
        //            console.log(x);
        //            return x;

        //        } else {
        //            console.log(x*(dpi/160));
        //            return x*(dpi/160);
        //        }
        return x;
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

    function updateStorage(){
        switch (cbStorage.currentIndex){
        case 0:
            console.log("Save to Internal storage")
            saveToPath = fio.useInternalStorage()
            break;
        case 1:
            console.log("Save to External(SD card) storage")
            saveToPath = fio.useExternalStorage()
            //saveToPath = "some path"
            break;
        }
        console.log(saveToPath)
    }

    function previousStorageIndex(){
        saveToPath = fio.usePreviousStorage()
        if (saveToPath.includes("emulated/0"))
            return 0;
        else
            return 1;
    }

    Timer {
        id: camTimer
        interval: 1000
        running: false;
        repeat: true;
        onTriggered: {
            console.log("timer event");
            if (imageCount == 0){
                mmCamera.searchAndLock();
            }
            if (atStart == 0){
                getCurrentDir()
                fio.useInternalStorage();
                atStart++
            }
            mmCamera.imageCapture.captureToLocation(saveToPath);
            //mmCamera.imageCapture;
            imageCount++;
            lbFileCountValue.text = Number(imageCount)
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
                    }
                    onImageSaved:{
                        console.log("onImageSaved");
                        var imgPath = mmCamera.imageCapture.capturedImagePath
                        var lastSlash = imgPath.lastIndexOf("/");
                        var strLength = imgPath.length
                        lbFileNameValue.text = imgPath.substr((lastSlash+1),(strLength-lastSlash))
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
                rows: 6
                columns: 2
                anchors.fill: parent
                rowSpacing: 2
                columnSpacing: 5
                Label {
                    id: lbAppName
                    Layout.row: 1
                    Layout.columnSpan: 2
                    Layout.fillWidth: true
                    text: qsTr("Time Lapse Camera")
                    horizontalAlignment: Text.AlignHCenter
                }

                Rectangle {
                    id: rcSwitch
                    Layout.minimumHeight: 38
                    Layout.minimumWidth: 60
                    Layout.row: 2
                    Layout.columnSpan: 2
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: "grey"
                    RowLayout{
                        Switch{
                            id: swStart
                            Layout.row: 2
                            Layout.columnSpan: 2
                            Layout.fillWidth: true
                            text: qsTr("Start Capture")
                            font.capitalization: Font.AllUppercase
                            font.pointSize: 13
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                            onToggled: {
                                if (swStart.checked){
                                    console.log(Number(tfTimerValue.text))
                                    updateTimerValues()
                                    camTimer.start()
                                    console.log("timer on")
                                    swStart.text = qsTr("Stop Capture")
                                }
                                else {
                                    camTimer.stop()
                                    console.log("timer off")
                                    swStart.text = qsTr("Start Capture")
                                    imageCount = 0
                                }
                            }
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
                        updateTimerValues()
                    }
                }

                ComboBox {
                    id: cbTimerValueType
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    rightPadding: 20
                    model: ["msec", "sec", "min"]
                    currentIndex: 1
                    Layout.maximumWidth: dp(110)
                    Layout.preferredWidth: dp(110)
                    Layout.minimumWidth: dp(110)
                    onCurrentIndexChanged: {
                        console.log("sec\min changed")
                        updateTimerValues()
                    }

                }

                Label {
                    id: lbStorage
                    text: "Save To"
                }

                ComboBox {
                    id: cbStorage
                    model: ["Internal", "SD Card"]
                    currentIndex: 0
                    rightPadding: 20
                    Layout.maximumWidth: dp(110)
                    Layout.preferredWidth: dp(110)
                    Layout.minimumWidth: dp(110)
                    onCurrentIndexChanged: {
                        console.log("change Storage")
                        updateStorage()
                    }
                    Component.onCompleted: currentIndex = previousStorageIndex()
                }

                Rectangle {
                    id: rcStub
                    Layout.minimumHeight: 60
                    Layout.minimumWidth: 60
                    Layout.row: 5
                    Layout.columnSpan: 2
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: "lightgrey"
                }
                GroupBox {
                    Layout.row: 6
                    Layout.columnSpan: 2
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    id: gbStatusBar
                    title: qsTr("Actual Information")
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
                            text: qsTr("IMG_0000000X.jpg")
                        }
                        Label {
                            id: lbFileCount
                            text: qsTr("Number:")
                        }
                        Label {
                            id: lbFileCountValue
                            width: parent.width-dp(160)
                            text: qsTr("0")
                        }
                    }
                }



            }
        }
    }

}
