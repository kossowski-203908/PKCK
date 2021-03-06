<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" version="1.0">
    <xsl:output method="xml" encoding="utf-8"
		doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"
		doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
		omit-xml-declaration="no" indent="yes"/>

    <xsl:template match="/księgarnia">
        <html xmlns="http://www.w3.org/1999/xhtml">
            <head>
                <meta http-equiv="content-type" content="application/xhtml+xml; charset=utf-8" />
                <title>Ksiegarnia</title>
                
                <style type="text/css" >
                    body {
                        margin: 0 50px;
                        padding: 20px 0;
                        background: white;
                        font-family: sans-serif, monospace;
                        overflow-x: hidden;
                    }
                    
                    h3 {
                        margin-top: 50px;
                    }
                    
                    p {
                        margin: 5px 0;
                    }
                    
                    .main-list {
                        padding: 0;
                        list-style-position: inside
                    }
                    
                    .main-list li {
                        margin-bottom: 10px;
                        font-size: 20px;
                    }
                    
                    .main-list li a {
                        text-transform: uppercase;
                    }
                    
                    table {
                        width: 100%;
                        text-align: center;
                    }
                    
                    table th {
                        background-color: lightskyblue;
                    }
                    
                    table tr:nth-child(2n) {
                        background-color: #eee;
                    }
                    
                    table th:first-letter {
                        text-transform: uppercase;
                    }
                    
                    table td, table th{
                        padding: 10px 0;
                    }
                    
                    .table-container {
                        display: flex;
                    }
                    
                    .table-small {
                        width: 30%;
                        margin-right: 40px;
                    }
                </style>
            </head>
            
            <body>
                <h1>Księgarnia</h1>
                <h2>W pliku znajdują się następujące sekcje:</h2>
                <ol class="main-list">
                    <xsl:for-each select="*">
                        <li>
                            <a href="#{generate-id(.)}">
                                <xsl:value-of select="name(.)" />
                            </a>
                        </li>
                    </xsl:for-each>
                </ol>
                
                <xsl:apply-templates />

            </body>
        </html>
    </xsl:template>
    
    <xsl:template match="/księgarnia/twórcy">
        <h3 id="{generate-id(.)}">Twórcy dokumentu</h3>
        <ul>
            <xsl:for-each select="twórca">
                <li>
                    <p style="font-weight: bold">
                        <xsl:value-of select="imię"/>&#160;<xsl:value-of select="nazwisko"/>
                    </p>
                    <p>Semestr: <xsl:value-of select="semestr"/></p>
                    <p>Nr indeksu: <xsl:value-of select="indeks"/></p>
                    <p>Kontakt:</p>
                    <ul>
                        <xsl:for-each select="kontakt/*">
                            <li><xsl:value-of select="."/></li>
                        </xsl:for-each>
                    </ul>
                </li>
            </xsl:for-each>
        </ul>
    </xsl:template>
    
    <xsl:template match="/księgarnia/książki">
        <h3 id="{generate-id(.)}">Lista książek</h3>
        <table>
            <caption>Wszystkie ceny wyrażone są w PLN.</caption>
            <thead>
                <tr>
                    <xsl:for-each select="książka[1]/*">
                        <th>
                            <xsl:value-of select="name(.)" />
                        </th>
                    </xsl:for-each>
                </tr>
            </thead>
            <tbody>
                <xsl:for-each select="książka">
                    <tr>
                        <td>
                            <xsl:value-of select="tytuł"/>
                        </td>
                        <td>
                            <xsl:apply-templates select="autorzy"/>
                        </td>
                        <td>
                            <xsl:value-of select="język"/>
                        </td>
                        <td>
                            <xsl:value-of select="dział"/>
                        </td>
                        <td>
                            <xsl:value-of select="rok-wydania"/>
                        </td>
                        <td>
                            <xsl:value-of select="format-number(cena, '#.00####')"/>
                        </td>
                    </tr>
                </xsl:for-each>
            </tbody>
        </table>
    </xsl:template>
    
    <xsl:template match="/księgarnia/książki/książka/autorzy">
        <xsl:choose>
            <xsl:when test="autor">
                <xsl:for-each select="autor">
                    <span style="display: block;">
                        <xsl:value-of select="imię"/>&#160;<xsl:value-of select="nazwisko"/>
                    </span>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <span>Praca zbiorowa</span>
            </xsl:otherwise>
        </xsl:choose>  
    </xsl:template>
    
    <xsl:template match="/księgarnia/działy">
        <h3 id="{generate-id(.)}">Działy</h3>
        <table class="table-small">
            <caption>Tabela działów z przypisanym im ID</caption>
            <thead>
                <tr>
                    <xsl:for-each select="definicja-działu[1]/*">
                        <th>
                            <xsl:value-of select="name(.)" />
                        </th>
                    </xsl:for-each>
                </tr>
            </thead>
            <tbody>
                <xsl:for-each select="definicja-działu">
                    <tr>
                        <td>
                            <xsl:value-of select="id"/>
                        </td>
                        <td>
                            <xsl:value-of select="nazwa"/>
                        </td>
                    </tr>
                </xsl:for-each>
            </tbody>
        </table>
    </xsl:template>
    
    <xsl:template match="/księgarnia/statystyki">
        <h3 id="{generate-id(.)}">Statystyki</h3>
        <h4>Statystyki zostały wygenerowane na podstawie powyższych wyników.</h4>
        <p>
            <span>Liczba wszystkich książek w bibliotece: </span>
            <span style="color: red;">
                <xsl:value-of select="ilość-książek/wszystkie"/>
            </span>
        </p>
        
        <p style="margin-bottom: 20px;">
            <span>Liczba książek z bieżącego roku: </span>
            <span style="color: red;">
                <xsl:value-of select="ilość-książek/bieżacy-rok"/>
            </span>
        </p>
        
        <div class="table-container">
            <xsl:call-template name="stat-table">
                <xsl:with-param name="caption" select="'Liczby książek w poszczególnych językach'" />
                <xsl:with-param name="content" select="ilość-książek/język" />
            </xsl:call-template>

            <xsl:call-template name="stat-table">
                <xsl:with-param name="caption" select="'Liczby książek z poszczególnych działów'" />
                <xsl:with-param name="content" select="ilość-książek/dział" />
            </xsl:call-template>
        </div>
    </xsl:template>
    
    
    <xsl:template name="stat-table">
        <xsl:param name="caption" />
        <xsl:param name="content" />
        
        <table class="table-small">
            <caption><xsl:value-of select="$caption" /></caption>
            <thead>
                <tr>
                    <th>Język</th>
                    <th>Ilość</th>
                </tr>
            </thead>
            <tbody>
                <xsl:for-each select="$content/*">
                    <tr>
                        <td>
                            <xsl:value-of select="name(.)" />
                        </td>
                        <td>
                            <xsl:value-of select="." />
                        </td>
                    </tr>
                </xsl:for-each>
            </tbody>
        </table>
    </xsl:template>

</xsl:stylesheet>