#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "yfileio.h"
#include <QDebug>

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QCoreApplication::setOrganizationName("Andrey Yaromenok");
    QCoreApplication::setOrganizationDomain("yaromenok.info");
    QCoreApplication::setApplicationName("TimeLapse Camera");

    QGuiApplication app(argc, argv);

/*    YFileIO yf;
    qDebug() << "current dir" << yf.getCurrentDir();
    qDebug() << "use Int Dir" << yf.useInternalStorage();
    qDebug() << "use Ext Dir" << yf.useExternalStorage();
    qDebug() << "use Prev Dir" << yf.usePreviousStorage()*/;

    qmlRegisterType<YFileIO> ("FileIO", 1, 0, "FileIO");

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
