#include "receptlist.h"

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

#include <qapplication.h>
#include <qcoreapplication.h>
#include<qdir.h>
#include<QClipboard>

void ReceptList::sharerecepy(QString receptname, QString receptingredients, QString recepttext){
    QClipboard *clipboard = QApplication::clipboard();
    clipboard->clear();
    QString recepy = receptname + "\n\n" + receptingredients + "\n" + recepttext + "\n\n" + "by CookBook";
    clipboard->setText(recepy);
}

void ReceptList::changerecepybuildpage(int recepyident) {
    QSqlQuery query(db);
    query.exec("SELECT RC.rname, RC.rtext, TMP.amount, TMP.iid, RC.imgurl FROM recepy RC, tmp TMP WHERE RC.id=TMP.rid AND RC.id=" + QString::number(recepyident));
    qDebug() << query.lastError().text();
    QString rname = "";
    QString rtext = "";
    int t0 = 0;
    int t1 = 0;

    QString t2 = "";
    int t3 = 0;
    int t4 = 0;
    QString t5 = "";

    QString t6 = "";

    newrecepyamounts.clear();
    newrecepyids.clear();
    while (query.next()) {
        if (rname == "") {
            rname = query.value(0).toString();
            rtext = query.value(1).toString();
        }
        t0 = query.value(2).toInt();
        t1 = query.value(3).toInt();
        t2 = ingr->items.find(t1)->second.iname;
        t3 = ingr->items.find(t1)->second.price;
        t4 = ingr->items.find(t1)->second.amount;
        t5 = ingr->items.find(t1)->second.amtype;
        t6 = query.value(4).toString();
        newrecepyids.append(t1);
        newrecepyamounts.append(t0);
        float x = (float) t0 / t4 * t3;
        int ingredientprice = (int) x;
        emit addingredienttonewrecepylist(t1, t2, t5, ingredientprice, t0);
    }
    emit changerecepynameandtext(rname, rtext, recepyident, t6);
}

void ReceptList::fillinlistsearch(QString searchinput, int favrecstate) {
    clearrecepylist();
    QSqlQuery query(db);
    qDebug() << favrecstate; //AND RC.rname LIKE '%"+searchinput+"%'


    QString sqlexec = "SELECT RC.id, RC.rname, TMP.iid, RC.imgurl, RC.price FROM recepy RC, tmp TMP WHERE";
    if (favrecstate) sqlexec.append(" RC.favrec=1 AND" );
    for (int i = 0; i < searchrecepyidsadd.length(); i++) {
        qDebug() << "in";
        sqlexec.append(" RC.id in (SELECT rid FROM tmp WHERE iid = "+QString::number(searchrecepyidsadd[i])+") AND ");
    }

    QString ingredremove="(";
    for (int i = 0; i < searchrecepyidsremove.length(); i++) {
        if (i!=0) ingredremove.append(", ");
        ingredremove.append(QString::number(searchrecepyidsremove[i]));
    }
    ingredremove.append(")");
    sqlexec.append(" RC.id not in (SELECT rid from tmp where iid in "+ingredremove+")AND TMP.rid = RC.id AND RC.rnamelower LIKE '%" + searchinput.toLower() + "%' COLLATE NOCASE");
    qDebug()<<sqlexec;
    query.exec(sqlexec);
    qDebug() << query.lastError().text();
    //RC.id, RC.rname, TMP.iid, RC.imgurl, RC.price
    int prevrecid = -1;
    QString t2 = "";
    int t3 = 0;
    QString t4 = "";
    int t5;
    QString ingred;
    int t1;
    int prevt1=0;
    QString imgurl = "defaultrecepyimg.png";
    while (query.next()) {
        qDebug() << "found";
        t1 = query.value(0).toInt();
        if (prevrecid != t1) {
            //QString rname,int rid, QString ingredients,QString imgurl, int price);
            if (prevrecid != -1) emit filluplistresult(t2, prevt1, ingred, t4, t5);
            ingred.clear();
            t2 = query.value(1).toString();
            t3 = query.value(2).toInt();
            t4 = query.value(3).toString();
            t5 = query.value(4).toInt();
            ingred += ingr->items.find(t3)->second.iname + " ";
            prevrecid = t1;
        } else {
            t3 = query.value(2).toInt();
            ingred += ingr->items.find(t3)->second.iname + " ";
        }
        qDebug() << t1 << t2 << t3 << t4 << t5;
        prevt1 = t1;
    }
    if (t2 != "")
        emit filluplistresult(t2, t1, ingred, t4, t5);
}


