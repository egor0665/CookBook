#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "receptlist.h"
#include "imagepickerandroid.h"
#include "ingredients.h"
#include <QQmlContext>
#include <QApplication>
#include <QGraphicsObject>
#include<qquickview.h>
#include<qquickitem.h>

#include<QtSql/QSql>
#include<QtSql/QSqlDatabase>
#include <QtSql/QSqlQuery>
#include<QStandardPaths>

bool checkPermissions()
{
    bool success = true;
    if(QtAndroid::androidSdkVersion() >= 23)
    {
        static const QVector<QString> permissions({
            "android.permission.READ_EXTERNAL_STORAGE","android.permission.WRITE_EXTERNAL_STORAGE"
        });

        for(const QString &permission : permissions)
        {
            // check if permission is granded
            auto result = QtAndroid::checkPermission(permission);
            if(result != QtAndroid::PermissionResult::Granted)
            {
                // request permission
                auto resultHash = QtAndroid::requestPermissionsSync(QStringList({permission}));
                if(resultHash[permission] != QtAndroid::PermissionResult::Granted)
                {
                    qDebug() << "Fail to get permission" << permission;
                    success = false;
                }
                else
                {
                    qDebug() << "Permission" << permission << "granted!";
                }
            }
            else
            {
                qDebug() << "Permission" << permission << "already granted!";
            }
        }
    }
    return success;
}

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    QGuiApplication app(argc, argv);
    bool getperm=false;
    while(!getperm) getperm=checkPermissions();

    //--------------------
    ReceptList receptlist;
    ImagePickerAndroid imagepickerandroid;

    receptlist.searchrecepyidsadd.clear();
    receptlist.searchrecepyidsremove.clear();
    QQmlApplicationEngine engine;

    QQmlContext *context = engine.rootContext();
    context->setContextProperty("imagepickerandroid", &imagepickerandroid);
    context->setContextProperty("receptlist", &receptlist);

    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);



    return app.exec();
}
