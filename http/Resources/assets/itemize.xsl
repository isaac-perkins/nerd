<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="xml" version="1.0" encoding="utf-8" omit-xml-declaration="yes" standalone="no" indent="no"/>
  <xsl:template match="*"/>
  <xsl:template match="result">
  <xsl:variable name="first">id</xsl:variable>
    <meta>
      <xsl:for-each select="document/entity[contains(@type, 'document')]">
        <xsl:text disable-output-escaping="yes">&lt;</xsl:text>
          <xsl:value-of select="@type"/>
        <xsl:text disable-output-escaping="yes">&gt;</xsl:text>
        <xsl:value-of select="."/>
        <xsl:text disable-output-escaping="yes">&lt;/</xsl:text>
          <xsl:value-of select="@type"/>
        <xsl:text disable-output-escaping="yes">&gt;</xsl:text>
      </xsl:for-each>
    </meta>
    <xsl:for-each select="document/entity[@type = $first]">
      <item>
        <id>
          <xsl:value-of select="."/>
        </id>
        <xsl:variable name="nid">
          <xsl:for-each select="following-sibling::entity[not(contains(@type, 'document'))]">
            <xsl:if test="@type=$first"><xsl:value-of select="position()"/>/</xsl:if>
          </xsl:for-each>
        </xsl:variable>
        <xsl:for-each select="following-sibling::entity[position() &lt; substring-before($nid, '/') and @type != $first and not(contains(@type, 'document'))]">
          <xsl:sort select="@type" data-type="text" order="ascending"/>
          <xsl:variable name="type" select="@type"/>
          <xsl:if test="preceding-sibling::*[1][@type != $type]">
            <xsl:text> </xsl:text>
            <xsl:text disable-output-escaping="yes">&lt;</xsl:text>
            <xsl:value-of select="@type"/>
            <xsl:text disable-output-escaping="yes">&gt;</xsl:text>
          </xsl:if>
          <xsl:value-of select="normalize-space(.)"/>
          <xsl:if test="following-sibling::*[1][@type = $type]"><xsl:text> </xsl:text></xsl:if>
          <xsl:if test="following-sibling::*[1][@type != $type]">
              <xsl:text> </xsl:text>
            <xsl:text disable-output-escaping="yes">&lt;/</xsl:text>
            <xsl:value-of select="@type"/>
            <xsl:text disable-output-escaping="yes">&gt;</xsl:text>
          </xsl:if>
        </xsl:for-each>
      </item>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>
