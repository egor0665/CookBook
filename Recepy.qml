import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

AppPage{
    visible:false
    onVisibleChanged: {
        receptlist.getreceptid(receptlist.currentrecepyid)
    }

    Connections {
        target: receptlist
        onFillinreppage:{
            receptname.text = rname + "\n" + price + " руб."
            recepttext.text = rtext
            receptingredients.text = ingredients
            recepyident.text = ident
            recepyimage.source = imgurl
            if(favrec==1) {
                idfavrec.source = "fav.png"
                idfavrecbutton.text = 1
            }
            else {
                idfavrec.source = "notfav.png"
                idfavrecbutton.text = 0
            }
        }
    }
    Keys.onReleased: {
        if (event.key == Qt.Key_Back) {
            stackview.pop();
            recepyident.text="-1"
            receptlist.currentrecepyid = -1
            event.accepted = true
        }
    }
    Rectangle{
        id:topmenubar
        color:"#FFBA5C"
        anchors.top:parent.top
        anchors.left:parent.left
        width:parent.width
        height:50
        AppButton{
            height: 30
            width: 30
            anchors.verticalCenter: parent.verticalCenter
            leftPadding: 5
            Image {
                height:parent.height
                fillMode: Image.PreserveAspectFit
                source: "back.png"
            }
            onClicked:{
                stackview.pop();
                recepyident.text="-1"
                receptlist.currentrecepyid = -1
            }
        }
        Label{
            anchors.verticalCenter: parent.verticalCenter
            anchors.left:parent.left
            leftPadding: 50
            text:"Рецепт"
            color:"#ef4a4a45"
            font.pointSize: 20
        }
    }
    ScrollView {
        anchors.top:topmenubar.bottom
        width: parent.width-40
        contentWidth: -1
        height:parent.height-50
        clip: true
        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
        ScrollBar.vertical.policy: ScrollBar.AlwaysOff
        anchors.horizontalCenter: parent.horizontalCenter
        Column {
            topPadding: 5
            anchors.top:parent.top
            anchors.bottom:ToolBar.top
            id: column2
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 10
            Label{
                id:recepyident
                visible: false
            }
            Rectangle{
                anchors.horizontalCenter: parent.horizontalCenter
                width:parent.width
                height:70
                Label{
                    topPadding: 10
                    height:parent.height
                    font.bold: true
                    leftPadding: 10
                    anchors.verticalCenter: parent.verticalCenter
                    wrapMode: Text.WordWrap
                    font.pointSize: 18
                    font.family: "Roboto"
                    id:receptname
                    width:parent.width-40
                    color:"#ef4a4a45"
                }
                AppButton{
                    anchors.rightMargin: 10
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    background: Rectangle{
                        color: "#ffffff"
                    }
                    height:30
                    width:30
                    Label{
                        id:idfavrecbutton
                        visible:false
                    }
                    Image{
                        id:idfavrec
                        anchors.fill:parent
                    }
                    onClicked: {
                        receptlist.setfav(recepyident.text, idfavrecbutton.text)
                        if (idfavrecbutton.text==1){
                            idfavrecbutton.text=0
                            idfavrec.source="notfav.png"
                        }
                        else {
                            idfavrecbutton.text=1
                            idfavrec.source="fav.png"
                        }
                    }
                }
            }
            Rectangle{
                height: 2
                width:parent.width
                color: "#ef4a4a45"
            }
            Image{
                id:recepyimage
                source:"defaultrecepyimg.png"
                fillMode: Image.PreserveAspectFit
                anchors.horizontalCenter: parent.horizontalCenter
                height:300
            }
//            Rectangle{
//                color: "#FFBA5C"
//                radius: 25
//                anchors.horizontalCenter: parent.horizontalCenter
//                width:parent.width
//                height:50
            Rectangle{
                height: 2
                width:parent.width
                color: "#ef4a4a45"
            }
            Label{

                wrapMode: Text.WordWrap
                font.pointSize: 14
                font.family: "Verdana"
                id: receptingredients
                width:parent.width
                color:"#ef4a4a45"
            }
            Rectangle{
                height: 2
                width:parent.width
                color: "#ef4a4a45"
            }
//            }
            Text{
                leftPadding: 5
                bottomPadding: 10
                color:"#ef4a4a45"
                font.pointSize: 16
                font.family: "Verdana"
                horizontalAlignment: Text.AlignLeft
                wrapMode: Text.WordWrap
                width:parent.width
                id:recepttext
                topPadding: 5
            }
            AppButton{
                width:parent.width/2
                height:40
                Label{
                    font.pointSize: 16
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    text:"Поделиться"
                    color:"#ef4a4a45"
                }
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: {
                    receptlist.sharerecepy(receptname.text,receptingredients.text,recepttext.text)
                    toastclipboard.show("Рецепт сохранен в буффер обмена")
                }
            }
            AppButton{
                width:parent.width/2
                height:40
                Label{
                    font.pointSize: 16
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    text:"Редактировать"
                    color:"#ef4a4a45"
                }
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: {
                    stackview.push(pageaddrecepy)
                    varchangerecepy=1

                }
            }
            Rectangle{
                height:50
                width: parent.width
            }
        }
    }
    ToastManager{ id: toastclipboard }
}