void ReceptList::addingrtosearchrecepy(QString ingrname, int son) {
    int t0;
    for (auto &item:ingr->items){
        //ingr->items.find(t1)->second.amount;
       if(item.second.iname==ingrname){
           t0 = item.first;
           break;
       }
    }
    for (int i = 0; i < searchrecepyidsadd.length(); i++) {
        if (searchrecepyidsadd[i] == t0) {
            qDebug() << "In list";
            return;
        }
    }
    for (int i = 0; i < searchrecepyidsremove.length(); i++) {
        if (searchrecepyidsremove[i] == t0) {
            qDebug() << "In list";
            return;
        }
    }
    if (son==1){
        searchrecepyidsadd.append(t0);
        addingrtosearchrecepyres(t0, ingrname, 1);
    }
    else{
        searchrecepyidsremove.append(t0);
        addingrtosearchrecepyres(t0, ingrname, -1);
    }
}





void ReceptList::addingrtonewrecepy(QString ingredient, int typeamount, QString currenttype) {
    if (typeamount < 1) {
        return;
    }
    int t0;
    for (auto &item:ingr->items){
       if(item.second.iname==ingredient){
           t0 = item.first;
           break;
       }
    }

    int t1 = ingr->items.find(t0)->second.price;
    int t3 = ingr->items.find(t0)->second.amount;
    for (int i = 0; i < newrecepyids.length(); i++) {
        if (newrecepyids[i] == t0) return;
    }
    newrecepyids.append(t0);
    newrecepyamounts.append(typeamount);
    float x = (float) typeamount / t3 * t1;
    int ingredientprice = (int) x;

    for (int i = 0; i < newrecepyids.length(); i++)
        qDebug() << newrecepyids[i] << newrecepyamounts[i];

    emit addingredienttonewrecepylist(t0, ingredient, currenttype, ingredientprice, typeamount);

}

