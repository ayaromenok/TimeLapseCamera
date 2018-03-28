#include "yfileio.h"
#include <QDebug>
#include <QDir>
#include <QStringList>
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

QString
YFileIO::useInternalStorage()
{
    qDebug() << "useInternalStorage()";
    QDir dir;
    if (dir.cd("/storage/emulated/0/DCIM"))
        return "/storage/emulated/0/DCIM";
    return "false";
}

QString
YFileIO::useExternalStorage()
{
    qDebug() << "useExternalStorage()";
    QDir dirStorage("/storage");
    QString camDir("/storage/");
    if (!dirStorage.exists())
        return "false";
    else {
        QFileInfoList list = dirStorage.entryInfoList();
        for (int i=0; i<list.size(); i++){
            if (list.at(i).fileName().contains("/storege/0")){
                qDebug() << "this is a Internal storage, skipping";
            } else {
                camDir.clear();
                camDir.append("/storage/");
                camDir.append(list.at(i).fileName());

                camDir.append("/DCIM/Camera");
                dirStorage.setPath(camDir);
                if (dirStorage.exists()){
                    qDebug() << "Camera photoDir" << camDir;
                }
            }
        }
    }
    return camDir;
}
