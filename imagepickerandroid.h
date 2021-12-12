#ifndef IMAGEPICKERANDROID_H
#define IMAGEPICKERANDROID_H

#include <QMainWindow>
#include <QObject>
#include <QWidget>
#include <QtAndroidExtras>
#include <QDebug>

class ImagePickerAndroid : public QObject, public QAndroidActivityResultReceiver
{
    Q_OBJECT
public:
    ImagePickerAndroid();
public slots:

    void selectimage();
    virtual void handleActivityResult(int receiverRequestCode, int resultCode, const QAndroidJniObject & data);

signals:
    void imagesignal(QString imagepath);
};

#endif // IMAGEPICKERANDROID_H