void ReceptList::buildingredientlist() {
    int t0;
    QString t1;
    int t2;
    int t3;
    QString t4;
    QList < int > ingrid;
    QList < QString > ingrnames;
    QList < QString > amtype;
    QList < int > ingrprice;
    QList < int > ingram;
    for (auto &item:ingr->items){
        t0 = item.second.id;
        t1 = item.second.iname;
        t2 = item.second.price;
        t3 = item.second.amount;
        t4 = item.second.amtype;
        ingrid.append(t0);
        ingrnames.append(t1);
        amtype.append(t4);
        ingrprice.append(t2);
        ingram.append(t3);
        emit printingredientlist(ingrid, ingrnames, amtype, ingrprice, ingram);
    }
    emit printingredientlist(ingrid, ingrnames, amtype, ingrprice, ingram);
    return;

}
void ReceptList::addnewingredient(QString ingridientname, QString defamount, int amprice) {
    QSqlQuery query(db);
    if (ingridientname.isEmpty()) {
        emit newringredientanswer("Название не может быть пустым");
        return;
    }
    if (ingridientname.length() > 50) {
        emit newringredientanswer("Слишком длинное название");
        return;
    }
    bool charactersonly = true;
    for (int i = 0; i < ingridientname.length(); i++)
        if (!(ingridientname[i].isLetter() or ingridientname[i] == ' ')) charactersonly = false;
    if (!charactersonly) {
        emit newringredientanswer("Название может содержать только буквы и пробелы");
        return;
    }
    if (defamount.isEmpty()) {
        emit newringredientanswer("Некорректная единица");
        return;
    }
    if (amprice < 1) {
        emit newringredientanswer("Некорректная цена");
        return;
    }
    int maxid=-1;
    for (auto &item:ingr->items){
       if(item.second.iname==ingridientname){
           emit newringredientanswer("Ингредиент с таким именем уже существует");
           return;
       }
       if (item.second.id>maxid){
           maxid=item.second.id;
       }
    }
    ingr->addnewingredient(ingridientname, defamount, amprice, maxid+1);

    QTime time1 = QTime::currentTime().addSecs(3);
    while (!ingr->ready){
        QTime dieTime= QTime::currentTime().addSecs(1);
        while (QTime::currentTime() < dieTime)
            QCoreApplication::processEvents(QEventLoop::AllEvents, 1);
        qDebug()<<"waiting";
        if (time1 < QTime::currentTime()){
            connection=false;
            emit checkconnection();
            return;
        }
    }
    deleteingred();
    initingred();
    emit newringredientanswer("Ингредиент добавлен");

}
void ReceptList::buildcombobox() {
    qDebug()<<"buildingcombobox";
    QList < QString > ingred;
    for (auto &item:ingr->items){
         ingred.append(item.second.iname);
         qDebug()<< item.second.iname<<"\n";
    }
    for (auto &item:ingr->items){
        qDebug()<< item.second.iname<<"aaaaaaaaaaa\n";
    }
    emit fillcombobox(ingred);
}
void ReceptList::switcheddeftype(int currentIndex) {    
    qDebug()<<currentIndex;
    if(currentIndex!=0)
        emit switchdeftype(ingr->items.find(currentIndex)->second.amtype);
}
void ReceptList::getreceptid(int receptid) {
    QSqlQuery query(db);
    query.exec("SELECT RC.rname, RC.rtext, TMP.iid, RC.favrec, RC.imgurl, RC.price, TMP.amount FROM recepy RC, tmp TMP WHERE TMP.RID=RC.ID AND RC.id=" + QString::number(receptid));
    qDebug() << query.lastError().text();
    QString t1 = "";
    QString t2 = "";
    int t3 = 0;
    int t4 = 0;
    QString t5 = "";
    int t6=0;
    int t7=0;
    int t8=0;
    QString t9=0;
    int t10=0;
    QString ingred;
    while (query.next()) {
        t1 = query.value(0).toString();
        t2 = query.value(1).toString();
        t3 = query.value(2).toInt();
        t7 = query.value(6).toInt();
        t8 = ingr->items.find(t3)->second.price;
        t9 = ingr->items.find(t3)->second.amtype;
        t10 = ingr->items.find(t3)->second.amount;
        t4 = query.value(3).toInt();
        ingred += ingr->items.find(t3)->second.iname + " - " + QString::number(t7) + " " + t9+ " - " + QString::number(t8*t7/t10) + " руб.\n";
        t5 = query.value(4).toString();
        t6 = query.value(5).toInt();
    }
    qDebug() << t1 << ingred;
    emit fillinreppage(t1, t2, ingred, t4, receptid, t5, t6);
}


