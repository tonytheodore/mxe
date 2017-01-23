/*
 * This file is part of MXE. See LICENSE.md for licensing information.
 */

#include <QApplication>

// qmake automatically includes static plugin support
#ifdef NON_QMAKE_BUILD
#include <QtPlugin>
Q_IMPORT_PLUGIN(QWindowsIntegrationPlugin)
Q_IMPORT_PLUGIN(QICOPlugin)
#endif

#include "qt-test.hpp"

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    MainWindow w;
    w.show();
    a.aboutQt();
    return a.exec();
}
