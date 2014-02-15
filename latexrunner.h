#ifndef LATEXRUNNER_H
#define LATEXRUNNER_H

#include <QObject>
#include <QDebug>

class LatexRunner : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int dpi WRITE setDpi READ dpi NOTIFY dpiChanged)
    Q_PROPERTY(bool forceCompile WRITE setForceCompile READ forceCompile NOTIFY forceCompileChanged)

public:
    LatexRunner();

    int dpi() const
    {
        return m_dpi;
    }

    bool forceCompile() const
    {
        return m_forceCompile;
    }

public slots:
    QString createFormula(QString formula, QString color, bool centered);
    void setDpi(int arg)
    {
        qDebug() << "DPI Setting " << arg;
        if (m_dpi != arg) {
            m_dpi = arg;
            emit dpiChanged(arg);
        }
    }
    void setForceCompile(bool arg)
    {
        if (m_forceCompile != arg) {
            m_forceCompile = arg;
            emit forceCompileChanged(arg);
        }
    }

signals:
    void dpiChanged(int arg);

    void forceCompileChanged(bool arg);

private:
    int m_dpi;
    bool m_forceCompile;
};

#endif // LATEXRUNNER_H
