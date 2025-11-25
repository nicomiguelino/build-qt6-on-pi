#include <QUrl>
#include <QWebEngineSettings>
#include <QImage>
#include <QImageReader>
#include <QFileInfo>
#include <QPainter>
#include <QLabel>

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

void MainWindow::loadImage(const QString &imagePath)
{
    QString fileUrl = "file://" + imagePath;
    qWarning() << "Loading image: " << fileUrl;
    view->load(QUrl(fileUrl));
}

void MainWindow::loadImage2(const QString &imagePath)
{
    qWarning() << "loadImage2: Loading image from path: " << imagePath;
    
    QFileInfo fileInfo(imagePath);
    if (!fileInfo.exists()) {
        qWarning() << "loadImage2: File does not exist: " << imagePath;
        return;
    }
    if (!fileInfo.isReadable()) {
        qWarning() << "loadImage2: File is not readable: " << imagePath;
        qWarning() << "loadImage2: File permissions: " << QString::number(fileInfo.permissions(), 16);
        return;
    }
    
    qWarning() << "loadImage2: File exists and is readable. Size: " << fileInfo.size() << " bytes";
    
    QImageReader reader(imagePath);
    if (!reader.canRead()) {
        qWarning() << "loadImage2: QImageReader cannot read the file";
        qWarning() << "loadImage2: Format: " << reader.format();
        qWarning() << "loadImage2: Error: " << reader.errorString();
        qWarning() << "loadImage2: Supported formats: " << QImageReader::supportedImageFormats();
        return;
    }
    
    QImage image = reader.read();
    if (image.isNull()) {
        qWarning() << "loadImage2: Failed to load image from path: " << imagePath;
        qWarning() << "loadImage2: QImageReader error: " << reader.errorString();
        return;
    }
    
    qWarning() << "loadImage2: Image loaded successfully. Size: " << image.size();
    
    QLabel *label = new QLabel(this);
    label->setPixmap(QPixmap::fromImage(image));
    label->setScaledContents(true);
    
    qWarning() << "loadImage2: Setting label as central widget";
    setCentralWidget(label);
}

