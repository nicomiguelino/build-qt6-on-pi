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