void ReceptList::createnewrecepy(QString recepyname, QString recepytext, int rid, QString imagepath) {
    if (recepyname.isEmpty()) {
        createnewrecepyresult("Введите название рецепта", false, rid);
        return;
    }
    if (recepytext.isEmpty()) {
        createnewrecepyresult("Введите текста рецепта", false, rid);
        return;
    }
    if (newrecepyids.isEmpty()) {
        createnewrecepyresult("Рецепт не может не иметь ингредиентов", false, rid);
        return;
    }
    QSqlQuery query(db);
    QString filenamestring="defaultrecepyimg.png";
    if (imagepath!="Default image" and imagepath!="defaultrecepyimg.png" and imagepath!="" ){
        QFileInfo fi(imagepath);
        QString filename= fi.fileName();
        QFile from(imagepath);
        QFile target(QStandardPaths::writableLocation(QStandardPaths::AppLocalDataLocation)+"/"+filename);
        qDebug()<<target.fileName();
        filenamestring = target.fileName();
        qDebug()<<target.fileName();
        if (target.exists())
            target.remove();
        if (target.error() != QFile::NoError)
            qDebug()<<from.errorString();
        qDebug()<<from.fileName();
        if(from.copy(filenamestring))
             qDebug() << "success";
        else
            qDebug()<<from.errorString();
        QFile f(filenamestring);
       qDebug() << from.errorString();
       filenamestring = "file://"+filenamestring;
    }

    if (rid != -1) {
        query.exec("SELECT id FROM recepy WHERE rname='" + recepyname + "' and id<>" + QString::number(rid));
        while (query.next()) {
            createnewrecepyresult("Рецепт с таким названием уже существует", false, rid);
            return;
        }
        query.exec("DELETE FROM tmp WHERE rid=" + QString::number(rid));
        qDebug() << query.lastError().text();
        for (int i = 0; i < newrecepyids.length(); i++) {
            query.exec("INSERT INTO tmp (rid, iid, amount) VALUES (" + QString::number(rid) + "," + QString::number(newrecepyids[i]) + "," + QString::number(newrecepyamounts[i]) + ");");
            qDebug() << query.lastError().text();
        }
        query.exec("SELECT iid, amount FROM tmp WHERE rid="+QString::number(rid));
        int t1;
        int t2;
        int t3;
        int t4;
        int curprice=0;
        while (query.next()) {
            t1 = query.value(0).toInt();
            t2 = query.value(1).toInt();
            t3 = ingr->items.find(t1)->second.amount;
            t4 = ingr->items.find(t1)->second.price;
            float x = (float) t2 / t3 * t4;
            curprice += (int) x;
        }
        query.exec("UPDATE recepy SET rtext='" + recepytext + "' WHERE id=" + QString::number(rid));
        query.exec("UPDATE recepy SET rname='" + recepyname + "' WHERE id=" + QString::number(rid));
        query.exec("UPDATE recepy SET imgurl='" + filenamestring + "' WHERE id=" + QString::number(rid));
        query.exec("UPDATE recepy SET rnamelower='" + recepyname.toLower() + "' WHERE id=" + QString::number(rid));
        query.exec("UPDATE recepy SET price='" + QString::number(curprice) + "' WHERE id=" + QString::number(rid));
        qDebug() << query.lastError().text();
    } else {
        query.exec("SELECT REC.id FROM recepy REC WHERE REC.rname='" + recepyname + "'");
        while (query.next()) {
            createnewrecepyresult("Рецепт с таким названием уже существует", false, rid);
            return;
        }
        query.exec("INSERT INTO recepy (favrec, imgurl, rname, rnamelower, rtext) VALUES (0, '" + filenamestring + "', '" + recepyname + "', '" + recepyname.toLower() + "', '" + recepytext + "');");
        qDebug() << query.lastError().text();
        query.exec("SELECT REC.id FROM recepy REC WHERE REC.rname='" + recepyname + "'");
        qDebug() << query.lastError().text();
        int t0;
        while (query.next())
            t0 = query.value(0).toInt();
        for (int i = 0; i < newrecepyids.length(); i++) {
            query.exec("INSERT INTO tmp (rid, iid, amount) VALUES (" + QString::number(t0) + "," + QString::number(newrecepyids[i]) + "," + QString::number(newrecepyamounts[i]) + ");");
            qDebug() << query.lastError().text();
        }
        query.exec("SELECT iid, amount FROM tmp WHERE rid="+QString::number(t0));
        int t1;
        int t2;
        int t3;
        int t4;
        int curprice=0;
        while (query.next()) {
            t1 = query.value(0).toInt();
            t2 = query.value(1).toInt();
            t3 = ingr->items.find(t1)->second.amount;
            t4 = ingr->items.find(t1)->second.price;
            float x = (float) t2 / t3 * t4;
            curprice += (int) x;
        }
        query.exec("UPDATE recepy SET price='" + QString::number(curprice) + "' WHERE id=" + QString::number(t0));

    }
    clearlists();
    fillinlistsearch("", 0);
    createnewrecepyresult("Успешно", true, rid);
    qDebug() << query.lastError().text();
}

