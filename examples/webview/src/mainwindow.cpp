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

void MainWindow::loadWebPImage()
{
    // Let's use a sample WebP image locally.
    QString imagePath = "file:///app/sample.webp";
    qWarning() << "Loading WebP image: " << imagePath;
    view->load(QUrl(imagePath));
}
