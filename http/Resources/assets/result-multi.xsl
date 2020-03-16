<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="xml" version="1.0" encoding="utf-8" omit-xml-declaration="yes" standalone="no" indent="no"/>
  <xsl:template match="*"/>
  <xsl:template match="document">
    <document>
      <meta>
        <xsl:for-each select="meta/*">
          <xsl:text disable-output-escaping="yes">&lt;</xsl:text><xsl:value-of select="name()"/><xsl:text disable-output-escaping="yes">&gt;</xsl:text>
            <xsl:value-of select="."/>
          <xsl:text disable-output-escaping="yes">&lt;</xsl:text>/<xsl:value-of select="name()"/><xsl:text disable-output-escaping="yes">&gt;</xsl:text>
        </xsl:for-each>
      </meta>
      <xsl:for-each select="item">
          <item>
            <xsl:variable name="item" select="."/>
            <xsl:for-each select="//types/type[not(contains(., 'document'))]">
              <xsl:variable name="t" select="."/>
              <xsl:text disable-output-escaping="yes">&lt;</xsl:text><xsl:value-of select="$t"/><xsl:text disable-output-escaping="yes">&gt;</xsl:text>
                <xsl:choose>
                  <xsl:when test="@count='2'">
                    <xsl:for-each select="$item/*[name()=$t]">
                      <xsl:value-of select="."/>
                    </xsl:for-each>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="$item/*[name()=$t][1]"/>
                  </xsl:otherwise>
                </xsl:choose>
              <xsl:text disable-output-escaping="yes">&lt;</xsl:text>/<xsl:value-of select="$t"/><xsl:text disable-output-escaping="yes">&gt;</xsl:text>
            </xsl:for-each>
          </item>
      </xsl:for-each>
    </document>
  </xsl:template>
</xsl:stylesheet>
