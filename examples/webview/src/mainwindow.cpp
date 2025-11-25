#include <QUrl>
#include <QWebEngineSettings>

#include "mainwindow.h"

MainWindow::MainWindow(const QUrl& url)
{
    view = new QWebEngineView(this);
    view->load(url);

    view->settings()->setAttribute(QWebEngineSettings::ShowScrollBars, false);

    setCentralWidget(view);
}

void MainWindow::loadPage(const QString &url)
{
    qWarning() << "Loading URL: " << url;
    view->load(QUrl(url));
}

void MainWindow::loadWebPImage(const QString &imagePath)
{
    QString fileUrl = "file://" + imagePath;
    qWarning() << "Loading WebP image: " << fileUrl;
    view->load(QUrl(fileUrl));
}
