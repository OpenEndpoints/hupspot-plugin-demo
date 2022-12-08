<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" exclude-result-prefixes="#all">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:variable name="objectId">
		<xsl:choose>
			<xsl:when test="not(exists(parameter-transformation-input/input-from-request/parameter[@name eq 'objectId']/@value))">0</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="parameter-transformation-input/input-from-request/parameter[@name eq 'objectId']/@value"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="json-properties" select="parameter-transformation-input/input-from-request/json/properties"/>
	<xsl:variable name="collection">
		<xsl:choose>
			<xsl:when test="exists($json-properties/company)">contact</xsl:when>
			<xsl:otherwise>company</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:template match="/">
		<parameter-transformation-output>
			<parameter name="objectId">
				<xsl:attribute name="value" select="$objectId"/>
			</parameter>
			<parameter name="currentDate">
				<xsl:attribute name="value" select="fn:current-date()"/>
			</parameter>
			<parameter name="currentDateFormatted">
				<xsl:attribute name="value" select="fn:format-date(fn:current-date(),'[D01].[M01].[Y0001]')"/>
			</parameter>			
			<xsl:for-each select="$json-properties/*">
				<xsl:variable name="property-name" select="node-name(.) cast as xs:token"/>
				<xsl:variable name="parameter-name" select="concat($collection,'_',$property-name)"/>
				<xsl:choose>
					<xsl:when test="not(exists(/parameter-transformation-input/parameter-properties/parameter[@name eq $parameter-name]))"/>
					<xsl:when test=". eq 'null'"/>
					<xsl:otherwise>
						<parameter>
							<xsl:attribute name="name" select="$parameter-name"/>
							<xsl:attribute name="value" select="."/>
						</parameter>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</parameter-transformation-output>
	</xsl:template>
</xsl:stylesheet>
