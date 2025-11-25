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
    void loadWebPImage(); // Let's show a specific image for now.

private:
    QWebEngineView *view;
};
