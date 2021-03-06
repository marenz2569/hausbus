<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="text" indent="no"/>

	<xsl:template match="device">
		<!-- default values have to be reimplemented in xslt, because saxon he does not allow xsd validation -->
		<xsl:variable name="ss"><xsl:choose><xsl:when test="@ss"><xsl:value-of select="@ss"/></xsl:when><xsl:otherwise>D7</xsl:otherwise></xsl:choose></xsl:variable>
		<xsl:variable name="loop"><xsl:choose><xsl:when test="loop"><xsl:value-of select="loop"/></xsl:when><xsl:otherwise>sleep_mode();</xsl:otherwise></xsl:choose></xsl:variable>

		<xsl:result-document href="../src/{@name}.h">
			#ifndef CONFIG_H__
			#define CONFIG_H__

			#define MCP2515_CS_DDR DDR<xsl:value-of select="substring($ss, 1, 1)"/>
			#define MCP2515_CS_PORT PORT<xsl:value-of select="substring($ss, 1, 1)"/>
			#define MCP2515_CS_PIN PORT<xsl:value-of select="$ss"/>
			#define MCP2515_CS <xsl:value-of select="substring($ss, 1, 1)"/>,<xsl:value-of select="substring($ss, 2, 1)"/>
			#define MCP2515_INT D,2
			#define BOOT_LED D,3
			#define BOOTLOADER_TYPE 0
			#define BOOTLOADER_BOARD_ID <xsl:value-of select="@board-id"/>

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

			#define BUTTON_TABLE \<xsl:for-each select="button"><xsl:variable name="defaultState"><xsl:choose><xsl:when test="@defaultState"><xsl:value-of select="@defaultState"/></xsl:when><xsl:otherwise>NO</xsl:otherwise></xsl:choose></xsl:variable>
				ID(<xsl:value-of select="@id"/>) \
				<xsl:for-each select="in">ENTRY(<xsl:value-of select="position()-1"/>, <xsl:value-of select="substring(@pin, 1, 1)"/>, <xsl:value-of select="substring(@pin, 2, 1)"/>, <xsl:value-of select="$defaultState"/>)<xsl:if test="position()&lt;last()"> \
					</xsl:if>
				</xsl:for-each>
			</xsl:for-each>

			#define EEPROM_TABLE \
				ID(100)

			#endif
		</xsl:result-document>

		<xsl:result-document href="../src/{@name}.c">
			<xsl:value-of select="unparsed-text('template-header.c.part', 'utf-8')"/>

			<xsl:value-of select="code"/>

			<xsl:value-of select="unparsed-text('template-preinit.c.part', 'utf-8')"/>

			<xsl:value-of select="init"/>

			<xsl:value-of select="unparsed-text('template-postinit.c.part', 'utf-8')"/>

			<xsl:value-of select="$loop"/>

			<xsl:value-of select="unparsed-text('template-pretick.c.part', 'utf-8')"/>

			<xsl:value-of select="tick"/>

			<xsl:value-of select="unparsed-text('template-posttick.c.part', 'utf-8')"/>

			<xsl:for-each select="button">
				<xsl:for-each select="in">
					void button_<xsl:value-of select="@pin"/>(struct button_sub *el)
					{
						#define DIMMER(a, b) \
							el->dimmer.id = a; \
							el->dimmer.sub = b; \
							el->dimmer.status = START_DIMMING;

						if (el->status) {
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

					void button_press_<xsl:value-of select="@pin"/>(struct button_sub *el)
					{
						<xsl:value-of select="press"/>
					}

					void button_unpress_<xsl:value-of select="@pin"/>(struct button_sub *el)
					{
						<xsl:value-of select="unpress"/>
					}
				</xsl:for-each>
			</xsl:for-each>
		</xsl:result-document>
	</xsl:template>
</xsl:stylesheet>
