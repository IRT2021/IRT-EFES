<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="#all"
                version="2.0"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- This XSLT transforms a set of EpiDoc documents into a Solr
       index document representing an index of military terms in those
       documents. -->

  <xsl:import href="epidoc-index-utils.xsl" />

  <xsl:param name="index_type" />
  <xsl:param name="subdirectory" />

  <xsl:template match="/">
    <add>
      <xsl:for-each-group select="//tei:w[@lemma][ancestor::tei:rs[@type='military'] or ancestor::tei:orgName]" group-by="@lemma">
        <xsl:variable name="key-id" select="@lemma"/>
        <xsl:variable name="key" select="document('../../content/xml/authority/military.xml')//tei:item[@xml:id=$key-id]"/>
        <doc>
          <field name="document_type">
            <xsl:value-of select="$subdirectory" />
            <xsl:text>_</xsl:text>
            <xsl:value-of select="$index_type" />
            <xsl:text>_index</xsl:text>
          </field>
          <xsl:call-template name="field_file_path" />
          <field name="index_item_name">
            <xsl:choose>
              <xsl:when test="$key">
                <xsl:value-of select="$key/tei:term[1]" />
                <xsl:if test="$key/tei:term[2]">
              <xsl:text> / </xsl:text>
              <xsl:value-of select="$key/tei:term[2]" />
            </xsl:if>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="@lemma" />
              </xsl:otherwise>
            </xsl:choose>
          </field>
          <field name="index_external_resource">
            <xsl:value-of select="$key/tei:idno" />
          </field>
          <xsl:apply-templates select="current-group()" />
        </doc>
      </xsl:for-each-group>
      
      <xsl:for-each-group select="//tei:placeName[@nymRef][ancestor::tei:rs[@type='military'] or ancestor::tei:orgName]|//tei:name[@nymRef][ancestor::tei:rs[@type='military'] or ancestor::tei:orgName]" group-by="@nymRef">
        <xsl:variable name="key-id" select="@nymRef"/>
        <xsl:variable name="key" select="document('../../content/xml/authority/military.xml')//tei:item[@xml:id=$key-id]"/>
        <doc>
          <field name="document_type">
            <xsl:value-of select="$subdirectory" />
            <xsl:text>_</xsl:text>
            <xsl:value-of select="$index_type" />
            <xsl:text>_index</xsl:text>
          </field>
          <xsl:call-template name="field_file_path" />
          <field name="index_item_name">
            <xsl:choose>
              <xsl:when test="$key">
                <xsl:value-of select="$key/tei:term[1]" />
                <xsl:if test="$key/tei:term[2]">
                  <xsl:text> / </xsl:text>
                  <xsl:value-of select="$key/tei:term[2]" />
                </xsl:if>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="@nymRef" />
              </xsl:otherwise>
            </xsl:choose>
          </field>
          <field name="index_external_resource">
            <xsl:value-of select="$key/tei:idno" />
          </field>
          <xsl:apply-templates select="current-group()" />
        </doc>
      </xsl:for-each-group>
      
      <!--<xsl:for-each-group select="//tei:num[ancestor::tei:rs[@type='military'] or ancestor::tei:orgName]" group-by=".">
        <doc>
          <field name="document_type">
            <xsl:value-of select="$subdirectory" />
            <xsl:text>_</xsl:text>
            <xsl:value-of select="$index_type" />
            <xsl:text>_index</xsl:text>
          </field>
          <xsl:call-template name="field_file_path" />
          <field name="index_item_name">
                <xsl:value-of select="." />
          </field>
          <field name="index_external_resource">
          </field>
          <xsl:apply-templates select="current-group()" />
        </doc>
      </xsl:for-each-group>-->
    </add>
  </xsl:template>

  <xsl:template match="tei:w[@lemma][ancestor::tei:rs[@type='military'] or ancestor::tei:orgName]|tei:placeName[@nymRef][ancestor::tei:rs[@type='military'] or ancestor::tei:orgName]|tei:name[@nymRef][ancestor::tei:rs[@type='military'] or ancestor::tei:orgName]"> <!-- |tei:num[ancestor::tei:rs[@type='military'] or ancestor::tei:orgName] -->
    <xsl:call-template name="field_index_instance_location" />
  </xsl:template>

</xsl:stylesheet>
