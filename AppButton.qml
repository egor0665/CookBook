import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.0

Button {
    font.pointSize: 20
    font.family: "Roboto"
    background: Rectangle{
        color: "#FFBA5C"
        radius: 100
        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 5
            verticalOffset: 5
            color: "#000000"
        }
    }
}
