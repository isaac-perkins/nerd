<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="xml" version="1.0" encoding="utf-8" omit-xml-declaration="yes" standalone="no" indent="no"/>
  <xsl:template match="*"/>
  <xsl:template match="result">
    <document>
      <meta>
        <xsl:for-each select="//types/type[contains(., 'document')]">
          <xsl:text disable-output-escaping="yes">&lt;</xsl:text><xsl:value-of select="name()"/>
          <xsl:text disable-output-escaping="yes">&gt;</xsl:text>
          <xsl:value-of select="."/>
          <xsl:text disable-output-escaping="yes">&lt;</xsl:text>/<xsl:value-of select="name()"/>
          <xsl:text disable-output-escaping="yes">&gt;</xsl:text>
        </xsl:for-each>
      </meta>
      <item>
        <xsl:for-each select="//types/type[not(contains(., 'document'))]">
          <xsl:variable name="t" select="."/>
          <xsl:text disable-output-escaping="yes">&lt;</xsl:text><xsl:value-of select="$t"/><xsl:text disable-output-escaping="yes">&gt;</xsl:text>
            <xsl:value-of select="/result/document/entity[@type = $t][1]"/>
          <xsl:text disable-output-escaping="yes">&lt;</xsl:text>/<xsl:value-of select="$t"/><xsl:text disable-output-escaping="yes">&gt;</xsl:text>
        </xsl:for-each>
      </item>
    </document>
  </xsl:template>
</xsl:stylesheet>
