#pragma once

#include <QMainWindow>
#include <QWebEngineView>

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    MainWindow(const QUrl& url);

public slots:
    void loadPage(const QString &url);
    void loadImage(const QString &imagePath);
    void loadImage2(const QString &imagePath);

private:
    QWebEngineView *view;
};