ReceptList::ReceptList() {

    qDebug()<<"ofsafasfasf";
    currentrecepyid = -1;
    QString filePath = QStandardPaths::writableLocation(QStandardPaths::AppLocalDataLocation);
    QString fileName = "db.sqlite";
    filePath.append("/" + fileName);
    if (QFile::exists(filePath)) {
        qDebug()<<"DATABASE EXISTS"<<filePath;
        dropdbbool=false;
    }
    else {
        qDebug()<<"DATABASE DOESNT EXIST";
        dropdbbool=true;
    }
    db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName(filePath);
    if (!db.open())
        qDebug() << "problem opening db";
    else qDebug() << "we ok";
    qDebug()<<"answer init";
    if (initingred()==-1){
        return;
    }
}
int ReceptList::initingred(){
    connection=false;
    ingr = new Ingredients();
    qDebug()<<"answer ingred";
    QTime time1 = QTime::currentTime().addSecs(3);
    while (!ingr->ready){
        QTime dieTime= QTime::currentTime().addSecs(1);
        qDebug() << dieTime;
        while (QTime::currentTime() < dieTime)
            QCoreApplication::processEvents(QEventLoop::AllEvents, 1);
        qDebug()<<"waiting";
        if (time1 < QTime::currentTime()){
            connection=false;
            emit checkconnection();
            return -1;
        }
    }
    connection=true;
    if (dropdbbool) {
        dropdb();
        builddefaultdb();
    }
    emit checkconnection();
    return 1;
}
void::ReceptList::checkconnection(){
    qDebug()<<"checkconnection";
    emit showconnection(connection);
}
void ReceptList::deleteingred(){
    delete ingr;
    ingr = 0;
}

