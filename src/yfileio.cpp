#include "yfileio.h"
#include <QDebug>
#include <QDir>
#include <QStringList>
#include <QDateTime>

YFileIO::YFileIO(QObject *parent) : QObject(parent)
{
    qDebug() << "YFileIO()";
    _strIntStorage.append("/storage/emulated/0/DCIM");
    _strAppName.append("ZeitrafferCamera");
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
    QString camDir(_strIntStorage);
    if (dir.cd(camDir)){
        camDir.append("/"+_strAppName);
        dir.setPath(camDir);
        if (!dir.exists()){
            qDebug() << "creating dir"<<camDir;
            dir.mkpath(camDir);
        }

        _settings.setValue("path/current",camDir);
        return camDir;
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
            if (list.at(i).fileName().contains(_strIntStorage) ||
                    list.at(i).fileName().contains("/storage/.") ){
                qDebug() << "this is a Internal storage, skipping";
            } else {
                camDir.clear();
                camDir.append("/storage/");
                camDir.append(list.at(i).fileName());

                camDir.append("/DCIM");
                dirStorage.setPath(camDir);                
                if (dirStorage.exists()){
                    camDir.append("/"+_strAppName);
                    dirStorage.setPath(camDir);
                    if (!dirStorage.exists()){
                        qDebug() << "creating dir"<<camDir;
                        if (dirStorage.mkpath(camDir))
                            qDebug() << "dir OK" << camDir;
                        else
                            qDebug() << "dir ERROR" << camDir;
                    }
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

QString
YFileIO::getCurrentDateTime()
{
    QDateTime dt;
    return (dt.currentDateTime()).toString("yyMMdd_HHmmss");
}

QString
YFileIO::getDateTimeDir()
{
    QDir dir;
    QString strDir(usePreviousStorage());
    strDir.append("/"+getCurrentDateTime());
    dir.setPath(strDir);
    dir.mkpath(strDir);
    if (!dir.exists()){
        //use root camera dir
        strDir.clear();
        strDir.append(usePreviousStorage());
    }
    qDebug() << "cur date/time dir" << strDir;
    return strDir;
}
