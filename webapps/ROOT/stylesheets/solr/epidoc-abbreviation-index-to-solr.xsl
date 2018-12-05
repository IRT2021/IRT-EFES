<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <!-- This XSLT transforms a set of EpiDoc documents into a Solr
       index document representing an index of symbols in those
       documents. -->

    <xsl:import href="epidoc-index-utils.xsl" />

    <xsl:param name="index_type" />
    <xsl:param name="subdirectory" />

    <xsl:template match="/">
        <add>
            <xsl:for-each-group select="//tei:expan[ancestor::tei:div/@type='edition'][not(parent::tei:abbr)]" 
                group-by="concat(string-join(.//tei:abbr, ''),'-',.)">
                <!--<xsl:sort order="ascending"
                    select="translate(normalize-unicode(current-grouping-key(),'NFD'),'&#x0301;&#x0313;&#x0314;&#x0342;','')"/>-->
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
                            <xsl:when test="descendant::tei:g">
                                <xsl:value-of select="concat($base-uri, descendant::tei:g/@ref, 'QQQQQ')" />
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="string-join(.//tei:abbr, '')" />
                            </xsl:otherwise>
                        </xsl:choose>
                    </field>
                    <field name="index_item_sort_name">
                        <xsl:choose>
                            <xsl:when test="descendant::tei:g">
                                <xsl:value-of select="lower-case(translate(normalize-unicode(concat($base-uri, descendant::tei:g/@ref, 'QQQQQ'),'NFD'),'&#x0301;&#x0313;&#x0314;&#x0342;',''))" />
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="lower-case(translate(normalize-unicode(string-join(.//tei:abbr, ''),'NFD'),'&#x0301;&#x0313;&#x0314;&#x0342;',''))" />
                            </xsl:otherwise>
                        </xsl:choose>
                    </field>
                    <field name="language_code">
                        <xsl:value-of select="ancestor-or-self::*[@xml:lang][1]/@xml:lang"/>
                    </field>
                    <field name="index_abbreviation_expansion">
                        <xsl:value-of select=".//text()[not(ancestor::tei:am)]"/>
                    </field>
                    <xsl:apply-templates select="current-group()" />
                </doc>
            </xsl:for-each-group>
        </add>
    </xsl:template>

    <xsl:template match="tei:expan">
        <xsl:call-template name="field_index_instance_location" />
    </xsl:template>
    
</xsl:stylesheet>