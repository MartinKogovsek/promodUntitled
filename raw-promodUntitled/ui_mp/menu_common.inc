

#ifndef SURF_BUTTON_ALIGN
	#define SURF_BUTTON_ALIGN HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN
#endif

#define SURF_BUTTON_TOP( id, x, y, w, h, itemName, itemAction, visArg ) \
		SURF_BUTTON_MT( id, x, y, w, h, itemName, itemAction, ;, ;, visArg )

#define SURF_BUTTON_MT( id, x, y, w, h, itemName, itemAction, onItemEnter, onItemExit, visArg ) \
itemDef \
{ \
	visible			visArg \
	name			"button_default"id \
	rect			(x+90) y w h SURF_BUTTON_ALIGN \
	style			WINDOW_STYLE_SHADER \
	background		"cp_btn_main_top" \
	forecolor		0.75 0.02 0.2 0.8 \
} \
itemDef \
{ \
	visible			0 \
	name			"button_over"id \
	rect			(x+90) y w h SURF_BUTTON_ALIGN \
	style			WINDOW_STYLE_SHADER \
	background		"cp_btn_main_top" \
	forecolor		0.44 1 1 0.8 \
} \
itemDef \
{ \
	style		WINDOW_STYLE_FILLED \
	rect		(x+90) y w h SURF_BUTTON_ALIGN \
	exp			text( itemName ) \
	forecolor 	0.75 0.02 0.2 1 \
	type		ITEM_TYPE_BUTTON \
	textfont	UI_FONT_OBJECTIVE \
	textstyle	ITEM_TEXTSTYLE_NORMAL \
	textalign	ITEM_ALIGN_CENTER \
	textscale	0.34 \
	textalignx	0 \
	textaligny	(h - 4) \
	visible		visArg \
	mouseEnter \
	{ \
		play "mouse_over"; \
		show "button_over"id; \
		hide "button_default"id; \
		onItemEnter \
	} \
	mouseExit \
	{ \
		show "button_default"id; \
		hide "button_over"id; \
		onItemExit \
	} \
	action \
	{ \
		itemAction \
	} \
}

#define SURF_BUTTON_BOT( id, x, y, w, h, itemName, itemAction, gcolor, visArg ) \
		SURF_BUTTON_MB( id, x, y, w, h, itemName, itemAction, ;, ;, gcolor, visArg )

#define SURF_BUTTON_MB( id, x, y, w, h, itemName, itemAction, onItemEnter, onItemExit, gcolor, visArg ) \
itemDef \
{ \
	visible			visArg \
	name			"button_default"id \
	rect			(x+90) y w h SURF_BUTTON_ALIGN \
	style			WINDOW_STYLE_SHADER \
	background		"cp_btn_main_top" \
	forecolor		0.75 0.02 0.2 0.8 \
} \
itemDef \
{ \
	visible			0 \
	name			"button_over"id \
	rect			(x+90) y w h SURF_BUTTON_ALIGN \
	style			WINDOW_STYLE_SHADER \
	background		"cp_btn_main_top" \
	forecolor		gcolor 0.1 \
} \
itemDef \
{ \
	style		WINDOW_STYLE_FILLED \
	rect		(x+90) y w h SURF_BUTTON_ALIGN \
	exp			text( itemName ) \
	forecolor 	0.75 0.02 0.2 0.5 \
	type		ITEM_TYPE_BUTTON \
	textfont	UI_FONT_NORMAL \
	textstyle	ITEM_TEXTSTYLE_NORMAL \
	textalign	ITEM_ALIGN_CENTER \
	textscale	0.32 \
	textalignx	0 \
	textaligny	(h-2) \
	visible		visArg \
	mouseEnter \
	{ \
		play "mouse_over"; \
		show "button_over"id; \
		hide "button_default"id; \
		onItemEnter \
	} \
	mouseExit \
	{ \
		show "button_default"id; \
		hide "button_over"id; \
		onItemExit \
	} \
	action \
	{ \
		itemAction \
	} \
}

#define SURF_BUTTON_TOP_ACTIVE( id, x, y, w, h, itemName, visArg ) \
		SURF_BUTTON_MT_A( id, x, y, w, h, itemName, visArg )

#define SURF_BUTTON_MT_A( id, x, y, w, h, itemName, visArg ) \
itemDef \
{ \
	visible			visArg \
	name			"button_over"id \
	rect			(x+90) y w h SURF_BUTTON_ALIGN \
	style			WINDOW_STYLE_SHADER \
	background		"cp_btn_main_top" \
	forecolor		0.44 1 1 0.8 \
} \
itemDef \
{ \
	style		WINDOW_STYLE_FILLED \
	rect		(x+90) y w h SURF_BUTTON_ALIGN \
	exp			text( itemName ) \
	forecolor 	0.44 1 1 1 \
	type		ITEM_TYPE_BUTTON \
	textfont	UI_FONT_OBJECTIVE \
	textstyle	ITEM_TEXTSTYLE_NORMAL \
	textalign	ITEM_ALIGN_CENTER \
	textscale	0.34 \
	textalignx	0 \
	textaligny	(h - 4) \
	visible		visArg \
}

