#ifndef RECEPTLIST_H
#define RECEPTLIST_H

#include "ingredients.h"

#include <QObject>
#include <QWidget>
#include <QVariant>
#include <QList>
#include<QStandardPaths>
#include<QtSql/QSql>
#include<QtSql/QSqlDatabase>
#include <QtSql/QSqlQuery>
#include<QtSql/QSqlError>
#include <QDebug>

class ReceptList : public QObject
{
    Q_OBJECT
public:

    bool dropdbbool;
    bool connection;

    bool refreshrecepypage=true;
    int selectedingredientid;

    int currentrecepyid;
    QList<int> newrecepyids;
    QList<int> newrecepyamounts;

    QList<int> searchrecepyidsadd;
    QList<int> searchrecepyidsremove;
    QSqlDatabase db;
    QSqlQuery query;

    Ingredients *ingr;

    ReceptList();
    ~ReceptList();

signals:

    void createnewrecepyresult(QString addnewrecepyresult, bool ifdel, int rid);
    void filluplistresult(QString rname,int rid, QString ingredients,QString imgurl, int price);

    void filliningredients(QString ingrname);
    void fillinreppage(QString rname, QString rtext, QString ingredients,int favrec, int ident, QString imgurl, int price);
    void fillcombobox(QList<QString> ingredients);
    void switchdeftype(QString deftype);
    void newringredientanswer(QString ans);
    void printingredientlist(QList<int> ingrid,QList<QString> ingrnames,QList<QString> amtype, QList<int> ingrprice, QList<int>ingram);

    void addingredienttonewrecepylist(int ingredientid,QString ingredient,QString currenttype,int ingredientprice, int typeamountt);

    void addingrtosearchrecepyres(int ingredientid,QString ingredient,int son);
    void changerecepysignal();
    void changerecepynameandtext(QString rname,QString rtext,int recid, QString imglink);
    void clearrecepylist();
    void showconnection(bool con);
public slots:
    void sharerecepy(QString receptname, QString receptingredients, QString recepttext);
    void checkconnection();
    int initingred();
    void deleteingred();

    void builddefaultdb();
    void dropdb();
    void createnewrecepy(QString recepyname, QString recepytext,int rid, QString imagepath);

    void getreceptid(int receptid);
    void buildcombobox();
    void switcheddeftype(int currentIndex);
    void addnewingredient(QString ingridientname,QString defamount,int amprice);
    void buildingredientlist();

    void addingrtonewrecepy(QString ingredient, int typeamount ,QString currenttype);
    void deleteingredientfromnewrecepy(int ingredidd);

    void addingrtosearchrecepy(QString ingrname,int son);
    void deleteingredientfromsearchrecepy(int igredid,int son);
    void fillinlistsearch(QString searchinput, int favrecstate);
    void setfav(int recepyident, int idfavrecbutton);
    void changerecepybuildpage(int recepyident);
    void deleterecepy(int recepyident);
    void clearlists();
};

#endif // RECEPTLIST_H
