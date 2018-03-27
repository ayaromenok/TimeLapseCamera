#ifndef YFILEIO_H
#define YFILEIO_H

#include <QObject>

class YFileIO : public QObject
{
    Q_OBJECT
public:
    explicit YFileIO(QObject *parent = nullptr);
    ~YFileIO();

signals:

public slots:
    Q_INVOKABLE QString getCurrentDir();
};

#endif // YFILEIO_H
