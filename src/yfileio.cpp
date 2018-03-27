#include "yfileio.h"
#include <QDebug>
#include <QDir>
YFileIO::YFileIO(QObject *parent) : QObject(parent)
{
    qDebug() << "YFileIO()";
}

YFileIO::~YFileIO()
{
    qDebug() << "~YFileIO()";
}

QString
YFileIO::getCurrentDir()
{
    return QDir::currentPath();
}
