import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Styles 1.4
import QtGraphicalEffects 1.0

AppPage{
    visible:false
    Connections {
        target: receptlist
        onFilluplistresult:{
            listModel.append({recid:rid,rname:rname,ingred:ingredients, imgurl:imgurl , price:price+" руб."})
        }
        onFillcombobox:{
            model.clear()
            for(var i in ingredients) {
                model.append({text:ingredients[i], index:i})
            }
        }
        onAddingrtosearchrecepyres:{
            if (son===1)
                listModelpageFindRecepy.append({ingidinr:ingredientid,inameinr:"+ "+ingredient, sontext:son, bcgcol:"#FFBA5C"})
            else
                listModelpageFindRecepy.append({ingidinr:ingredientid,inameinr:"- "+ingredient, sontext:son, bcgcol:"#EEA94B"})
            listModelpageFindRecepy.curindex=listModelpageFindRecepy.curindex+1
        }
        onClearrecepylist:{
            listModel.clear()
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
                stackview.pop()
            }
        }
        Label{
            anchors.verticalCenter: parent.verticalCenter
            anchors.left:parent.left
            leftPadding: 50
            text:"Рецепты"
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
        Column{
            topPadding: 10
            width:parent.width
            height:parent.height
            anchors.top:topmenubar.bottom
            Rectangle{
                width:parent.width
                height:50
                TextField{
                    id:searchrecepynamepageFindRecepy
                    width:parent.width/4*3
                    height:40
                    anchors.left: parent.left
                    placeholderText: "Введите название рецепта"
                }
                Button{
                    id:search
                    width:parent.width/4
                    height:40
                    anchors.right: parent.right
                    font.pointSize: 16
                    font.family: "Roboto"
                    background: Rectangle{
                        color: "#FFBA5C"
                    }
                    text:"Найти"
                    onClicked: {
                        receptlist.fillinlistsearch(searchrecepynamepageFindRecepy.text, chechboxfavrecepy.checkState )
                    }
                }
            }
            Rectangle{
                height:60
                width:parent.width
                ComboBox {
                    id:combobox
                    width:parent.width/4*3
                    height:parent.height-20
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left:parent.left
                    editable: false
                    background: Rectangle{
                        color:"#ffffff"
                    }
                    model: ListModel {
                        id: model
                        ListElement { text: "Coconut" }
                    }
                }
                AppButton{

                    font.pointSize: 16
                    font.family: "Roboto"
                    height:parent.width/8
                    width:parent.width/8
                    anchors.right:buttonminus.left
                    anchors.verticalCenter: parent.verticalCenter
                    text:"+"
                    onClicked: {
                        receptlist.addingrtosearchrecepy(combobox.currentText,1)
                    }
                }
                AppButton{
                    id:buttonminus
                    font.pointSize: 16
                    font.family: "Roboto"
                    height:parent.width/8
                    width:parent.width/8
                    anchors.right:parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    text:"-"
                    onClicked: {
                        receptlist.addingrtosearchrecepy(combobox.currentText,-1)
                    }
                }
            }
            CheckBox{
                font.pointSize: 15
                font.family: "Roboto"
                id:chechboxfavrecepy
                text: "Любимые"
            }
            Rectangle{
                height:35
                width:parent.width
                opacity: 0
            }

            ListView {
                id: listViewPageFindRecepy
                width:parent.width
                height:70
                spacing: 5
                delegate: Item {
                    id: item
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: 30
                    width:parent.width
                    Label{
                        color:"#ef4a4a45"
                        visible:false
                        id:ingrediddPageFindRecepy
                        text:ingidinr
                    }
                    Rectangle {
                        anchors.fill:parent
                        radius: 100
                        color: bcgcol
                        Label{
                            id:sonid
                            text:sontext
                            visible: false
                        }

                        Label{
                            anchors.verticalCenter: parent.verticalCenter
                            leftPadding: 20
                            color:"#ef4a4a45"
                            wrapMode: Text.WordWrap
                            font.pointSize: 16
                            font.family: "Verdana"
                            text:inameinr
                            anchors.left: parent.left
                        }
                        AppButton{
                            text:"X"
                            anchors.verticalCenter: parent.verticalCenter

                            background: Rectangle{
                                color: bcgcol
                                radius: 100
                            }

                            height:30
                            width:30
                            font.pointSize: 13;
                            anchors.right: parent.right
                            onClicked: {
                                receptlist.deleteingredientfromsearchrecepy(ingrediddPageFindRecepy.text,sonid.text )
                                for (let i=0; i<listModelpageFindRecepy.count;i++){
                                    if (listModelpageFindRecepy.get(i).inameinr==inameinr){
                                        listModelpageFindRecepy.remove(i)
                                    }
                                }
                                listModelpageFindRecepy.curindex=listModelpageFindRecepy.curindex-1
                            }
                        }
                    }
                }
                model: ListModel {
                    property var curindex: 0
                    id: listModelpageFindRecepy
                }
            }
            Rectangle{
                width:parent.width
                height:110
                opacity: 0
            }
            ListView {
                id: listView1
                x : Screen.width / 2 - width / 2
                width: Screen.width-20
                y:50
                anchors.left: parent.left
                anchors.right: parent.right
                height:(parent.height-listView1.y)
                spacing: 10
                delegate: Item {
                    id: itemcb
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: 70
                    width:parent.width
                    Label {
                        id:rec
                        text:recid
                        visible: false
                    }
                    AppButton {
                        font.pointSize: 20
                        font.family: "Verdana"
                        anchors.fill:parent
                        onClicked: {
                            receptlist.currentrecepyid = rec.text
                            stackview.push(pagerecepy)
                        }
                        Image {
                            id:img
                            width:Screen.width/6
                            height:parent.height
                            source: imgurl
                            layer.enabled: true
                            layer.effect: OpacityMask {
                                maskSource: mask
                            }
                        }
                        Rectangle {
                            id: mask
                            width: 500
                            height: 500
                            radius: 250
                            visible: false
                        }
                        Label{
                            width:parent.width/3*2
                            color:"#ef4a4a45"
                            font.pointSize: 16
                            font.family: "Verdana"
                            id:textr
                            text:rname
                            anchors.top:parent.top
                            anchors.left: img.right
                            leftPadding: 5
                            elide: Text.ElideRight
                        }
                        Label{
                            width:parent.width/3*2
                            elide: Text.ElideRight
                            id:ingredtext
                            color:"#ef4a4a45"
                            font.pointSize: 12
                            font.family: "Verdana"
                            text:ingred
                            anchors.left: img.right
                            anchors.top: textr.bottom
                            leftPadding: 5
                        }
                        Label{
                            color:"#ef4a4a45"
                            wrapMode: Text.WordWrap
                            font.pointSize: 12
                            font.family: "Verdana"
                            text:price
                            anchors.left: img.right
                            anchors.top: ingredtext.bottom
                            leftPadding: 5
                        }
                    }
                }
                model: ListModel {
                    id: listModel // задаём ей id для обращения
                }
            }
        }
        Rectangle{
            opacity:0
            height: 70
            width:parent.width
        }
    }
}
