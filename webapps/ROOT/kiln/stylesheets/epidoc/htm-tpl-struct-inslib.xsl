<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id$ -->
<xsl:stylesheet xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:t="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="t"
                version="2.0">
  <!-- Contains named templates for InsLib file structure (aka "metadata" aka "supporting data") -->

   <!-- Called from htm-tpl-structure.xsl -->

   <xsl:template name="inslib-body-structure">
     <xsl:call-template name="inscriptionnav"/>

     <p><b><i18n:text i18n:key="epidoc-xslt-inslib-description">Description</i18n:text>: </b>
     <xsl:choose>
       <xsl:when test="//t:support/t:p/text()">
         <xsl:apply-templates select="//t:support/t:p" mode="inslib-dimensions"/>
       </xsl:when>
       <xsl:when test="//t:support//text()">
         <xsl:apply-templates select="//t:support" mode="inslib-dimensions"/>
       </xsl:when>
       <xsl:otherwise><i18n:text i18n:key="epidoc-xslt-inslib-unknown">Unknown</i18n:text></xsl:otherwise>
     </xsl:choose>

     <br />
     <b><i18n:text i18n:key="epidoc-xslt-inslib-text">Text</i18n:text>: </b>
     <xsl:choose>
       <xsl:when test="//t:layoutDesc/t:layout//text()">
         <xsl:value-of select="//t:layoutDesc/t:layout"/>
       </xsl:when>
       <xsl:otherwise><i18n:text i18n:key="epidoc-xslt-inslib-unknown">Unknown</i18n:text>.</xsl:otherwise>
     </xsl:choose>
     <br />
     <b><i18n:text i18n:key="epidoc-xslt-inslib-letters">Letters</i18n:text>: </b>
     <xsl:if test="//t:handDesc/t:handNote/text()">
       <xsl:value-of select="//t:handDesc/t:handNote"/>
     </xsl:if>
     </p>

     <p><b><i18n:text i18n:key="epidoc-xslt-inslib-date">Date</i18n:text>: </b>
     <xsl:choose>
       <xsl:when test="//t:origin/t:origDate/text()">
         <xsl:value-of select="//t:origin/t:origDate"/>
         <xsl:if test="//t:origin/t:origDate[@type='evidence']">
           <xsl:text>(</xsl:text>
           <xsl:for-each select="tokenize(//t:origin/t:origDate[@evidence],' ')">
             <xsl:value-of select="translate(.,'-',' ')"/>
             <xsl:if test="position()!=last()">
               <xsl:text>, </xsl:text>
             </xsl:if>
           </xsl:for-each>
           <xsl:text>)</xsl:text>
         </xsl:if>
       </xsl:when>
       <xsl:otherwise><i18n:text i18n:key="epidoc-xslt-inslib-unknown">Unknown</i18n:text>.</xsl:otherwise>
     </xsl:choose>
     </p>

     <p><b><i18n:text i18n:key="epidoc-xslt-inslib-findspot">Findspot</i18n:text>: </b>
     <xsl:choose>
       <xsl:when test="//t:provenance[@type='found'][string(translate(normalize-space(.),' ',''))]">
         <xsl:apply-templates select="//t:provenance[@type='found']" mode="inslib-placename"/>
       </xsl:when>
       <xsl:otherwise><i18n:text i18n:key="epidoc-xslt-inslib-unknown">Unknown</i18n:text></xsl:otherwise>
     </xsl:choose>
     <br/>
     <b><i18n:text i18n:key="epidoc-xslt-inslib-original-location">Original location</i18n:text>: </b>
     <xsl:choose>
       <xsl:when test="//t:origin/t:origPlace/text()">
         <xsl:apply-templates select="//t:origin/t:origPlace" mode="inslib-placename"/>
       </xsl:when>
       <xsl:otherwise><i18n:text i18n:key="epidoc-xslt-inslib-unknown">Unknown</i18n:text></xsl:otherwise>
     </xsl:choose>
     <br/>
     <b><i18n:text i18n:key="epidoc-xslt-inslib-last-recorded-location">Last recorded location</i18n:text>: </b>
     <xsl:choose>
       <xsl:when test="//t:provenance[@type='observed'][string(translate(normalize-space(.),' ',''))]">
         <xsl:apply-templates select="//t:provenance[@type='observed']" mode="inslib-placename"/>
         <!-- Named template found below. -->
         <xsl:call-template name="inslib-invno"/>
       </xsl:when>
       <xsl:when test="//t:msIdentifier//t:repository[string(translate(normalize-space(.),' ',''))]">
         <xsl:value-of select="//t:msIdentifier//t:repository[1]"/>
         <!-- Named template found below. -->
         <xsl:call-template name="inslib-invno"/>
       </xsl:when>
       <xsl:otherwise><i18n:text i18n:key="epidoc-xslt-inslib-unknown">Unknown</i18n:text></xsl:otherwise>
     </xsl:choose>
     </p>

     <div class="section-container tabs" data-section="tabs">
       <section>
         <p class="title" data-section-title="data-section-title"><a href="#"><i18n:text i18n:key="epidoc-xslt-inslib-edition">Interpretive</i18n:text></a></p>
         <div class="content" id="edition" data-section-content="data-section-content">
           <!-- Edited text output -->
           <xsl:variable name="edtxt">
             <xsl:apply-templates select="//t:div[@type='edition']">
               <xsl:with-param name="parm-edition-type" select="'interpretive'" tunnel="yes"/>
             </xsl:apply-templates>
           </xsl:variable>
           <!-- Moded templates found in htm-tpl-sqbrackets.xsl -->
           <xsl:apply-templates select="$edtxt" mode="sqbrackets"/>
         </div>
       </section>
       <section>
         <p class="title" data-section-title="data-section-title"><a href="#"><i18n:text i18n:key="epidoc-xslt-inslib-diplomatic">Diplomatic</i18n:text></a></p>
         <div class="content" id="diplomatic" data-section-content="data-section-content">
           <!-- Edited text output -->
           <xsl:variable name="edtxt">
             <xsl:apply-templates select="//t:div[@type='edition']">
               <xsl:with-param name="parm-edition-type" select="'diplomatic'" tunnel="yes"/>
             </xsl:apply-templates>
           </xsl:variable>
           <!-- Moded templates found in htm-tpl-sqbrackets.xsl -->
           <xsl:apply-templates select="$edtxt" mode="sqbrackets"/>
         </div>
       </section>
     </div>

     <div id="apparatus">
       <!-- Apparatus text output -->
       <xsl:variable name="apptxt">
         <xsl:apply-templates select="//t:div[@type='apparatus']"/>
       </xsl:variable>
       <!-- Moded templates found in htm-tpl-sqbrackets.xsl -->
       <xsl:apply-templates select="$apptxt" mode="sqbrackets"/>
     </div>

     <div id="translation">
       <h4 class="slimmer"><i18n:text i18n:key="epidoc-xslt-inslib-translation">Translation</i18n:text></h4>
         <xsl:variable name="editor" select="//t:teiHeader/t:fileDesc/t:titleStmt/t:editor"/>
         <xsl:for-each select="//t:div[@type='translation'][@xml:lang]">
           <xsl:if test="@xml:lang"><h5><xsl:choose>
             <xsl:when test="@xml:lang='en'"><xsl:text>English </xsl:text></xsl:when>
             <xsl:when test="@xml:lang='fr'"><xsl:text>French </xsl:text></xsl:when>
             <xsl:when test="@xml:lang='it'"><xsl:text>Italian </xsl:text></xsl:when>
             <xsl:otherwise><xsl:value-of select="@xml:lang"/></xsl:otherwise>
           </xsl:choose>
             <xsl:text>translation</xsl:text></h5></xsl:if>
           <xsl:if test="@source">
             <xsl:variable name="source-id" select="substring-after(@source, '#')"/>
             <xsl:variable name="source" select="document(concat('file:',system-property('user.dir'),'/webapps/ROOT/content/xml/authority/bibliography.xml'))//t:bibl[@xml:id=$source-id]"/>
             <p><xsl:text>Translation source: </xsl:text> 
               <xsl:choose>
                 <xsl:when test="$source/t:bibl[@type='abbrev']"><xsl:value-of select="$source/t:bibl[@type='abbrev']"/></xsl:when>
                 <xsl:when test="$source[not(descendant::t:bibl[@type='abbrev'])]"><xsl:value-of select="$source"/></xsl:when>
                 <xsl:otherwise><xsl:value-of select="$source-id"/></xsl:otherwise>
               </xsl:choose></p>
           </xsl:if>
           <xsl:if test="@resp">
             <xsl:variable name="resp-id" select="substring-after(@resp, '#')"/>
             <xsl:variable name="resp" select="$editor[@xml:id=$resp-id]"/>
             <p><xsl:text>Translation by: </xsl:text> <xsl:value-of select="$resp"/></p>
           </xsl:if>
           <!-- Translation text output -->
           <xsl:variable name="transtxt">
             <xsl:apply-templates select=".//t:p"/>
           </xsl:variable>
           <!-- Moded templates found in htm-tpl-sqbrackets.xsl -->
           <xsl:apply-templates select="$transtxt" mode="sqbrackets"/>
         </xsl:for-each>
     </div>

     <div id="commentary">
       <h4 class="slimmer"><i18n:text i18n:key="epidoc-xslt-inslib-commentary">Commentary</i18n:text></h4>
       <!-- Commentary text output -->
       <xsl:variable name="commtxt">
         <xsl:apply-templates select="//t:div[@type='commentary']//t:p"/>
       </xsl:variable>
       <!-- Moded templates found in htm-tpl-sqbrackets.xsl -->
       <xsl:apply-templates select="$commtxt" mode="sqbrackets"/>
     </div>

     <p><b><i18n:text i18n:key="epidoc-xslt-inslib-bibliography">Bibliography</i18n:text>: </b>
     <xsl:apply-templates select="//t:div[@type='bibliography']/t:p/node()"/>
     <br/>
     <b><i18n:text i18n:key="epidoc-xslt-inslib-constituted-from">Text constituted from</i18n:text>: </b>
     <xsl:apply-templates select="//t:creation"/>
     </p>

     <div id="images">
       <h4 class="slimmer">Images</h4>
       <xsl:choose>
         <xsl:when test="//t:facsimile//t:graphic">
           <xsl:for-each select="//t:facsimile//t:graphic">
             <span>&#160;</span>
             <xsl:choose>
               <xsl:when test="contains(@url,'http')">
                 <div id="external_image">
                   <a target="_blank"><xsl:attribute name="href"><xsl:value-of select="@url"/></xsl:attribute><iframe style="height:200px; border: 0;"><xsl:attribute name="src"><xsl:value-of select="@url"/></xsl:attribute></iframe></a>
                 </div>
               </xsl:when>
               <xsl:otherwise>
                 <xsl:apply-templates select="." />
               </xsl:otherwise>
             </xsl:choose>
           </xsl:for-each>
         </xsl:when>
         <xsl:otherwise>
           <xsl:for-each select="//t:facsimile[not(//t:graphic)]">
             <xsl:text>None available (2019).</xsl:text>
           </xsl:for-each>
         </xsl:otherwise>
       </xsl:choose>
     </div>
   </xsl:template>

   <xsl:template name="inslib-structure">
      <xsl:variable name="title">
         <xsl:call-template name="inslib-title" />
      </xsl:variable>

      <html>
         <head>
            <title>
               <xsl:value-of select="$title"/>
            </title>
            <meta http-equiv="content-type" content="text/html; charset=UTF-8"/>
            <!-- Found in htm-tpl-cssandscripts.xsl -->
            <xsl:call-template name="css-script"/>
         </head>
         <body>
            <h1>
               <xsl:value-of select="$title"/>
            </h1>
            <xsl:call-template name="inslib-body-structure" />
         </body>
      </html>
   </xsl:template>

   <xsl:template match="t:dimensions" mode="inslib-dimensions">
      <xsl:if test="//text()">
         <xsl:if test="t:width/text()">w:
            <xsl:value-of select="t:width"/>
            <xsl:if test="t:height/text()">
               <xsl:text> x </xsl:text>
            </xsl:if>
         </xsl:if>
         <xsl:if test="t:height/text()">h:
            <xsl:value-of select="t:height"/>
         </xsl:if>
         <xsl:if test="t:depth/text()">d:
            <xsl:value-of select="t:depth"/>
         </xsl:if>
         <xsl:if test="t:dim[@type='diameter']/text()">x diam.:
            <xsl:value-of select="t:dim[@type='diameter']"/>
         </xsl:if>
      </xsl:if>
   </xsl:template>

   <xsl:template match="t:placeName|t:rs" mode="inslib-placename"> <!-- remove rs? -->
      <xsl:choose>
        <xsl:when test="contains(@ref,'pleiades.stoa.org') or contains(@ref,'geonames.org') or contains(@ref,'slsgazetteer.org')">
            <a>
               <xsl:attribute name="href">
                  <xsl:value-of select="@ref"/>
               </xsl:attribute>
               <xsl:apply-templates/>
            </a>
      </xsl:when>
         <xsl:otherwise>
            <xsl:apply-templates/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <xsl:template name="inslib-invno">
      <xsl:if test="//t:idno[@type='invNo'][string(translate(normalize-space(.),' ',''))]">
         <xsl:text> (Inv. no. </xsl:text>
         <xsl:for-each select="//t:idno[@type='invNo'][string(translate(normalize-space(.),' ',''))]">
            <xsl:value-of select="."/>
            <xsl:if test="position()!=last()">
               <xsl:text>, </xsl:text>
            </xsl:if>
         </xsl:for-each>
         <xsl:text>)</xsl:text>
      </xsl:if>
   </xsl:template>

   <xsl:template name="inslib-title">
     <xsl:choose>
       <xsl:when test="//t:titleStmt/t:title/text() and number(substring(//t:publicationStmt/t:idno[@type='filename']/text(),2,5))">
         <xsl:value-of select="//t:publicationStmt/t:idno[@type='filename']/text()"/>
         <xsl:text>. </xsl:text>
         <xsl:value-of select="//t:titleStmt/t:title"/>
       </xsl:when>
       <xsl:when test="//t:titleStmt/t:title/text()">
         <xsl:value-of select="//t:titleStmt/t:title"/>
       </xsl:when>
       <xsl:when test="//t:sourceDesc//t:bibl/text()">
         <xsl:value-of select="//t:sourceDesc//t:bibl"/>
       </xsl:when>
       <xsl:when test="//t:idno[@type='filename']/text()">
         <xsl:value-of select="//t:idno[@type='filename']"/>
       </xsl:when>
       <xsl:otherwise>
         <xsl:text>EpiDoc example output, InsLib style</xsl:text>
       </xsl:otherwise>
     </xsl:choose>
   </xsl:template>

  <xsl:template match="t:ptr[@target]">
    <xsl:variable name="bibl-ref" select="@target"/>
    <xsl:variable name="bibl" select="document(concat('file:',system-property('user.dir'),'/webapps/ROOT/content/xml/authority/bibliography.xml'))//t:bibl[@xml:id=$bibl-ref]"/>
    <xsl:apply-templates select="$bibl"/>
  </xsl:template>

  <xsl:template priority="1"  match="t:ref">
    <a>
      <xsl:attribute name="href">
        <xsl:value-of select="@target"/>
      </xsl:attribute>
      <xsl:attribute name="target">_blank</xsl:attribute>
      <xsl:apply-templates/>
    </a>
  </xsl:template>

  <xsl:template name="inscriptionnav">
    <xsl:param name="next_inscr"/>
    <xsl:param name="prev_inscr"/>

    <xsl:variable name="filename">
      <xsl:value-of select="//t:idno[@type='filename']"/>
    </xsl:variable>

    <xsl:variable name="prev"
      select="/aggregation/order//result/doc[str[@name='document_id' and text()=$filename]]/preceding-sibling::doc[1]/str[@name='file_path']/text()"/> <!-- from IOSPE: edit -->
    <xsl:variable name="next"
      select="/aggregation/order//result/doc[str[@name='document_id' and text()=$filename]]/following-sibling::doc[1]/str[@name='file_path']/text()"/> <!-- from IOSPE: edit -->

    <div class="row">
      <div class="large-12 columns">
        <ul class="pagination right">
          <li class="arrow">
            <xsl:attribute name="class">
              <xsl:text>arrow</xsl:text>
              <xsl:if test="not($prev)">
                <xsl:text> unavailable</xsl:text>
              </xsl:if>
            </xsl:attribute>
            <a>
              <xsl:attribute name="href">
                <xsl:if test="$prev">
                  <xsl:text>./</xsl:text>
                  <xsl:value-of select="$prev"/>
                  <xsl:text>.html</xsl:text>
                </xsl:if>
              </xsl:attribute>
              <xsl:text>&#171;</xsl:text>
              <i18n:text>Previous</i18n:text>
            </a>
          </li>

          <li class="arrow">
            <xsl:attribute name="class">
              <xsl:text>arrow</xsl:text>
              <xsl:if test="not($next)">
                <xsl:text> unavailable</xsl:text>
              </xsl:if>
            </xsl:attribute>
            <a>
              <xsl:attribute name="href">
                <xsl:if test="$next">
                  <xsl:text>./</xsl:text>
                  <xsl:value-of select="$next"/>
                  <xsl:text>.html</xsl:text>
                </xsl:if>
              </xsl:attribute>
              <i18n:text>Next</i18n:text>
              <xsl:text>&#187;</xsl:text>
            </a>
          </li>
        </ul>
      </div>
    </div>
  </xsl:template>

  <!--  old code for inscription numbers now in <idno type="ircyr2012">:
    <xsl:template name="inslib-title">
     <xsl:choose>
       <xsl:when test="//t:titleStmt/t:title/text() and number(substring(//t:publicationStmt/t:idno[@type='filename']/text(),2,5))">
         <xsl:value-of select="substring(//t:publicationStmt/t:idno[@type='filename'],1,1)"/>
         <xsl:text>. </xsl:text>
         <xsl:value-of select="number(substring(//t:publicationStmt/t:idno[@type='filename'],2,5)) div 100"/>
         <xsl:text>. </xsl:text>
         <xsl:value-of select="//t:titleStmt/t:title"/>
       </xsl:when>
       <xsl:when test="//t:titleStmt/t:title/text()">
         <xsl:value-of select="//t:titleStmt/t:title"/>
       </xsl:when>
       <xsl:when test="//t:sourceDesc//t:bibl/text()">
         <xsl:value-of select="//t:sourceDesc//t:bibl"/>
       </xsl:when>
       <xsl:when test="//t:idno[@type='filename']/text()">
         <xsl:value-of select="//t:idno[@type='filename']"/>
       </xsl:when>
       <xsl:otherwise>
         <xsl:text>EpiDoc example output, InsLib style</xsl:text>
       </xsl:otherwise>
     </xsl:choose>
   </xsl:template> -->

 </xsl:stylesheet>
