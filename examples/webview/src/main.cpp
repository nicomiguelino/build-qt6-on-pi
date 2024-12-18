#include <QApplication>
#include <QDBusConnection>

#include "mainwindow.h"

#define SERVICE_NAME "sandbox.webview"

int main(int argc, char * argv[])
{
    QApplication app(argc, argv);

    QString url_string = qgetenv("BROWSER_URL");
    QUrl url = url_string.isEmpty() ? QUrl("https://example.com") : QUrl(url_string);

    MainWindow *browser = new MainWindow(url);
    browser->resize(1920, 1080);
    browser->show();

    auto connection = QDBusConnection::sessionBus();

    if (!connection.isConnected()) {
        qWarning("Cannot connect to the D-Bus session bus.");
        return 1;
    }

    if (!connection.registerService(SERVICE_NAME)) {
        qWarning("Cannot register the D-Bus service: %s", SERVICE_NAME);
        return 1;
    }

    connection.registerObject("/", browser, QDBusConnection::ExportAllSlots);

    qDebug() << "Registered D-Bus service: " << SERVICE_NAME;

    return app.exec();
}
