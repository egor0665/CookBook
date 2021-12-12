import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

AppPage{
    onVisibleChanged: anslabel2.text=""
    visible:false
    Connections {
        target: receptlist
//        onFillingredient:{
//            ingridientnm.text=ingrname
//            if (amtype=="шт.")
//                ingredientdefam.currentIndex = 0
//            if (amtype=="мл.")
//                ingredientdefam.currentIndex = 2
//            if (amtype=="гр.")
//                ingredientdefam.currentIndex = 1
//            ingridientpr.text=ingrprice
//            ingrid.text=ingridd
//        }
//        onChangeingredientanswer:{
//            toastchangeingredient.show(answer)

//        }
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
            onClicked: {
                stackview.pop()
            }
        }
        Label{
            anchors.verticalCenter: parent.verticalCenter
            anchors.left:parent.left
            leftPadding: 50
            text:"Ингредиент"
            color:"#ef4a4a45"
            font.pointSize: 20
        }
    }

    Label{
        id:ingrid
        visible: false
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
            y:50
            anchors.horizontalCenter: parent.horizontalCenter
            id: column
            width: parent.width-20
            height: parent.height
            spacing: 10
            Rectangle{
                width:parent.width
                height:40
                color:"#ffffff"
                Label{
                    height:parent.height
                    width:parent.width/3
                    text:"Название"
                    color:"#ef4a4a45"
                }
                TextField{
                    width:parent.width/3*2
                    id:ingridientnm
                    anchors.right:parent.right
                    background:Rectangle{
                        color:"#ffffff"
                    }
                    color:"#ef4a4a45"
                }

            }
            Rectangle{
                width:parent.width
                height:40
                color:"#ffffff"
                Label{
                    id:label8
                    height:parent.height
                    width:parent.width/2
                    text:"Единица измерения"
                    color:"#ef4a4a45"
                }
                ComboBox{
                    anchors.right:parent.right
                    width:parent.width/3
                    id:ingredientdefam

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
            Rectangle{
                width:parent.width
                height:40
                color:"#ffffff"
                Label{
                    height:parent.height
                    width:parent.width/3*2
                    wrapMode: Text.WordWrap
                    color:"#ef4a4a45"
                    text:"Цена в рублях за минимальное количество продукта"
                }
                TextField{
                    color:"#ef4a4a45"
                    width:parent.width/3
                    id:ingridientpr
                    inputMethodHints : Qt.ImhFormattedNumbersOnly
                    validator: IntValidator {bottom: 1}
                    anchors.right:parent.right
                    background:Rectangle{
                        color:"#ffffff"
                    }
                }
            }
            Label{
                height: 30
                id:anslabel2
                width:parent.width
                topPadding: 20
                bottomPadding: 20
                font.pointSize: 16
                color:"#ef4a4a45"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            Rectangle{
                anchors.horizontalCenter: parent.horizontalCenter
                width:parent.width/3*2
                height:40

                AppButton {
                    width:parent.width/2
                    id:changeingredientbutton
                    contentItem: Text {
                        text: "Изменить"
                        font.pointSize: 16
                        color:"#ef4a4a45"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    onClicked: {
                        receptlist.changeingredient(ingridientnm.text,ingridientpr.text,ingredientdefam.currentText)
                        receptlist.buildingredientlist()
                    }
                }
                AppButton {
                    width:parent.width/2
                    id:deleteingredientbutton
                    anchors.left:changeingredientbutton.right
                    contentItem: Text {
                        text: "Удалить"
                        font.pointSize: 16
                        color:"#ef4a4a45"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    onClicked: {
                        ingredientdefam.enabled=false
                        ingridientnm.enabled=false
                        ingridientpr.enabled=false
                        changeingredientbutton.enabled=false
                        deleteingredientbutton.enabled=false
                        messageboxingredient.visible=true
                    }
                }
            }
        }
        Rectangle{
            visible:false
            id:messageboxingredient
            height:100
            width:parent.width-40
            anchors.horizontalCenter: parent.horizontalCenter
            y:300
            Label{
                id:messageboxlabel
                height:60
                font.pointSize: 16
                font.family: "Verdana"
                color:"#ef4a4a45"
                text:"При удалении ингредиента будут удалены все связанные с ним рецепты"
                wrapMode: Text.WordWrap
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.left: messageboxingredient.left
            }
            AppButton{
                anchors.top:messageboxlabel.bottom
                anchors.left:parent.left
                contentItem: Text {
                    text:"Отмена"
                    font.pointSize: 16
                    color:"#ef4a4a45"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                onClicked: {
                    messageboxingredient.visible=false
                    ingredientdefam.enabled=true
                    ingridientnm.enabled=true
                    ingridientpr.enabled=true
                    changeingredientbutton.enabled=true
                    deleteingredientbutton.enabled=true
                }
            }
            AppButton{
                anchors.top:messageboxlabel.bottom
                anchors.right:parent.right
                contentItem: Text {
                    text:"Удалить"
                    font.pointSize: 16
                    color:"#ef4a4a45"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                onClicked: {

                    messageboxingredient.visible=false
                    ingredientdefam.enabled=true
                    ingridientnm.enabled=true
                    ingridientpr.enabled=true
                    changeingredientbutton.enabled=true
                    deleteingredientbutton.enabled=true
                    receptlist.deleteingredient(ingrid.text)
                    receptlist.buildingredientlist()
                    if (receptlist.currentrecepyid !== -1){
                        receptlist.fillinlistsearch("", 0);
                        stackview.pop();
                        stackview.pop();
                        stackview.pop();
                        stackview.pop();
                        receptlist.currentrecepyid = -1
                    }
                    else
                        stackview.pop();

                }
            }
        }
    }
    ToastManager{ id: toastchangeingredient }
}