void ReceptList::builddefaultdb(){
    QString filePath = QStandardPaths::writableLocation(QStandardPaths::AppLocalDataLocation);
    QString fileName = "db.sqlite";
    filePath.append("/" + fileName);
    db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName(filePath);
    if (!db.open())
        qDebug() << "problem opening db";
    else qDebug() << "we ok";
    QSqlQuery query(db);
    query.exec("DROP TABLE IF EXISTS recepy");
    query.exec("DROP TABLE IF EXISTS tmp");
//    query.exec("DROP TABLE IF EXISTS ingredient");
    qDebug() << "rebuilding db";

    //создание
    query.exec("CREATE TABLE IF NOT EXISTS recepy(id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT DEFAULT 1 , rname TEXT NOT NULL, rtext TEXT NOT NULL, imgurl TEXT, rnamelower TEXT NOT NULL, favrec CHAR NOT NULL, price INTEGER);");
    qDebug() << query.lastError().text();
    query.exec("CREATE TABLE IF NOT EXISTS tmp(rid INTEGER NOT NULL, iid INTEGER NOT NULL, amount INTEGER);");

//    query.exec("CREATE TABLE IF NOT EXISTS ingredient(id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT DEFAULT 1 , iname TEXT NOT NULL, price INTEGER, amount integer, amtype TEXT);");

    //------------------
//    query.exec("INSERT INTO ingredient (iname, price, amount, amtype) VALUES ('Картофель', 8, 1, 'шт.');");

//    query.exec("INSERT INTO ingredient (iname, price, amount, amtype) VALUES ('Яйцо', 11, 1, 'шт.');");

//    query.exec("INSERT INTO ingredient (iname, price, amount, amtype) VALUES ('Масло растительное', 100, 1, 'шт.');");

    query.exec("INSERT INTO tmp (rid, iid, amount) VALUES (1,1,11);");

    query.exec("INSERT INTO tmp (rid, iid, amount) VALUES (1,2,2);");

    query.exec("INSERT INTO tmp (rid, iid, amount) VALUES (1,3,1);");

    query.exec("SELECT iid, AMOUNT FROM tmp WHERE TMP.rid=1");
    int t1;
    int t2;
    int t3;
    int t4;
    int curprice=0;
    while (query.next()) {
        t1 = query.value(0).toInt();
        t2 = query.value(1).toInt();
        t3 = ingr->items.find(t1)->second.amount;
        t4 = ingr->items.find(t1)->second.price;
        float x = (float) t2 / t3 * t4;
        curprice += (int) x;
    }
    query.exec("INSERT INTO recepy (price, favrec, imgurl, rname, rnamelower, rtext) VALUES ("+QString::number(curprice)+", 0, 'defaultrecepyimg.png', 'Картофельные драники', 'картофельные драники', 'Как приготовить драники (деруны):\nКартофель очищаем и натираем на крупной терке, сразу выкладываем на сито или дуршлаг. Отжимаем картофельный сок.\nДобавляем яйца, соль, перец.\nПеремешиваем.\nЖарим картофельные драники на среднем огне в достаточном количестве растительного масла до румяности с обеих сторон.\nПодаем картофельные драники со сметаной или с яблочным пюре.');");
    qDebug() << query.lastError().text();

    query.exec("INSERT INTO tmp (rid, iid, amount) VALUES (2,1,4);");

    query.exec("INSERT INTO tmp (rid, iid, amount) VALUES (2,3,1);");

    query.exec("SELECT iid, AMOUNT FROM tmp WHERE TMP.rid=2");
    curprice=0;
    while (query.next()) {
        t1 = query.value(0).toInt();
        t2 = query.value(1).toInt();
        t3 = ingr->items.find(t1)->second.amount;
        t4 = ingr->items.find(t1)->second.price;
        float x = (float) t2 / t3 * t4;
        curprice += (int) x;
    }
    query.exec("INSERT INTO recepy (price, favrec, imgurl, rname, rnamelower, rtext) VALUES ("+QString::number(curprice)+", 0, 'defaultrecepyimg.png','Картофель фри в домашних условиях','картофель фри в домашних условиях', 'Как приготовить картофель фри в домашних условиях:\nКартофель чистим и промываем. Нарезаем брусочками одинакового размера.\nЧтобы картофель был хрустящим, помещаем его в дуршлаг и промываем под струей холодной воды, чтобы удалить крахмал.\nВ кастрюлю вливаем растительное масло и разогреваем до 180-200 градусов. Постепенно небольшими порциями выкладываем картофель в масло. Масло очень горячее, поэтому будьте очень осторожны, чтобы не обжечься.\nЖарим картофель фри до золотистой корочки примерно 7-10 минут.\nПерекладываем картофель в миску и солим. Чтобы удалить лишний жир, выкладываем картофель на бумажную салфетку.\nДомашний картофель фри готов.\nПодавать картофель фри лучше всего с кетчупом.\nПриятного аппетита!');");
    qDebug() << query.lastError().text();
//    query.exec("INSERT INTO ingredient (iname, price, amount, amtype) VALUES ('Колбаса', 100, 100, 'гр.');");

//    query.exec("INSERT INTO ingredient (iname, price, amount, amtype) VALUES ('Сыр', 80, 100, 'гр.');");

    query.exec("INSERT INTO tmp (rid, iid, amount) VALUES (3,4,100);");

    query.exec("INSERT INTO tmp (rid, iid, amount) VALUES (3,5,100);");

    query.exec("INSERT INTO tmp (rid, iid, amount) VALUES (3,2,3);");

    query.exec("SELECT iid, AMOUNT FROM tmp WHERE TMP.rid=3");
    curprice=0;
    while (query.next()) {
        t1 = query.value(0).toInt();
        t2 = query.value(1).toInt();
        t3 = ingr->items.find(t1)->second.amount;
        t4 = ingr->items.find(t1)->second.price;
        float x = (float) t2 / t3 * t4;
        curprice += (int) x;
    }
    query.exec("INSERT INTO recepy (price, favrec, imgurl, rname, rnamelower, rtext) VALUES ("+QString::number(curprice)+", 0, 'defaultrecepyimg.png','Салат Ёжик', 'салат ёжик', 'Как приготовить салат Ежик:\nКолбасу нарезать кубиками.\nЯйца нарезать кубиками.\nСыр натереть на тёрке.\nСоединить колбасу, сыр, яйца и кукурузу.\nЧеснок выдавить через чеснокодавилку.\nВсе ингредиенты смешать и заправить салат Ежик майонезом.\nПриятного аппетита!');");
    qDebug() << query.lastError().text();
}

