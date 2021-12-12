QT += quick \
    widgets \
    sql \
    androidextras \
    network

CONFIG += c++11

android: include(android_openssl-master/openssl.pri)

# You can make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
        imagepickerandroid.cpp \
        ingredients.cpp \
        main.cpp \
        receptlist.cpp

RESOURCES += qml.qrc \
            logo2.png \
            defaultrecepyimg.png \
            fav.png \
            notfav.png \
            menu.png \
            back.png \
            AppPage.qml \
            FindRecepy.qml \
            Recepy.qml \
            ChangeIngredient.qml \
            AppButton.qml

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    imagepickerandroid.h \
    ingredients.h \
    receptlist.h

DISTFILES += \
    android-sources/AndroidManifest.xml

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android-sources
