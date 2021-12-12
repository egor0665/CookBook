import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.0

Window {
    Connections {
        target: receptlist
        onShowconnection:{
            if( con ){
                buttonFindRecepy.visible=true
                buttonAddRecepy.visible=true
                buttonDropDB.visible=true
                messageboxconnection.visible=false
            }
            else{
                buttonFindRecepy.visible=false
                buttonAddRecepy.visible=false
                buttonDropDB.visible=false
                messageboxconnection.visible=true
                toastmenu.show("Отсутствует соединение с сетью")
            }
        }
    }
    property int varchangerecepy: 0
    id:window
    visible: true
    StackView{
        id:stackview
        initialItem: pagemenu
    }
    //---------------------------------------------------------------------------
    //------------------------------MENU-----------------------------------------
    //---------------------------------------------------------------------------
    AppPage{
        id:pagemenu
        Rectangle{
            id:topmenubar
            color:"#FFBA5C"
            anchors.top:parent.top
            anchors.left:parent.left
            width:parent.width
            height:50
            AppButton{
                height: 30
                anchors.verticalCenter: parent.verticalCenter
                leftPadding: 5
            }
            Label{
                anchors.verticalCenter: parent.verticalCenter
                anchors.left:parent.left
                leftPadding: 50
                text:"Меню"
                color:"#ef4a4a45"
                font.pointSize: 20
            }
        }
        Image {
            id: mainmenuimage
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top:topmenubar.bottom
            fillMode: Image.PreserveAspectFit
            width: parent.width
            source: "logo2.png"
        }

        Column {
            anchors.top:mainmenuimage.bottom
            anchors.topMargin: 60
            topPadding: 20
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width-150
            height: 200
            spacing: 10

            AppButton{
                id: buttonFindRecepy
                width:parent.width
                height:50
                onClicked:{
                    receptlist.fillinlistsearch("", 0)
                    receptlist.currentrecepyid = -1
                    receptlist.buildcombobox()
                    stackview.push(pagefindrecepy)
                }
                Label{
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    text: "Подобрать рецепт"
                    color:"#ef4a4a45"
                }
            }
            AppButton{
                id: buttonAddRecepy
                width:parent.width
                height:50
                onClicked:{
                    receptlist.currentrecepyid=-1
                    receptlist.buildcombobox()
                    stackview.push(pageaddrecepy)
                }
                Label{
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    text: "Добавить рецепт"
                    color:"#ef4a4a45"
                }
            }
            AppButton{
                id: buttonDropDB
                width:parent.width
                height:50
                onClicked:{
                    messageboxdropdb.visible=true
                    buttonAddRecepy.enabled=false
                    buttonFindRecepy.enabled=false
                    buttonDropDB.enabled=false
                }
                Label{
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    text: "Удалить рецепты"
                    color:"#ef4a4a45"
                }
            }
        }
        Label{
            anchors.bottom:parent.bottom
            anchors.right:parent.right
            text:"Курсовая работа Студента ИУ6-51Б Галанцева Егора"
            font.pointSize: 8
            //font.family: "Roboto"
            color:"#ef4a4a45"
            width:200
            height:20
        }

    }
    //---------------------------------------------------------------------------
    //------------------------------FIND RECEPY ---------------------------------
    //---------------------------------------------------------------------------
    FindRecepy{
        id:pagefindrecepy
    }
    //---------------------------------------------------------------------------
    //------------------------------RECEPY---------------------------------------
    //---------------------------------------------------------------------------
    Recepy{
        id:pagerecepy
    }
    //---------------------------------------------------------------------------
    //------------------------------ADD RECEPY-----------------------------------
    //---------------------------------------------------------------------------
    AddRecepy{
        id:pageaddrecepy
    }
    //---------------------------------------------------------------------------
    //------------------------------NEW INGREDIENT ------------------------------
    //---------------------------------------------------------------------------
    NewIngredient{
        id:pagenewingredient
    }
    //---------------------------------------------------------------------------
    //------------------------------CHANGE INGREDIENT----------------------------
    //---------------------------------------------------------------------------
    ChangeIngredient{
        id:pagechangeingredient
    }
    Rectangle{
        radius:10
        border.color : "#FFBA5C"
        border.width : 1
        visible:false
        id:messageboxdropdb
        height:120
        width:parent.width-40
        anchors.horizontalCenter: parent.horizontalCenter
        y:300
        Label{
            anchors.margins: 10
            id:messageboxlabel
            width:parent.width-20
            height:60
            font.pointSize: 16
            font.family: "Verdana"
            text:"Вы действительно хотите удалить добавленные рецепты?"
            color:"#ef4a4a45"
            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignLeft
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
        }
        AppButton{
            anchors.leftMargin: 5
            anchors.bottomMargin: 5
            anchors.top:messageboxlabel.bottom
            anchors.left:parent.left
            font.family: "Verdana"

            contentItem: Text {
                text:"Отмена"
                font.pointSize: 16
                color:"#ef4a4a45"
            }

            onClicked: {
                buttonAddRecepy.enabled=true
                buttonFindRecepy.enabled=true
                buttonDropDB.enabled=true
                messageboxdropdb.visible=false
            }
        }
        AppButton{
            anchors.rightMargin: 5
            anchors.bottomMargin: 5
            font.family: "Verdana"
            anchors.top:messageboxlabel.bottom
            anchors.right:parent.right
            contentItem: Text {
                text:"Очистить"
                font.pointSize: 16
                color:"#ef4a4a45"
            }
            onClicked: {
                buttonAddRecepy.enabled=true
                buttonFindRecepy.enabled=true
                buttonDropDB.enabled=true
                messageboxdropdb.visible=false
                receptlist.dropdb()
                toastmenu.show("Данные были очищены")
            }
        }

    }
    Rectangle{
        radius:10
        border.color : "#FFBA5C"
        border.width : 1
        visible:false
        id:messageboxconnection
        height:80
        width:parent.width-40
        anchors.horizontalCenter: parent.horizontalCenter
        y:300
        Label{
            anchors.margins: 10
            height:50
            font.pointSize: 16
            font.family: "Verdana"
            text:"Повторить попытку подключения?"
            color:"#ef4a4a45"
            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignLeft
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
        }
        AppButton{
            anchors.bottomMargin: 5
            anchors.bottom:parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            font.family: "Verdana"
            contentItem: Text {
                text:"Повторить"
                font.pointSize: 16
                color:"#ef4a4a45"
            }
            onClicked: {
                receptlist.initingred()
            }
        }

    }
    ToastManager{
        onVisibleChanged: receptlist.checkconnection()
        id: toastmenu
        Component.onCompleted: receptlist.checkconnection()
    }
}