void ReceptList::clearlists(){
    newrecepyids.clear();
    newrecepyamounts.clear();
    searchrecepyidsadd.clear();
    searchrecepyidsremove.clear();
}

void ReceptList::setfav(int recepyident, int idfavrecbutton) {
    QSqlQuery query(db);
    query.exec("UPDATE recepy SET favrec='" + QString::number((idfavrecbutton + 1) % 2) + "' WHERE id=" + QString::number(recepyident));
    qDebug() << query.lastError().text();
}

void ReceptList::deleteingredientfromsearchrecepy(int ingredid, int son) {
    int i = 0;
    qDebug() << ingredid;
    if (son ==1){
        while (searchrecepyidsadd[i] != ingredid) i++;
        searchrecepyidsadd.removeAt(i);
    }
    else{
        while (searchrecepyidsremove[i] != ingredid) i++;
        searchrecepyidsremove.removeAt(i);
    }

}

void ReceptList::deleteingredientfromnewrecepy(int ingredidd) {
    int i = 0;
    qDebug() << ingredidd;
    while (newrecepyids[i] != ingredidd) i++;
    newrecepyids.removeAt(i);
    newrecepyamounts.removeAt(i);
}

void ReceptList::deleterecepy(int recepyident){
     QSqlQuery query(db);
     query.exec("SELECT imgurl FROM recepy WHERE id=" + QString::number(recepyident));
     QString t0="";
     while (query.next()) {
         t0=query.value(0).toString();
     }
     query.exec("DELETE FROM tmp WHERE rid=" + QString::number(recepyident));
     query.exec("DELETE FROM recepy WHERE id=" + QString::number(recepyident));
     query.exec("SELECT id FROM recepy WHERE imgurl="+t0);
     int recid=-1;
     while (query.next()) {
         recid=query.value(0).toInt();
     }
     if (t0!="defaultrecepyimg.png" and recid!=-1){
         QFile file (t0);
         file.remove();
     }

     qDebug() << query.lastError().text();
}

void ReceptList::dropdb(){
    QDir dir(QStandardPaths::writableLocation(QStandardPaths::AppLocalDataLocation));
    if (dir.exists(QStandardPaths::writableLocation(QStandardPaths::AppLocalDataLocation))) {
        Q_FOREACH(QFileInfo info, dir.entryInfoList(QDir::Files)) {
            qDebug()<< QFile::remove(info.absoluteFilePath());;
        }
    }
    builddefaultdb();
}

ReceptList::~ReceptList() {
    deleteingred();
    db.close();
    ingr->deleteLater();
}
