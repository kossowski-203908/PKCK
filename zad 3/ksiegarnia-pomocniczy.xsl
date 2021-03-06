<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output indent="yes" method="xml" encoding="utf-8" />

    <xsl:template match="/">
        <księgarnia>
            <xsl:apply-templates />
            
            <xsl:element name="statystyki">
                <xsl:call-template name="stat" />
            </xsl:element>
        </księgarnia>
    </xsl:template>

    <xsl:template match="/księgarnia/twórcy">
        <twórcy>
            <xsl:for-each select="twórca">
                <xsl:sort select="nazwisko"/>
                <xsl:copy-of select="." />
            </xsl:for-each>
        </twórcy>
    </xsl:template>
    
    <xsl:template match="/księgarnia/książki">
        <książki>
            <xsl:for-each select="książka">
                <xsl:sort select="dział/@id"/>

                <książka>
                    <xsl:attribute name="id">
                        <xsl:value-of select="@idKsiążki" />
                    </xsl:attribute>
                    <xsl:attribute name="dostępna">
                        <xsl:value-of select="@dostępna" />
                    </xsl:attribute>
                    
                    <tytuł>
                        <xsl:value-of select="tytuł"/>
                    </tytuł>
                    <autorzy>
                        <xsl:apply-templates select="autorzy" />
                    </autorzy>
                    <język>
                        <xsl:value-of select="język"/>
                    </język>

                    <xsl:apply-templates select="dział" />

                    <rok-wydania>
                        <xsl:value-of select="rok-wydania" />
                    </rok-wydania>

                    <cena>
                        <xsl:call-template name="policz_cene">
                            <xsl:with-param name="wartość" select="cena" />
                            <xsl:with-param name="waluta" select="cena/@waluta" />
                        </xsl:call-template>
                    </cena>
                </książka>
            </xsl:for-each>
        </książki>
    </xsl:template>
    
    <xsl:template match="/księgarnia/książki/książka/autorzy">
        <xsl:choose>
            <xsl:when test="@pracaZbiorowa = 'true'">
                <xsl:text>Praca zbiorowa</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:for-each select="autor">
                    <xsl:copy-of select="."/>
                </xsl:for-each>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="/księgarnia/książki/książka/dział">
        <xsl:variable name="id">
            <xsl:value-of select="@id" />
        </xsl:variable>

        <dział>
            <xsl:value-of select="/księgarnia/lista-działów/definicja-działu[@idDziału = $id]/@nazwaDziału" />
        </dział>
    </xsl:template>
    
    <xsl:template name="policz_cene">
        <xsl:param name="wartość"/>
        <xsl:param name="waluta"/>
        <xsl:param name="przelicznikEuro" select="4.20"/>
        <xsl:param name="przelicznikDolar" select="3.00"/>

        <xsl:choose>
            <xsl:when test="$waluta = 'EUR'">
                <xsl:value-of select="format-number($wartość * $przelicznikEuro, '0.00')" />
            </xsl:when>
            <xsl:when test="$waluta = 'USD'">
                <xsl:value-of select="format-number($wartość * $przelicznikDolar, '0.00')" />
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$wartość" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="/księgarnia/lista-działów">
        <działy>
            <xsl:for-each select="definicja-działu">
                <definicja-działu>
                    <id>
                        <xsl:value-of select="@idDziału"/>
                    </id>
                    <nazwa>
                        <xsl:value-of select="@nazwaDziału"/>
                    </nazwa>
                </definicja-działu>
            </xsl:for-each>
        </działy>
    </xsl:template>
    
    <xsl:template name="stat">
        <ilość-książek>
            <średnia-cena>
                <xsl:value-of select="(sum(//książka/cena[@waluta='PLN']) + sum(//książka/cena[@waluta='USD'])*3.5 + sum(//książka/cena[@waluta='EUR'])*4.5) div (count(//książka))" />
            </średnia-cena>
            <wszystkie>
                <xsl:value-of select="count(//książka)"/>
            </wszystkie>
            <bieżacy-rok>
                <xsl:value-of select="count(//książka[rok-wydania='2018'])"/>
            </bieżacy-rok>
            <język>
                <polski>
                    <xsl:value-of select="count(//książka[język='Polski'])"/>
                </polski>
                <angielski>
                    <xsl:value-of select="count(//książka[język='Angielski'])"/>
                </angielski>
                <niemiecki>
                    <xsl:value-of select="count(//książka[język='Niemiecki'])"/>
                </niemiecki>
            </język>
            <dział>
                <literatura>
                    <xsl:value-of select="count(//książka[dział/@id='D1'])"/>
                </literatura>
                <naukowe>
                    <xsl:value-of select="count(//książka[dział/@id='D2'])"/>
                </naukowe>
                <podręczniki>
                    <xsl:value-of select="count(//książka[dział/@id='D3'])"/>
                </podręczniki>
                <dziecięce>
                    <xsl:value-of select="count(//książka[dział/@id='D4'])"/>
                </dziecięce>
                <czasopisma>
                    <xsl:value-of select="count(//książka[dział/@id='D5'])"/>
                </czasopisma>
                <komiksy>
                    <xsl:value-of select="count(//książka[dział/@id='D6'])"/>
                </komiksy>
            </dział>
        </ilość-książek>
        <ilość-działów>
            <xsl:value-of select="count(//definicja-działu)"/>
        </ilość-działów>
    </xsl:template>

</xsl:stylesheet>
