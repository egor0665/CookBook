#include "ingredients.h"

#include <QFileInfo>

#include<QStandardPaths>

#include <QTextStream>

#include <qtextcodec.h>

#include <QDebug>

#include<qstring.h>

#include<cctype>

#include<vector>

#include<QtSql/QSql>

#include<QtSql/QSqlDatabase>

#include <QtSql/QSqlQuery>

#include<QtSql/QSqlError>

#include<qdir.h>

#include<QNetworkAccessManager>

#include<QNetworkReply>

#include<QJsonDocument>

#include<QJsonObject>

#include<QJsonArray>


Ingredients::Ingredients()
{
    m_networkManager = new QNetworkAccessManager(this);
    ready=false;
    m_networkReply = m_networkManager->get(QNetworkRequest(QUrl("https://cookbook-6db98-default-rtdb.europe-west1.firebasedatabase.app/ingredient.json")));
    connect(m_networkReply, &QNetworkReply::readyRead, this, &Ingredients::networkReplyReadyRead );
    qDebug()<<"answer1";
}

void Ingredients::networkReplyReadyRead(){
    qDebug()<<"answer2";
    QString strReply = (QString)m_networkReply->readAll();
    QJsonDocument jsonResponse = QJsonDocument::fromJson(strReply.toUtf8());
    qDebug()<<jsonResponse;
    QJsonObject jsonObject = jsonResponse.object();
    items.clear();
    qDebug()<<jsonObject;
    qDebug()<<jsonObject.value("ingredient");
    for (auto value: jsonObject.value("ingredient").toObject()) {
        qDebug()<<"passed";
        QJsonObject data = value.toObject();
        qDebug()<<data;
        if (data.value("id").toInt()!=0){
            qDebug()<<data.value("id").toInt()<<data.value("iname").toString();
            ingredient a(data.value("id").toInt(),data.value("iname").toString(),data.value("price").toInt(),data.value("amount").toInt(),data.value("amtype").toString());
            items.emplace(data.value("id").toInt(), a);
        }
    }
    qDebug()<<"answer3";
    for (auto item:items){
         qDebug()<< item.second.iname<<"\n";
    }
    qDebug()<<"answer4";
    ready=true;
    return;
}

void Ingredients::addnewingredient(QString ingridientname, QString defamount, int amprice, int id){
    ready=false;
    m_networkPostManager = new QNetworkAccessManager(this->parent());
    QNetworkRequest request(QUrl("https://cookbook-6db98-default-rtdb.europe-west1.firebasedatabase.app/ingredient/ingredient.json"));
    request.setHeader(QNetworkRequest::ContentTypeHeader, QVariant("application/json"));
    int amount;
    if (defamount=="шт.")amount=1;
    else amount=100;
    QJsonObject ingred;
    ingred["id"]=id;
    ingred["iname"]=ingridientname;
    ingred["price"]=amprice;
    ingred["amount"]=amount;
    ingred["amtype"]=defamount;
    QJsonDocument doc(ingred);
    qDebug() << doc;
    QByteArray data = doc.toJson();
    qDebug()<< data;
    m_networkPostReply = m_networkPostManager->post(request, data);
    connect(m_networkPostReply, &QNetworkReply::readyRead, this, &Ingredients::networkPostReplyReadyRead );
}

void Ingredients::networkPostReplyReadyRead(){
    ready=true;
}

Ingredients::~Ingredients(){
    m_networkManager->deleteLater();
    m_networkPostManager->deleteLater();
    m_networkPostReply->deleteLater();
    m_networkReply->deleteLater();
}
