#ifndef YFILEIO_H
#define YFILEIO_H

#include <QObject>
#include <QSettings>

class YFileIO : public QObject
{
    Q_OBJECT
public:
    explicit YFileIO(QObject *parent = nullptr);
    ~YFileIO();

signals:

public slots:
    Q_INVOKABLE QString getCurrentDir();
    Q_INVOKABLE QString useInternalStorage();
    Q_INVOKABLE QString useExternalStorage();
    Q_INVOKABLE QString usePreviousStorage();

private:
    QSettings _settings;
    QString     _strIntStorage;
};

#endif // YFILEIO_H