//====CHOICE=========================================================================

#define SURF_BUTTON_CHOICE( id, x, y, w, h, itemName, itemAction, visArg ) \
		SURF_BUTTON_C( id, x, y, w, h, itemName, itemAction, ;, ;, visArg )

#define SURF_BUTTON_C( id, x, y, w, h, itemName, itemAction, onItemEnter, onItemExit, visArg ) \
itemDef \
{ \
	visible			visArg \
	name			"button_default"id \
	rect			(x+90) y w h SURF_BUTTON_ALIGN \
	style			WINDOW_STYLE_SHADER \
	background		"cp_btn_s" \
	forecolor		0.75 0.02 0.2 .5 \
} \
itemDef \
{ \
	visible			visArg \
	name			"button_default"id \
	rect			(x+82) y 8 h SURF_BUTTON_ALIGN \
	style			WINDOW_STYLE_SHADER \
	background		"gradient_fadein" \
	forecolor		0.75 0.02 0.2 0.15 \
} \
itemDef \
{ \
	visible			0 \
	name			"button_over"id \
	rect			(x+90) y w h SURF_BUTTON_ALIGN \
	style			WINDOW_STYLE_SHADER \
	background		"gradient_fadein_t" \
	forecolor		0.75 0.02 0.2 0.25 \
} \
itemDef \
{ \
	style		WINDOW_STYLE_FILLED \
	rect		(x+90) y w h SURF_BUTTON_ALIGN \
	forecolor	0.44 1 1 1 \
	exp			text( itemName ) \
	type		ITEM_TYPE_BUTTON \
	textfont	UI_FONT_OBJECTIVE \
	textalign	ITEM_ALIGN_LEFT \
	textscale	0.38 \
	textalignx	12 \
	textaligny	(h-5) \
	visible		visArg \
	mouseEnter \
	{ \
		play "mouse_over"; \
		show "button_default"id; \
		show "button_over"id; \
		onItemEnter \
	} \
	mouseExit \
	{ \
		show "button_default"id; \
		hide "button_over"id; \
		onItemExit \
	} \
	action \
	{ \
		itemAction \
	} \
}

#define SURF_BUTTON_CHOICE_TEAM( id, x, y, w, h, itemName, itemAction, cteam, visArg ) \
		SURF_BUTTON_C_T( id, x, y, w, h, itemName, itemAction, ;, ;, cteam, visArg )

#define SURF_BUTTON_C_T( id, x, y, w, h, itemName, itemAction, onItemEnter, onItemExit, cteam, visArg ) \
itemDef \
{ \
	visible			visArg \
	name			"button_default"id \
	rect			(x+90) y w h SURF_BUTTON_ALIGN \
	style			WINDOW_STYLE_SHADER \
	background		"cp_btn" \
	forecolor		0.75 0.02 0.2 0.5 \
} \
itemDef \
{ \
	visible			when ( cteam == "attack"); \
	style			WINDOW_STYLE_SHADER \
	rect			(x+100) (y+10) (h-20) (h-20) SURF_BUTTON_ALIGN \
	exp				material( dvarString( "g_TeamIcon_Allies" ) ); \
	forecolor		1 1 1 0.2 \
} \
itemDef \
{ \
	visible			when ( cteam == "defence"); \
	style			WINDOW_STYLE_SHADER \
	rect			(x+100) (y+10) (h-20) (h-20) SURF_BUTTON_ALIGN \
	exp				material( dvarString( "g_TeamIcon_Axis" ) ); \
	forecolor		1 1 1 0.2 \
} \
itemDef \
{ \
	visible			visArg \
	name			"button_default"id \
	rect			(x+82) y 8 h SURF_BUTTON_ALIGN \
	style			WINDOW_STYLE_SHADER \
	background		"gradient_fadein" \
	forecolor		0.75 0.02 0.2 0.15 \
} \
itemDef \
{ \
	visible			0 \
	name			"button_over"id \
	rect			(x+90) y w h SURF_BUTTON_ALIGN \
	style			WINDOW_STYLE_SHADER \
	background		"gradient_fadein_t" \
	forecolor		0.75 0.02 0.2 0.25 \
} \
itemDef \
{ \
	style		WINDOW_STYLE_FILLED \
	rect		(x+90) y w h SURF_BUTTON_ALIGN \
	forecolor	0.44 1 1 1 \
	exp			text( itemName ) \
	type		ITEM_TYPE_BUTTON \
	textfont	UI_FONT_OBJECTIVE \
	textalign	ITEM_ALIGN_LEFT \
	textscale	0.35 \
	textalignx	12 \
	textaligny	70 \
	visible		visArg \
	mouseEnter \
	{ \
		play "mouse_over"; \
		show "button_default"id; \
		show "button_over"id; \
		onItemEnter \
	} \
	mouseExit \
	{ \
		show "button_default"id; \
		hide "button_over"id; \
		onItemExit \
	} \
	action \
	{ \
		itemAction \
	} \
}