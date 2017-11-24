<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="text" indent="no"/>

	<xsl:template match="device">
		<xsl:result-document href="../src/{@name}.h">
			#ifndef CONFIG_H__
			#define CONFIG_H__

			#define PWM_TABLE \<xsl:for-each select="pwm">
				ID(<xsl:value-of select="@id"/>) \
				<xsl:for-each select="out">ENTRY(<xsl:value-of select="position()-1"/>, <xsl:value-of select="substring(@pin, 1, 1)"/>, <xsl:value-of select="substring(@pin, 2, 1)"/>)<xsl:if test="position()&lt;last()"> \
					</xsl:if>
				</xsl:for-each>
			</xsl:for-each>

			#define OUTPUT_TABLE \<xsl:for-each select="output">
				ID(<xsl:value-of select="@id"/>) \
				<xsl:for-each select="out">ENTRY(<xsl:value-of select="position()-1"/>, <xsl:value-of select="substring(@pin, 1, 1)"/>, <xsl:value-of select="substring(@pin, 2, 1)"/>)<xsl:if test="position()&lt;last()"> \
					</xsl:if>
				</xsl:for-each>
			</xsl:for-each>

			#define BUTTON_TABLE \<xsl:for-each select="button">
				ID(<xsl:value-of select="@id"/>) \
				<xsl:for-each select="in">ENTRY(<xsl:value-of select="position()-1"/>, <xsl:value-of select="substring(@pin, 1, 1)"/>, <xsl:value-of select="substring(@pin, 2, 1)"/>)<xsl:if test="position()&lt;last()"> \
					</xsl:if>
				</xsl:for-each>
			</xsl:for-each>

			#endif
		</xsl:result-document>

		<xsl:result-document href="../src/{@name}.c">
			<xsl:value-of select="unparsed-text('template-header.c.part', 'utf-8')"/>

			<xsl:value-of select="code"/>

			<xsl:value-of select="unparsed-text('template-pretick.c.part', 'utf-8')"/>

			<xsl:value-of select="tick"/>

			<xsl:value-of select="unparsed-text('template-posttick.c.part', 'utf-8')"/>

			<xsl:for-each select="button">
				<xsl:for-each select="in">
					void button_<xsl:value-of select="@pin"/>(struct button_sub *el, uint8_t i)
					{
						#define DIMMER(a, b) \
							el->dimmer.id = a; \
							el->dimmer.sub = b; \
							el->dimmer.status = START_DIMMING;

						if (i) {
							switch (el->count) {
					<xsl:for-each select=".//short">
							case <xsl:value-of select="count(ancestor-or-self::*)-count(ancestor::in[1]/ancestor-or-self::*)"/>:
								<xsl:value-of select="code"/>
								break;
					</xsl:for-each>
							default:
								break;
							}
						} else {
							switch (el->count) {
					<xsl:for-each select=".//long">
							case <xsl:value-of select="count(ancestor-or-self::*)-count(ancestor::in[1]/ancestor-or-self::*)-1"/>:
								<xsl:value-of select="code"/>
								break;
					</xsl:for-each>
							default:
								break;
							}
						}
					}
				</xsl:for-each>
			</xsl:for-each>
		</xsl:result-document>
	</xsl:template>
</xsl:stylesheet>
