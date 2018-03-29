#include "yfileio.h"
#include <QDebug>
#include <QDir>
#include <QStringList>
YFileIO::YFileIO(QObject *parent) : QObject(parent)
{
    qDebug() << "YFileIO()";
    _strIntStorage.append("/storage/emulated/0/DCIM");
    //_settings.setValue("path/current",QDir::currentPath());
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
    if (dir.cd(_strIntStorage)){
        _settings.setValue("path/current",_strIntStorage);
        return _strIntStorage;
    }
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
            if (list.at(i).fileName().contains(_strIntStorage)){
                qDebug() << "this is a Internal storage, skipping";
            } else {
                camDir.clear();
                camDir.append("/storage/");
                camDir.append(list.at(i).fileName());

                camDir.append("/DCIM");
                dirStorage.setPath(camDir);
                if (dirStorage.exists()){
                    _settings.setValue("path/current",camDir);
                    return camDir;
                }
            }
        }
    }
    return camDir;
}


QString
YFileIO::usePreviousStorage()
{
    QString result;
    if (_settings.value("path/current").toString().length() > 0){
        qDebug() << "prev storage"<< _settings.value("path/current",_strIntStorage).toString();
        result.append(_settings.value("path/current").toString());
    }
    else  {
        qDebug() << "fallback to default internal storage";
        result.append(useInternalStorage());
    }
    return result;
}

