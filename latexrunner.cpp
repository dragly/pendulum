#include "latexrunner.h"

#include <QCryptographicHash>
#include <QFileInfo>
#include <QDir>
#include <QFile>
#include <QDebug>

LatexRunner::LatexRunner() :
    m_dpi(600),
    m_forceCompile(false)
{
}

QString LatexRunner::createFormula(QString formula, QString color, bool centered)
{
    // TODO use QProcess instead of system()
    // TODO use Qt to create directories
    qDebug() << "Requested to create formula" << formula << "with dpi" << m_dpi;

    QString tmpDirName = "/tmp/latexpresentation/";
    QString baseFileData = formula + color + QString(centered) + QString(dpi());
    QString baseFileName = QCryptographicHash::hash(baseFileData.toLatin1(), QCryptographicHash::Md5).toHex();
    QString myFormulaFileName = tmpDirName + baseFileName + ".tex";

    QDir tempDir(tmpDirName);
    if(!tempDir.exists()) {
        QDir().mkdir(tmpDirName);
    }

    QString imageFileName = tmpDirName + baseFileName + ".svg";
    QFile imageFile(imageFileName);
    if(imageFile.exists() && !forceCompile()) {
        qDebug() << "Formula image exists. Using existing version.";
        return imageFileName;
    } else {
        qDebug() << "File does not exist. Creating...";
        QFile myFormulaFile(myFormulaFileName);
        myFormulaFile.open(QIODevice::WriteOnly | QIODevice::Text);
        myFormulaFile.write(formula.toUtf8());
        myFormulaFile.close();

        QString centerCommand = "";
        if(centered) {
            centerCommand = "\\def \\mycentered{} ";
        }
        QString latexCommand = "pdflatex --jobname formula \"" + centerCommand + "\\def \\mycolor{" + color + "} \\def \\myfile{" + myFormulaFileName + "} \\input{qml/pendulum/formula.tex}\"";
        qDebug() << latexCommand;
        qDebug() << system(latexCommand.toStdString().c_str());

//        QString convertCommand = QString("convert -trim -density %1 formula.pdf -quality 90 " + imageFileName);
//        qDebug() << convertCommand;
//        qDebug() << system(convertCommand.toStdString().c_str());
//        qDebug() << "Done creating formula.";
        QString convertCommand;
        qDebug() << system(convertCommand.toStdString().c_str());
        convertCommand = QString("inkscape --export-text-to-path --export-area-page --export-pdf=formula2.pdf formula.pdf");
        qDebug() << convertCommand;
        qDebug() << system(convertCommand.toStdString().c_str());
        convertCommand = QString("inkscape --export-text-to-path --export-area-page --export-plain-svg=" + imageFileName + " formula2.pdf");
        qDebug() << convertCommand;
        qDebug() << system(convertCommand.toStdString().c_str());
        qDebug() << "Done creating formula.";
    }
//    QString echoCommand = "echo '" + formula.toUtf8() + "' > " + myFormulaFileName;
//    qDebug() << echoCommand;
//    system(echoCommand.toStdString().c_str());

    return imageFileName;
}
