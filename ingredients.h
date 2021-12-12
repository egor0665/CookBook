#ifndef INGREDIENTS_H
#define INGREDIENTS_H

#include <QMainWindow>
#include <QObject>
#include <QWidget>
#include<QNetworkAccessManager>
#include<QNetworkReply>

class ingredient{
public:
    int id;
    QString iname;
    int price;
    int amount;
    QString amtype;
    ingredient(int idi, QString inamei, int pricei, int amounti, QString amtypei){
        id = idi;
        iname = inamei;
        price = pricei;
        amount = amounti;
        amtype = amtypei;
    }
};

class Ingredients: public QObject
{
    Q_OBJECT
public:
    bool ready;
    Ingredients();
    void addnewingredient(QString ingridientname, QString defamount, int amprice, int id);
    std::map <int,ingredient> items;
    ~Ingredients();
public slots:
    void networkReplyReadyRead();
    void networkPostReplyReadyRead();
private:
    QNetworkAccessManager * m_networkManager;
    QNetworkAccessManager * m_networkPostManager;
    QNetworkReply * m_networkReply;
    QNetworkReply * m_networkPostReply;
    //QNetworkRequest * request;
};

#endif // INGREDIENTS_H
