import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

AppPage{
    width: Screen.width
    visible:false
    Connections {
        target: receptlist
        onNewringredientanswer:{
            toastaddnewingredient.show(ans)
            if (ans=="Ингредиент добавлен"){
                ingridientname.text=""
                defamountname.currentIndex=0
                ampricename.text=""

            }
        }
        onShowconnection:{
            if( con ){

            }
            else{
                toastaddnewingredient.show("Отсутствует соединение с сетью")
                if (receptlist.currentrecepyid!=-1){
                    stackview.pop()
                    stackview.pop()
                }
                stackview.pop()
                stackview.pop()

            }
        }
        onPrintingredientlist:{
            listModel3.clear()
            for(var i in ingrid) {
                listModel3.append({ingid:ingrid[i],iname:ingrnames[i],iamount:ingram[i]+amtype[i],iprice:ingrprice[i]+"руб."})
            }
        }
    }
    Keys.onReleased: {
        if (event.key == Qt.Key_Back) {
            stackview.pop()
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
        AppButton {
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
            }
        }
        Label{
            anchors.verticalCenter: parent.verticalCenter
            anchors.left:parent.left
            leftPadding: 50
            text:"Ингредиенты"
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
            topPadding: 10
            width:parent.width-20
            height:parent.height
            anchors.top:topmenubar.bottom
            id: column
            spacing:10
            Rectangle{
                height:20
                width:parent.width
            }

            TextField{
                width:parent.width
                color:"#ef4a4a45"
                font.pointSize: 16
                font.family: "Verdana"
                id:ingridientname
                placeholderText: qsTr("Введите название Ингредиента")
            }
            Rectangle{
                id:rect8
                width:parent.width
                height:40
                color:"#ffffff"
                Label{
                    color:"#ef4a4a45"
                    font.pointSize: 16
                    font.family: "Verdana"
                    id:label8
                    height:parent.height
                    width:parent.width/2
                    text:"Выберите единицу измерения"
                    verticalAlignment: Text.AlignVCenter
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                }
                ComboBox{
                    font.pointSize: 16
                    font.family: "Verdana"
                    height:parent.height
                    anchors.right:parent.right
                    width:parent.width/3
                    id:defamountname
                    background:Rectangle{
                        color:"#ffffff"
                    }
                    editable: false
                    model: ListModel {
                        id: model
                        ListElement { text: "шт." }
                        ListElement { text: "гр." }
                        ListElement { text: "мл." }
                    }
                }
            }
            TextField{
                width:parent.width
                verticalAlignment: Text.AlignVCenter
                color:"#ef4a4a45"
                font.pointSize: 16
                font.family: "Verdana"
                id:ampricename
                background:Rectangle{
                    color:"#ffffff"
                }
                inputMethodHints : Qt.ImhFormattedNumbersOnly
                validator: IntValidator {bottom: 1}
                placeholderText: qsTr("Введите цену в рублях за минимальное количество продукта")
            }
            Label{
                height:80
                color:"#ef4a4a45"
                font.pointSize: 16
                font.family: "Verdana"
                width:parent.width
                wrapMode: Text.WordWrap
                text:"Минимальное колличество продукта\nдля штук = 1,\nдля граммов и миллилитров = 100"
            }

            AppButton {
                height:40
                width:100
                id:lastaddingrbutton
                anchors.horizontalCenter: parent.horizontalCenter
                Label{
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    text: "Добавить"
                    color:"#ef4a4a45"
                    font.pointSize: 16
                }
                onClicked: {
                    receptlist.addnewingredient(ingridientname.text,defamountname.currentText,ampricename.text)
                    receptlist.buildcombobox()
                    receptlist.buildingredientlist()
                }
            }
            Rectangle{
                height:55
                width:parent.width
            }
            ListView {
                id: listView3
                x : Screen.width / 2 - width / 2
                width: parent.width
                anchors.left: parent.left
                anchors.right: parent.right
                height:250
                delegate: Item {
                    id: item
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: 60
                    width:parent.width
                    Label {
                        id:iid
                        text:ingid
                        visible: false
                    }
                    Rectangle {
                        anchors.fill:parent
                        anchors.margins: 5
                        color: "#FFBA5C"
                        radius: 100
                        Label{
                            leftPadding: 20
                            topPadding: 5
                            color:"#ef4a4a45"
                            wrapMode: Text.WordWrap
                            font.pointSize: 16
                            font.family: "Verdana"
                            text:iname
                            anchors.top:parent.top
                            anchors.left: parent.left
                        }
                        Label{
                            leftPadding: 20
                            bottomPadding: 5
                            color:"#ef4a4a45"
                            wrapMode: Text.WordWrap
                            font.pointSize: 12
                            font.family: "Verdana"
                            text:iamount
                            anchors.left: parent.left
                            anchors.bottom: parent.bottom
                        }
                        Label{
                            color:"#ef4a4a45"
                            wrapMode: Text.WordWrap
                            font.pointSize: 12
                            font.family: "Verdana"
                            text:iprice
                            anchors.right: parent.right
                            anchors.top: parent.top
                            rightPadding: 20
                            topPadding: 5
                        }
                    }
                }
                model: ListModel {
                    id: listModel3
                }
            }
        }
        ToastManager{ id: toastaddnewingredient }
    }

}




