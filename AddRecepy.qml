import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

AppPage{
    onVisibleChanged:{
        listModel5.clear()
         imagelink.text="Default image"
        recepyidentificator.text=receptlist.currentrecepyid
        receptlist.clearlists()
        if (receptlist.currentrecepyid===-1){
            deleterecepybutton.visible=false
            recepyname.text=""
            recepytext.text=""
            deleterecepybutton.visible=false
            imagelink.text="Default image"
        }
        else{
            receptlist.changerecepybuildpage(receptlist.currentrecepyid)
            deleterecepybutton.visible=true
        }
    }
    width: Screen.width
    height: Screen.height
    visible:false
    Connections {
        target: receptlist
        onAddingredienttonewrecepylist:{
            listModel5.append({ingidinr:ingredientid,inameinr:ingredient,iamountinr:typeamountt+" "+currenttype,ipriceinr:ingredientprice+" руб."})
            listModel5.curindex=listModel5.curindex+1
        }
        onFillcombobox:{
            model.clear()
            for(var i in ingredients) {
                model.append({text:ingredients[i], index:i})
            }
        }
        onSwitchdeftype:{
            currenttypelabel.text=deftype
        }
        onCreatenewrecepyresult:{
            toastaddnewrecepy.show(addnewrecepyresult)
            if (addnewrecepyresult=="Успешно"){
                receptlist.getreceptid(recepyidentificator.text)
            }
            if (ifdel){
                recepyname.text=""
                listModel5.clear()
                recepytext.text=""
                imagelink.text="Default image"
                stackview.pop()
            }
        }
        onChangerecepynameandtext:{
            recepyname.text=rname
            recepytext.text=rtext
            recepyidentificator.text=recid
            deleterecepybutton.visible=true
            imagelink.text=imglink
        }
        onDropchangerecepyidresult:{
            receptlist.clearlists()
            recepyidentificator.text=-1
        }
    }
    Connections {
        target: imagepickerandroid
        onImagesignal:{
            imagelink.text=imagepath
        }
    }
    Keys.onReleased: {
        if (event.key == Qt.Key_Back) {
            stackview.pop()
            recepyname.text=""
            listModel5.clear()
            recepytext.text=""
            deleterecepybutton.visible=false
            imagelink.text="Default image"
            receptlist.clearlists()
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
            id:backbuttonmd
            height: 30
            width: 30
            anchors.verticalCenter: parent.verticalCenter
            leftPadding: 5
            Image {
                height:parent.height
                fillMode: Image.PreserveAspectFit
                source: "back.png"
            }
            onClicked: {
                stackview.pop()
                recepyname.text=""
                listModel5.clear()
                recepytext.text=""
                deleterecepybutton.visible=false
                imagelink.text="Default image"
                receptlist.clearlists()
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
            anchors.top:parent.top
            anchors.bottom:ToolBar.top
            id: column
            width: parent.width
            spacing: 10
            anchors.topMargin: 30
            Label{
                id:recepyidentificator
                visible: true
            }
            TextField{
                id:recepyname
                color :"#ef4a4a45"
                background:Rectangle{
                    color:"#ffffff"
                }
                placeholderText: qsTr("Введите название блюда")
                onAccepted:{
                    focus:false
                    recepy.forceActiveFocus()
                }
            }
            Label{
                text:"Добавьте ингредиенты"
                font.pointSize: 15
                color :"#ef4a4a45"
            }
            Rectangle{
                id:rect
                width:parent.width
                height:40
                ComboBox {
                    id:combobox
                    width:parent.width/24*10
                    height:parent.height
                    editable: false
                    font.pointSize: 14
                    model: ListModel {
                        id: model
                        ListElement { text: "Coconut" }
                    }
                    onCurrentIndexChanged: {
                        receptlist.switcheddeftype(currentIndex+1)
                    }
                }
                TextField{
                    id:typeamount
                    color :"#ef4a4a45"
                    anchors.left:combobox.right
                    width:parent.width/6
                    inputMethodHints : Qt.ImhFormattedNumbersOnly
                    validator: IntValidator {bottom: 1}
                }
                Label{
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left:typeamount.right
                    width:parent.width/24*3
                    id:currenttypelabel
                    color :"#ef4a4a45"
                }
                AppButton {
                    id:addbutton
                    anchors.right: parent.right
                    width:parent.width/24*7
                    height:parent.height
                    contentItem: Text {
                         text: "Добавить"
                        font.pointSize: 15
                        color:"#ef4a4a45"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    onClicked: {
                        receptlist.addingrtonewrecepy(combobox.currentText, typeamount.text,currenttypelabel.text)
                        typeamount.text=""
                    }
                }
            }
            Rectangle{
                height:20
                width:parent.width
                AppButton{
                    id:selectimagebutton
                    width:parent.width/5*3
                    anchors.left: parent.left
                    contentItem: Text {
                        text:"Выбрать изображение"
                        font.pointSize: 15
                        color:"#ef4a4a45"
//                        horizontalAlignment: Text.AlignHCenter
//                        verticalAlignment: Text.AlignVCenter
                    }

                    onClicked: {
                        imagepickerandroid.selectimage()
                    }
                }
                Label{
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    id:imagelink
                    text:"Default image"
                    color:"#ef4a4a45"
                    width:parent.width/3
                    height:parent.height
                    elide:Text.ElideLeft
                    verticalAlignment: Text.AlignVCenter
                }
            }
            Rectangle{
                width:parent.width
                height:40
            }
            ListView {
                id: listView5
                y:400
                width:parent.width
                height:100
                spacing: 10
                delegate: Item {
                    id: item
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: 40
                    Label{
                        visible:false
                        id:ingredidd
                        text:ingidinr
                    }
                    Rectangle {
                        anchors.fill:parent
                        color: "#FFBA5C"
                        radius: 100
                        Label{
                            color:"#ef4a4a45"
                            wrapMode: Text.WordWrap
                            font.pointSize: 14
                            font.family: "Verdana"
                            text:inameinr
                            anchors.top:parent.top
                            anchors.left: parent.left
                            anchors.topMargin: 5
                            anchors.leftMargin: 30
                        }
                        Label{
                            color:"#ef4a4a45"
                            wrapMode: Text.WordWrap
                            font.pointSize: 14
                            font.family: "Verdana"
                            text:iamountinr
                            anchors.left: parent.left
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: 5
                            anchors.leftMargin: 30
                        }
                        Label{
                            id:ingredientpricelabel
                            color:"#ef4a4a45"
                            wrapMode: Text.WordWrap
                            font.pointSize: 14
                            font.family: "Verdana"
                            text:ipriceinr
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.rightMargin: 35
                        }
                        AppButton{
                            text:"X"
                            anchors.verticalCenter: parent.verticalCenter
                            height:20
                            width:20
                            font.pointSize: 13
                            anchors.rightMargin: 12
                            anchors.right: parent.right
                            anchors.bottom: parent.bottom
                            onClicked: {
                                receptlist.deleteingredientfromnewrecepy(ingredidd.text)
                                for (let i=0; i<listModel5.count;i++){
                                    if (listModel5.get(i).inameinr==inameinr){
                                        listModel5.remove(i)
                                    }
                                }
                                listModel5.curindex=listModel5.curindex-1
                            }
                        }
                    }
                }
                model: ListModel {
                    property var curindex: 0
                    id: listModel5
                }
            }
            Rectangle{
                width:parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                height:30
                color: "transparent"
            }
            Rectangle{
                height: 2
                width:parent.width
                color: "#ef4a4a45"
            }
            Rectangle{
                width:parent.width
                height:130
                radius: 15
                color: "#ffffff"
                TextInput{
                    id:recepytext
                    width:parent.width
                    height: parent.height
                    horizontalAlignment: Text.AlignLeft
                    wrapMode: Text.WordWrap
                    text:"Текст рецепта"
                    color: "#ef4a4a45"
                    clip: true
                }
            }
            Rectangle{
                width:parent.width
                height:20
                AppButton {
                    anchors.left:parent.left
                    id:ingredientbutton
                    width:parent.width/3
                    contentItem: Text {
                        text: "Ингредиенты"
                        font.pointSize: 15
                        color:"#ef4a4a45"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    onClicked: {
                        stackview.push(pagenewingredient)
                        receptlist.buildingredientlist()
                    }
                }
                AppButton {
                    visible:false
                    anchors.left:ingredientbutton.right
                    id:deleterecepybutton
                    width:parent.width/3 
                    contentItem: Text {
                        text: "Удалить"
                        font.pointSize: 15
                        color:"#ef4a4a45"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    onClicked: {
                        messageboxrecepy.visible=true
                        recepyname.enabled=false
                        typeamount.enabled=false
                        combobox.enabled=false
                        backbuttonmd.enabled=false
                        addbutton.enabled=false
                        selectimagebutton.enabled=false
                        listView5.enabled=false
                        ingredientbutton.enabled=false
                        savebutton.enabled=false
                        deleterecepybutton.enabled=false
                    }
                }
                AppButton {
                    id:savebutton
                    anchors.right:parent.right
                    width:parent.width/3
                    contentItem: Text {
                        text: "Сохранить"
                        font.pointSize: 15
                        color:"#ef4a4a45"
                       horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    onClicked: {
                        receptlist.createnewrecepy(recepyname.text,recepytext.text, recepyidentificator.text,imagelink.text)
                        receptlist.fillinlistsearch("", 0)
                        //stackview.pop()
                    }
                }
            }
            Rectangle{
                height: 50
                width:parent.width
                opacity:0
            }
        }
    }
    Rectangle{
        radius:10
        border.color : "#FFBA5C"
        border.width : 1
        visible:false
        id:messageboxrecepy
        height:110
        width:parent.width-40
        anchors.horizontalCenter: parent.horizontalCenter
        y:300
        Label{
            anchors.margins: 10
            id:messageboxlabel
            height:60
            font.pointSize: 16
            font.family: "Verdana"
            text:"После удаления рецепт нельзя будет вернуть"
            color:"#ef4a4a45"
            wrapMode: Text.WordWrap
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.left: messageboxrecepy.left
        }
        AppButton{
            anchors.bottomMargin: 5
            anchors.leftMargin: 5
            anchors.top:messageboxlabel.bottom
            anchors.left:parent.left
            font.family: "Verdana"
            contentItem: Text {
                text:"Отмена"
                font.pointSize: 16
                color:"#ef4a4a45"
//                        horizontalAlignment: Text.AlignHCenter
//                        verticalAlignment: Text.AlignVCenter
            }

            onClicked: {
                messageboxrecepy.visible=false
                recepyname.enabled=true
                typeamount.enabled=true
                combobox.enabled=true
                backbuttonmd.enabled=true
                addbutton.enabled=true
                selectimagebutton.enabled=true
                listView5.enabled=true
                ingredientbutton.enabled=true
                savebutton.enabled=true
                deleterecepybutton.enabled=true
            }
        }
        AppButton{
            anchors.rightMargin: 5
            anchors.bottomMargin: 5
            font.family: "Verdana"
            anchors.top:messageboxlabel.bottom
            anchors.right:parent.right
            contentItem: Text {
                text:"Удалить"
                font.pointSize: 16
                color:"#ef4a4a45"
//                        horizontalAlignment: Text.AlignHCenter
//                        verticalAlignment: Text.AlignVCenter
            }
            onClicked: {
                messageboxrecepy.visible=false
                recepyname.enabled=true
                typeamount.enabled=true
                combobox.enabled=true
                backbuttonmd.enabled=true
                addbutton.enabled=true
                selectimagebutton.enabled=true
                listView5.enabled=true
                ingredientbutton.enabled=true
                savebutton.enabled=true
                deleterecepybutton.enabled=true
                receptlist.deleterecepy(recepyidentificator.text)
                stackview.pop()
                stackview.pop()
                receptlist.fillinlistsearch("", 0)
                recepyidentificator.text="-1"
                recepyname.text=""
                listModel5.clear()
                recepytext.text=""
                deleterecepybutton.visible=false
                imagelink.text="Default image"
                receptlist.clearlists()
            }
        }
    }
    ToastManager{ id: toastaddnewrecepy }
}
