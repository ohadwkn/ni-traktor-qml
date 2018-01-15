import CSI 1.0
import QtQuick 2.0
import QtGraphicalEffects 1.0
import './../Definitions' as Definitions
import './../Widgets' as Widgets

//--------------------------------------------------------------------------------------------------------------------
//  DECK HEADER
//--------------------------------------------------------------------------------------------------------------------

Item {
  	id: 		deck_header

  	readonly property int thruDeckType:  4	// QML-only deck types
  	property int    deck_Id:           0

	//--------------------------------------------------------------------------------------------------------------------
	//  DECK PROPERTIES
	//--------------------------------------------------------------------------------------------------------------------

	AppProperty { id: propArtist;         		path: "app.traktor.decks." + (deck_Id+1) + ".content.artist" }
	AppProperty { id: propTitle;          		path: "app.traktor.decks." + (deck_Id+1) + ".content.title" }
	AppProperty { id: propMixerStableBpm; 		path: "app.traktor.decks." + (deck_Id+1) + ".tempo.true_bpm" }
	AppProperty { id: propTrackBpm;        		path: "app.traktor.decks." + (deck_Id+1) + ".content.bpm"; }
	AppProperty { id: propTempo;            	path: "app.traktor.decks." + (deck_Id+1) + ".tempo.tempo_for_display" }
	AppProperty { id: propRemixBeatPos;     	path: "app.traktor.decks." + (deck_Id+1) + ".remix.current_beat_pos"; }
	AppProperty { id: propElapsedTime;    		path: "app.traktor.decks." + (deck_Id+1) + ".track.player.elapsed_time"; }
	AppProperty { id: propGridOffset;     		path: "app.traktor.decks." + (deck_Id+1) + ".content.grid_offset" }
	AppProperty { id: propNextCuePoint;   		path: "app.traktor.decks." + (deck_Id+1) + ".track.player.next_cue_point"; }
	AppProperty { id: propTrackLength;    		path: "app.traktor.decks." + (deck_Id+1) + ".track.content.track_length"; }
	AppProperty { id: propMusicalKey;       	path: "app.traktor.decks." + (deck_Id+1) + ".content.musical_key" }
	AppProperty { id: propLegacyKey;       		path: "app.traktor.decks." + (deck_Id+1) + ".content.legacy_key" }
	// -----TenSuns Properties Start----//
	AppProperty { id: keyValue;               path: "app.traktor.decks." + (deckId+1) + ".track.key.adjust" }
	property real key:    keyValue.value * 12
	AppProperty { id: keyAdjustedDisplay;     path: "app.traktor.decks." + (deckId+1) + ".track.key.key_for_display" }
	//------TenSuns Properties End----//
	AppProperty { id: deckType;           		path: "app.traktor.decks." + (deck_Id+1) + ".type" }

	AppProperty { id: directThru;                 path: "app.traktor.decks." + (deck_Id+1) + ".direct_thru"; onValueChanged: { updateHeader() } }
	AppProperty { id: headerPropertyCover;        path: "app.traktor.decks." + (deck_Id+1) + ".content.cover_md5" }
	AppProperty { id: primaryKey;         		path: "app.traktor.decks." + (deck_Id+1) + ".track.content.primary_key" }

	AppProperty { id: propIsInSync;       		path: "app.traktor.decks." + (deck_Id+1) + ".sync.enabled"; }
	AppProperty { id: propSyncMasterDeck; 		path: "app.traktor.masterclock.source_id" }

	AppProperty { id: headerPropertyLoopActive;   path: "app.traktor.decks." + (deck_Id+1) + ".loop.active"; }
	AppProperty { id: headerPropertyLoopSize;     path: "app.traktor.decks." + (deck_Id+1) + ".loop.size"; }

	readonly property int speed: 40  // Transition speed

	readonly property double  cuePos:    (propNextCuePoint.value >= 0) ? propNextCuePoint.value : propTrackLength.value*1000

	readonly property int     deckType:  propDeckType.value
	readonly property bool    isLoaded:  (primaryKey.value > 0) || (deckType == DeckType.Remix)
	readonly property int     isInSync:  propIsInSync.value
	readonly property int     isMaster:  (propSyncMasterDeck.value == deck_Id) ? 1 : 0

	property string headerState:      	deckType != DeckType.Remix ? "large" : "none"

	height: deckType != DeckType.Remix ? 52 : 0



	// ######################
	// ### FUNCTIONS USED ###
	// ######################

	// ### Convert NI & camelot Keys to CAMELOT key format
	function convertToCamelot(inputKey) {
		// Minor Keys

		//  CAMELOT WITH 0			CAMELOT					OPEN KEY	 			MUSICAL KEY				MUSICAL KEY SHARP			DISPLAY VALUE
		if (inputKey == "01A" || 	inputKey ==  "1A" || 	inputKey ==  "6m" || 	inputKey ==  "Abm" || 	inputKey ==  "G#m") 	{	return "01A"; }
		if (inputKey == "02A" || 	inputKey ==  "2A" || 	inputKey ==  "7m" || 	inputKey ==  "Ebm" || 	inputKey ==  "D#m") 	{	return "02A"; }
		if (inputKey == "03A" || 	inputKey ==  "3A" || 	inputKey ==  "8m" || 	inputKey ==  "Bbm" || 	inputKey ==  "A#m") 	{	return "03A"; }
		if (inputKey == "04A" || 	inputKey ==  "4A" || 	inputKey ==  "9m" || 	inputKey ==  "Fm"  || 	inputKey ==  "Fm" ) 	{	return "04A"; }
		if (inputKey == "05A" || 	inputKey ==  "5A" || 	inputKey == "10m" || 	inputKey ==  "Cm"  || 	inputKey ==  "Cm" ) 	{	return "05A"; }
		if (inputKey == "06A" || 	inputKey ==  "6A" || 	inputKey == "11m" || 	inputKey ==  "Gm"  || 	inputKey ==  "Gm" ) 	{	return "06A"; }
		if (inputKey == "07A" || 	inputKey ==  "7A" || 	inputKey == "12m" || 	inputKey ==  "Dm"  || 	inputKey ==  "Dm" ) 	{	return "07A"; }
		if (inputKey == "08A" || 	inputKey ==  "8A" || 	inputKey ==  "1m" || 	inputKey ==  "Am"  || 	inputKey ==  "Am" ) 	{	return "08A"; }
		if (inputKey == "09A" || 	inputKey ==  "9A" || 	inputKey ==  "2m" || 	inputKey ==  "Em"  || 	inputKey ==  "Em" ) 	{	return "09A"; }
		if (inputKey == "10A" || 	inputKey == "10A" || 	inputKey ==  "3m" || 	inputKey ==  "Bm"  || 	inputKey ==  "Bm" ) 	{	return "10A"; }
		if (inputKey == "11A" || 	inputKey == "11A" || 	inputKey ==  "4m" || 	inputKey ==  "Gbm" || 	inputKey ==  "F#m") 	{	return "11A"; }
		if (inputKey == "12A" || 	inputKey == "12A" || 	inputKey ==  "5m" || 	inputKey ==  "Dbm" || 	inputKey ==  "C#m")		{	return "12A"; }

		// Mayor Keys

		//  CAMELOT WITH 0			CAMELOT					OPEN KEY	 			MUSICAL KEY				MUSICAL KEY SHARP			DISPLAY VALUE
		if (inputKey == "01B" || 	inputKey ==  "1B" || 	inputKey ==  "6d" || 	inputKey ==  "B"   || 	inputKey ==  "B"  ) 	{	return "01B"; }
		if (inputKey == "02B" || 	inputKey ==  "2B" || 	inputKey ==  "7d" || 	inputKey ==  "Gb"  || 	inputKey ==  "F#" ) 	{	return "02B"; }
		if (inputKey == "03B" || 	inputKey ==  "3B" || 	inputKey ==  "8d" || 	inputKey ==  "Db"  || 	inputKey ==  "C#" ) 	{	return "03B"; }
		if (inputKey == "04B" || 	inputKey ==  "4B" || 	inputKey ==  "9d" || 	inputKey ==  "Ab"  || 	inputKey ==  "G#" ) 	{	return "04B"; }
		if (inputKey == "05B" || 	inputKey ==  "5B" || 	inputKey == "10d" || 	inputKey ==  "Eb"  || 	inputKey ==  "D#" ) 	{	return "05B"; }
		if (inputKey == "06B" || 	inputKey ==  "6B" || 	inputKey == "11d" || 	inputKey ==  "Bb"  || 	inputKey ==  "A#" ) 	{	return "06B"; }
		if (inputKey == "07B" || 	inputKey ==  "7B" || 	inputKey == "12d" || 	inputKey ==  "F"   || 	inputKey ==  "F"  ) 	{	return "07B"; }
		if (inputKey == "08B" || 	inputKey ==  "8B" || 	inputKey ==  "1d" || 	inputKey ==  "C"   || 	inputKey ==  "C"  ) 	{	return "08B"; }
		if (inputKey == "09B" || 	inputKey ==  "9B" || 	inputKey ==  "2d" || 	inputKey ==  "G"   || 	inputKey ==  "G"  ) 	{	return "09B"; }
		if (inputKey == "10B" || 	inputKey == "10B" || 	inputKey ==  "3d" || 	inputKey ==  "D"   || 	inputKey ==  "D"  ) 	{	return "10B"; }
		if (inputKey == "11B" || 	inputKey == "11B" || 	inputKey ==  "4d" || 	inputKey ==  "A"   || 	inputKey ==  "A"  ) 	{	return "11B"; }
		if (inputKey == "12B" || 	inputKey == "12B" || 	inputKey ==  "5d" || 	inputKey ==  "E"   || 	inputKey ==  "E"  )		{	return "12B"; }

		// No Key Found
		return "N.A.";
	}

/*
	// #######################
	// ### ADD COVER IMAGE ###
	// #######################

  	Rectangle {
    	id: 						cover
    	anchors.top: 				deck_header.top
    	anchors.left: 				deck_header.left
    	anchors.topMargin: 			2
    	anchors.leftMargin: 		2
    	width:  					(isLoaded) ? 48:32
    	height: 					(isLoaded) ? 48:32
    	color:  					colors.rgba (255, 255, 255, 32)

    	// ### DRAW SYMBOL WHEN NO TRACK IS LOADED OR COVER IMAGE IS EMPTY
    	Rectangle {
      		id: 						coverEmptyCircle
      		height: 					10
      		width: 						parent.width
      		radius: 					parent.height * 0.5
      		anchors.centerIn: 			parent
      		visible:					(!isLoaded || (headerPropertyCover.value == ""))
      		color: 						colors.rgba (255, 255, 255, 32)
    	}

    	Rectangle {
      		id: 						dotEmptyCover
      		height: 					4
      		width: 						parent.width
      		radius: 					parent.height * 0.2
      		anchors.centerIn: 			parent
      		visible: 					(!isLoaded || (headerPropertyCover.value == ""))
      		color:   					colors.rgba (255, 255, 255, 32)
    	}

		// ### LOAD COVER IMAGE WHEN TRACK/STEM AND COVER IMAGE IS NOT EMPTY
    	Image {
      		id: 						coverImage
      		source: 					"image://covers/" + ((isLoaded) ? headerPropertyCover.value : "" )
      		anchors.fill: 				parent
      		sourceSize.height: 			parent.height
      		sourceSize.width: 			parent.width
      		visible: 					isLoaded && (headerPropertyCover.value != "")
      		fillMode: 					Image.PreserveAspectCrop

 			ColorOverlay {
 		        anchors.fill: coverImage
 		        source: coverImage
 		        color: headerState == "small" ? "#90303030" : "#00000000"
 		   }
    	}
  	}
*/
	// #######################################
	// ### ADD HORIZONTAL SEPERATION LINES ###
	// #######################################

	// ### ADD TOP LINE
  	Rectangle {
    	id:						top_line
    	width:  				deck_header.width
    	height: 				1
    	anchors.left: 			deck_header.left
    	anchors.leftMargin: 	0
    	anchors.top:       		deck_header.top
    	anchors.topMargin: 		0
    	color:  				headerState == "small" ? colors.rgba (20, 20, 20, 255) : (headerState == "large" ? colors.rgba (40, 40, 40, 255) : colors.rgba (255, 255, 255, 255))
   		visible:				isLoaded	// MAKE VISIBLE WHEN TRACK/STEM LOADED
  	}

	// ### ADD MIDDLE UPPER LINE
	Rectangle {
    	id:						middleUpper_line
    	width:  				2 + syncstatus_backgnd.width + 3 + syncedbpm_backgnd.width
    	height: 				1
    	anchors.left: 			vertical_seperator_left.right
    	anchors.leftMargin: 	0
    	anchors.top:       		deck_header.top
    	anchors.topMargin: 		17
    	color:  				headerState == "small" ? colors.rgba (20, 20, 20, 255) : colors.rgba (40, 40, 40, 255)
   		visible:				isLoaded	// MAKE VISIBLE WHEN TRACK/STEM LOADED
  	}

	// ### ADD MIDDLE LINE
	Rectangle {
    	id:						middle_line
    	width:  				deck_header.width-cover.width-4
    	height: 				1
    	anchors.right: 			deck_header.right
    	anchors.rightMargin: 	0
    	anchors.top:       		deck_header.top
    	anchors.topMargin: 		34
    	color:  				headerState == "small" ? colors.rgba (20, 20, 20, 255) : colors.rgba (40, 40, 40, 255)
   		visible:				isLoaded	// MAKE VISIBLE WHEN TRACK/STEM LOADED
  	}

	// ### ADD BOTTOM LINE
  	Rectangle {
    	id:						bottom_line
    	width:  				deck_header.width
    	height: 				1
    	anchors.left: 			deck_header.left
    	anchors.leftMargin: 	0
    	anchors.top:       		cover.bottom
    	anchors.topMargin: 		1
    	color:  				headerState == "small" ? colors.rgba (20, 20, 20, 255) : colors.rgba (40, 40, 40, 255)
  	}

	// ### ADD VERTICAL SEPERATOR LINE - LEFT OF COVER
	Rectangle {
    	id:						vertical_seperator_leftcover
    	height:  				51
    	width: 					1
    	anchors.left: 			deck_header.left
    	anchors.leftMargin: 	0
    	anchors.top:       		deck_header.top
    	anchors.topMargin: 		1
    	color:  				headerState == "small" ? colors.rgba (20, 20, 20, 255) : (headerState == "large" ? colors.rgba (40, 40, 40, 255) : colors.rgba (255, 255, 255, 255))
   		visible:				isLoaded	// MAKE VISIBLE WHEN TRACK/STEM LOADED
  	}

/*
	// ### ADD VERTICAL SEPERATOR LINE - RIGHT OF COVER
	Rectangle {
    	id:						vertical_seperator_rightcover
    	height:  				51
    	width: 					1
    	anchors.left: 			cover.right
    	anchors.leftMargin: 	1
    	anchors.top:       		deck_header.top
    	anchors.topMargin: 		1
    	color:  				headerState == "small" ? colors.rgba (20, 20, 20, 255) : colors.rgba (40, 40, 40, 255)
   		visible:				isLoaded	// MAKE VISIBLE WHEN TRACK/STEM LOADED
  	}
*/

	// ### ADD VERTICAL SEPERATOR LINE - LEFT OF LOOP SYMBOL
	Rectangle {
    	id:						vertical_seperator_leftloop
    	height:  				33
    	width: 					1
    	anchors.left: 			artist_backgnd.right
    	anchors.leftMargin: 	1
    	anchors.top:       		deck_header.top
    	anchors.topMargin: 		1
    	color:  				headerState == "small" ? colors.rgba (20, 20, 20, 255) : colors.rgba (40, 40, 40, 255)
   		visible:				isLoaded	// MAKE VISIBLE WHEN TRACK/STEM LOADED
  	}

	// ### ADD VERTICAL SEPERATOR LINE - LEFT
	Rectangle {
    	id:						vertical_seperator_left
    	height:  				51
    	width: 					1
    	anchors.left: 			loopindicator_backgnd.right
    	anchors.leftMargin: 	1
    	anchors.top:       		deck_header.top
    	anchors.topMargin: 		1
    	color:  				headerState == "small" ? colors.rgba (20, 20, 20, 255) : colors.rgba (40, 40, 40, 255)
   		visible:				isLoaded	// MAKE VISIBLE WHEN TRACK/STEM LOADED
  	}

	// ### ADD VERTICAL SEPERATOR LINE - LEFT MIDDLE
  	Rectangle {
    	id:						vertical_seperator_middle
    	height:  				51
    	width: 					1
    	anchors.left: 			syncstatus_backgnd.right
    	anchors.leftMargin: 	1
    	anchors.top:       		deck_header.top
    	anchors.topMargin: 		1
    	color:  				headerState == "small" ? colors.rgba (20, 20, 20, 255) : colors.rgba (40, 40, 40, 255)
   		visible:				isLoaded	// MAKE VISIBLE WHEN TRACK/STEM LOADED
  	}

	// ### ADD VERTICAL SEPERATOR LINE - RIGHT MIDDLE
  	Rectangle {
    	id:						vertical_seperator_rightmiddle
    	height:  				51
    	width: 					1
    	anchors.left: 			syncedbpm_backgnd.right
    	anchors.leftMargin: 	1
    	anchors.top:       		deck_header.top
    	anchors.topMargin: 		1
    	color:  				headerState == "small" ? colors.rgba (20, 20, 20, 255) : colors.rgba (40, 40, 40, 255)
   		visible:				isLoaded	// MAKE VISIBLE WHEN TRACK/STEM LOADED
  	}

	// ### ADD VERTICAL SEPERATOR LINE - RIGHT
  	Rectangle {
    	id:						vertical_seperator_right
    	height:  				51
    	width: 					1
    	anchors.right: 			deck_header.right
    	anchors.rightMargin: 	0
    	anchors.top:       		deck_header.top
    	anchors.topMargin: 		1
    	color:  				headerState == "small" ? colors.rgba (20, 20, 20, 255) : (headerState == "large" ? colors.rgba (40, 40, 40, 255) : colors.rgba (255, 255, 255, 255))
   		visible:				isLoaded	// MAKE VISIBLE WHEN TRACK/STEM LOADED
  	}

	// ##############################
	// ### ADD ARTIST & SONGTITLE ###
	// ##############################

  	// Songtitle_text: SONG_TITLE
	Rectangle {
    	id:						songtitle_backgnd
    	height: 				14
    	width:					285
    	anchors.left: 			deck_header.left
    	anchors.leftMargin: 	1
    	anchors.top:       		top_line.bottom
    	anchors.topMargin: 		3
    	color:  				colors.rgba (255, 255, 255, 0)
		visible:				isLoaded

		Text {
			id: 					songtitle_text
			text: 					propTitle.value
			color:     				headerState == "small" ? colors.rgba (255, 255, 255, 48) : colors.rgba (255, 255, 255, 232)
			font.pixelSize:     	fonts.scale(13)
			anchors.left: 			parent.left
			anchors.leftMargin: 	3
			anchors.top:    		parent.top
			anchors.topMargin:  	-2
			elide:      			Text.ElideRight
			width: 					parent.width - 6
		}
	}

	// Artist_text: ARTIST
	Rectangle {
    	id:						artist_backgnd
    	height: 				14
    	width:					285
    	anchors.left: 			deck_header.left
    	anchors.leftMargin: 	1
    	anchors.top:       		middleUpper_line.bottom
    	anchors.topMargin: 		1
    	color:  				colors.rgba (255, 255, 255, 0)
		visible:				isLoaded

		Text {
			id: 					artist_text
			text: 					propArtist.value
			color:     				headerState == "small" ? colors.rgba (220, 220, 220, 150) : colors.rgba (220, 220, 220, 190)
			font.pixelSize:     	fonts.scale(12)
			anchors.left: 			parent.left
			anchors.leftMargin: 	3
			anchors.top:    		parent.top
			anchors.topMargin:  	-2
			elide:      			Text.ElideRight
			width: 					parent.width - 6
		}
	}

	// ##########################
	// ### ADD LOOP INDICATOR ### - OK
	// ##########################

	// Indicates current loop setting and highlights when activated

	Rectangle {
    	id:						loopindicator_backgnd
    	height:  				31
    	width: 					40
    	anchors.left: 			vertical_seperator_leftloop.right
    	anchors.leftMargin: 	1
    	anchors.top:       		top_line.bottom
    	anchors.topMargin: 		1
    	color:  				colors.rgba (255, 255, 255, 16)
		visible:				isLoaded

		Rectangle {
			id:						loopindicator_border
			width:  				parent.width
			height: 				parent.height
			radius:					4
			anchors.horizontalCenter: 	parent.horizontalCenter
			anchors.verticalCenter: 	parent.verticalCenter
			visible:				isLoaded
			color: 					headerPropertyLoopActive.value ? ( headerState == "small" ? colors.rgba (255, 255, 255, 32) : colors.rgba (0, 220, 0, 128) ) : ( headerState == "small" ? colors.rgba (255, 255, 255, 0) : colors.rgba (255, 255, 255, 0) )
    		border.color: 			headerPropertyLoopActive.value ? ( headerState == "small" ? colors.rgba (255, 255, 255, 32) : colors.rgba (0, 220, 0, 160) ) : ( headerState == "small" ? colors.rgba (255, 255, 255, 32) : colors.rgba (255, 255, 255, 48) )

    		border.width: 1
    		}

		Text {
		  	id: 						loopindicator_textUpper

			function loopSizeString() {
				if ( headerPropertyLoopSize.value == 10) 	{ return ""; } // 32:1
				if ( headerPropertyLoopSize.value == 9 ) 	{ return ""; } // 16:1
				if ( headerPropertyLoopSize.value == 8 ) 	{ return ""; } // 8:1
				if ( headerPropertyLoopSize.value == 7 ) 	{ return ""; } // 4:1
				if ( headerPropertyLoopSize.value == 6 ) 	{ return ""; } // 2:1
				if ( headerPropertyLoopSize.value == 5 ) 	{ return ""; } // 1:1
				if ( headerPropertyLoopSize.value == 4 ) 	{ return "1"; } // 1:2
				if ( headerPropertyLoopSize.value == 3 ) 	{ return "1"; } // 1:4
				if ( headerPropertyLoopSize.value == 2 ) 	{ return "1"; } // 1:8
				if ( headerPropertyLoopSize.value == 1 ) 	{ return "1"; } // 1:16
				if ( headerPropertyLoopSize.value == 0 ) 	{ return "1"; } // 1:32
			}
		  	text: 						loopSizeString()
			color: 						headerPropertyLoopActive.value ? ( headerState == "small" ? colors.rgba (0, 0, 0, 232) : colors.rgba (0, 0, 0, 232) ) : ( headerState == "small" ? colors.rgba (255, 255, 255, 48) : colors.rgba (255, 255, 255, 232) )

			function loopSizeFont() {
				if ( headerPropertyLoopSize.value == 10) 	{ return fonts.scale(14); } // 32:1
				if ( headerPropertyLoopSize.value == 9 ) 	{ return fonts.scale(14); } // 16:1
				if ( headerPropertyLoopSize.value == 8 ) 	{ return fonts.scale(14); } // 8:1
				if ( headerPropertyLoopSize.value == 7 ) 	{ return fonts.scale(14); } // 4:1
				if ( headerPropertyLoopSize.value == 6 ) 	{ return fonts.scale(14); } // 2:1
				if ( headerPropertyLoopSize.value == 5 ) 	{ return fonts.scale(14); } // 1:1
				if ( headerPropertyLoopSize.value == 4 ) 	{ return fonts.scale(13); } // 1:2
				if ( headerPropertyLoopSize.value == 3 ) 	{ return fonts.scale(13); } // 1:4
				if ( headerPropertyLoopSize.value == 2 ) 	{ return fonts.scale(13); } // 1:8
				if ( headerPropertyLoopSize.value == 1 ) 	{ return fonts.scale(13); } // 1:16
				if ( headerPropertyLoopSize.value == 0 ) 	{ return fonts.scale(13); } // 1:32
			}
			font.pixelSize:     		loopSizeFont()

			function loopSizeMarginUpperLeft() {
				if ( headerPropertyLoopSize.value == 10) 	{ return 9; } // 32:1
				if ( headerPropertyLoopSize.value == 9 ) 	{ return 9; } // 16:1
				if ( headerPropertyLoopSize.value == 8 ) 	{ return 9; } // 8:1
				if ( headerPropertyLoopSize.value == 7 ) 	{ return 9; } // 4:1
				if ( headerPropertyLoopSize.value == 6 ) 	{ return 9; } // 2:1
				if ( headerPropertyLoopSize.value == 5 ) 	{ return 9; } // 1:1
				if ( headerPropertyLoopSize.value == 4 ) 	{ return 9; } // 1:2
				if ( headerPropertyLoopSize.value == 3 ) 	{ return 9; } // 1:4
				if ( headerPropertyLoopSize.value == 2 ) 	{ return 9; } // 1:8
				if ( headerPropertyLoopSize.value == 1 ) 	{ return 6; } // 1:16
				if ( headerPropertyLoopSize.value == 0 ) 	{ return 6; } // 1:32
			}
			anchors.left: 				parent.left
	    	anchors.leftMargin: 		loopSizeMarginUpperLeft()
			anchors.top:    			parent.top
			anchors.topMargin: 			3
			visible:					isLoaded
		}

		Text {
		  	id: 						loopindicator_textLower

			function loopSizeString() {
				if ( headerPropertyLoopSize.value == 10) 	{ return "32"; } // 32:1
				if ( headerPropertyLoopSize.value == 9 ) 	{ return "16"; } // 16:1
				if ( headerPropertyLoopSize.value == 8 ) 	{ return "8"; } // 8:1
				if ( headerPropertyLoopSize.value == 7 ) 	{ return "4"; } // 4:1
				if ( headerPropertyLoopSize.value == 6 ) 	{ return "2"; } // 2:1
				if ( headerPropertyLoopSize.value == 5 ) 	{ return "1"; } // 1:1
				if ( headerPropertyLoopSize.value == 4 ) 	{ return "2"; } // 1:2
				if ( headerPropertyLoopSize.value == 3 ) 	{ return "4"; } // 1:4
				if ( headerPropertyLoopSize.value == 2 ) 	{ return "8"; } // 1:8
				if ( headerPropertyLoopSize.value == 1 ) 	{ return "16"; } // 1:16
				if ( headerPropertyLoopSize.value == 0 ) 	{ return "32"; } // 1:32
			}
		  	text: 						loopSizeString()
			color: 						headerPropertyLoopActive.value ? ( headerState == "small" ? colors.rgba (0, 0, 0, 232) : colors.rgba (0, 0, 0, 232) ) : ( headerState == "small" ? colors.rgba (255, 255, 255, 48) : colors.rgba (255, 255, 255, 232) )

			function loopSizeFontLower() {
				if ( headerPropertyLoopSize.value == 10) 	{ return fonts.scale(18); } // 32:1
				if ( headerPropertyLoopSize.value == 9 ) 	{ return fonts.scale(18); } // 16:1
				if ( headerPropertyLoopSize.value == 8 ) 	{ return fonts.scale(18); } // 8:1
				if ( headerPropertyLoopSize.value == 7 ) 	{ return fonts.scale(18); } // 4:1
				if ( headerPropertyLoopSize.value == 6 ) 	{ return fonts.scale(18); } // 2:1
				if ( headerPropertyLoopSize.value == 5 ) 	{ return fonts.scale(18); } // 1:1
				if ( headerPropertyLoopSize.value == 4 ) 	{ return fonts.scale(13); } // 1:2
				if ( headerPropertyLoopSize.value == 3 ) 	{ return fonts.scale(13); } // 1:4
				if ( headerPropertyLoopSize.value == 2 ) 	{ return fonts.scale(13); } // 1:8
				if ( headerPropertyLoopSize.value == 1 ) 	{ return fonts.scale(13); } // 1:16
				if ( headerPropertyLoopSize.value == 0 ) 	{ return fonts.scale(13); } // 1:32
			}
			font.pixelSize:     		loopSizeFontLower()

			function loopSizeMarginLowerLeft() {
				if ( headerPropertyLoopSize.value == 10) 	{ return 9; } // 32:1
				if ( headerPropertyLoopSize.value == 9 ) 	{ return 9; } // 16:1
				if ( headerPropertyLoopSize.value == 8 ) 	{ return 14; } // 8:1
				if ( headerPropertyLoopSize.value == 7 ) 	{ return 14; } // 4:1
				if ( headerPropertyLoopSize.value == 6 ) 	{ return 14; } // 2:1
				if ( headerPropertyLoopSize.value == 5 ) 	{ return 14; } // 1:1
				if ( headerPropertyLoopSize.value == 4 ) 	{ return 22; } // 1:2
				if ( headerPropertyLoopSize.value == 3 ) 	{ return 22; } // 1:4
				if ( headerPropertyLoopSize.value == 2 ) 	{ return 22; } // 1:8
				if ( headerPropertyLoopSize.value == 1 ) 	{ return 18; } // 1:16
				if ( headerPropertyLoopSize.value == 0 ) 	{ return 18; } // 1:32
			}
			anchors.top:    			parent.top
			anchors.topMargin: 			loopSizeMarginLowerTop()

			function loopSizeMarginLowerTop() {
				if ( headerPropertyLoopSize.value == 10) 	{ return 3; } // 32:1
				if ( headerPropertyLoopSize.value == 9 ) 	{ return 3; } // 16:1
				if ( headerPropertyLoopSize.value == 8 ) 	{ return 3; } // 8:1
				if ( headerPropertyLoopSize.value == 7 ) 	{ return 3; } // 4:1
				if ( headerPropertyLoopSize.value == 6 ) 	{ return 3; } // 2:1
				if ( headerPropertyLoopSize.value == 5 ) 	{ return 3; } // 1:1
				if ( headerPropertyLoopSize.value == 4 ) 	{ return 10; } // 1:2
				if ( headerPropertyLoopSize.value == 3 ) 	{ return 10; } // 1:4
				if ( headerPropertyLoopSize.value == 2 ) 	{ return 10; } // 1:8
				if ( headerPropertyLoopSize.value == 1 ) 	{ return 10; } // 1:16
				if ( headerPropertyLoopSize.value == 0 ) 	{ return 10; } // 1:32
			}
	    	anchors.left: 				parent.left
	    	anchors.leftMargin: 		loopSizeMarginLowerLeft()

			visible:					isLoaded
		}

		// ### ADD DIVIDER LINE
		Rectangle {
			id:							loopindicator_dividerLine
			width:  					12
			height: 					1

			function loopDividerHorOffset() {
				if ( headerPropertyLoopSize.value == 10) 	{ return 3; } // 32:1
				if ( headerPropertyLoopSize.value == 9 ) 	{ return 3; } // 16:1
				if ( headerPropertyLoopSize.value == 8 ) 	{ return 3; } // 8:1
				if ( headerPropertyLoopSize.value == 7 ) 	{ return 3; } // 4:1
				if ( headerPropertyLoopSize.value == 6 ) 	{ return 3; } // 2:1
				if ( headerPropertyLoopSize.value == 5 ) 	{ return 3; } // 1:1
				if ( headerPropertyLoopSize.value == 4 ) 	{ return 12; } // 1:2
				if ( headerPropertyLoopSize.value == 3 ) 	{ return 12; } // 1:4
				if ( headerPropertyLoopSize.value == 2 ) 	{ return 12; } // 1:8
				if ( headerPropertyLoopSize.value == 1 ) 	{ return 9; } // 1:16
				if ( headerPropertyLoopSize.value == 0 ) 	{ return 8; } // 1:32
			}
			anchors.left: 				parent.left
			anchors.leftMargin: 		loopDividerHorOffset()

			anchors.verticalCenter: 	parent.verticalCenter
			color: 						headerPropertyLoopActive.value ? ( headerState == "small" ? colors.rgba (0, 0, 0, 232) : colors.rgba (0, 0, 0, 232) ) : ( headerState == "small" ? colors.rgba (255, 255, 255, 48) : colors.rgba (255, 255, 255, 232) )
			visible:					(isLoaded && (headerPropertyLoopSize.value < 5))
			transform: 					Rotation { origin.x: 7; origin.y: 0; angle: 300}
		}
	}

	// ####################################
	// ### ADD SYNC STATUS & SYNCED BPM ### - OK
	// ####################################

	Rectangle {
    	id:						syncstatus_backgnd
    	width:  				55
    	height: 				14
    	anchors.left: 			vertical_seperator_left.right
    	anchors.leftMargin: 	1
    	anchors.top:       		top_line.bottom
    	anchors.topMargin: 		1

		function mstrSyncRectColor() {
			if ( isInSync ) { return colors.rgba (0, 220, 0, 128); }
			if ( isMaster ) { return colors.rgba (255, 128, 0, 120); }
			if ( isLoaded ) { return colors.rgba (72, 72, 72, 255); }
		}
		color:     				headerState == "small" ? colors.rgba (255, 255, 255, 16) : mstrSyncRectColor()
		visible:				isLoaded

		Text {
			id: 					syncstatus_text

			function mstrSyncText() {
				if ( isMaster ) { return "MSTR"; }
				if ( isInSync ) { return "SYNC"; }
				if ( !isMaster && !isInSync ) { return "FREE"; }
			}
			text: 					mstrSyncText()

			function mstrSyncTextColor() {
				if ( isInSync ) { return colors.rgba (0, 0, 0, 232); }
//				if ( isInSync ) { return colors.rgba (255, 255, 255, 175); }
				if ( isMaster ) { return colors.rgba (255, 255, 255, 175); }
				if ( !isMaster && !isInSync ) { return colors.rgba (0, 0, 0, 255); }
			}
			color:     				headerState == "small" ? colors.rgba (255, 255, 255, 48) : mstrSyncTextColor()

			font.pixelSize:     	fonts.scale(14)
			anchors.horizontalCenter: 	parent.horizontalCenter
			anchors.top:    		parent.top
			anchors.topMargin:  	-2
			visible:				isLoaded
		}
	}


	// ####################################################
	// ### SYNCED BEATS PER MINUTE (TOP - MIDDLE/RIGHT) ### - OK
	// ####################################################

	// Displays tracks's current BPM.

	Rectangle {
		id: 					syncedbpm_backgnd
		height: 				14
		width: 					55
		anchors.left: 			vertical_seperator_middle.right
		anchors.leftMargin: 	1
		anchors.top: 	   		top_line.bottom
    	anchors.topMargin: 		1
		color: 					colors.rgba (255, 255, 255, 16)
		visible:				isLoaded

		Text {
			id: 					syncedbpm_text
			text: 					propMixerStableBpm.value.toFixed(2).toString()
			color:     				headerState == "small" ? colors.rgba (255, 255, 255, 48) : colors.rgba (255, 255, 255, 232)
			font.pixelSize:     	fonts.scale(14)
			anchors.horizontalCenter: 	parent.horizontalCenter
			anchors.top:    		parent.top
			anchors.topMargin:  	-2
			visible:				isLoaded
		}
	}

	// ###########################################
	// ### TEMPO OFFSET (MIDDLE - MIDDLE/LEFT) ### - OK
	// ###########################################

	// Displays the track offset in percentages.
	// Offset is determined either by manual or sync offset compared to original tracks BPM.

	Rectangle {
		id: 					tempoOffset_backgnd
		height: 				14
		width: 					55
		anchors.left: 			vertical_seperator_left.right
		anchors.leftMargin: 	1
		anchors.bottom:    		middle_line.top
		anchors.bottomMargin:  	1
    function tempoOffsetTextColor(propTempoFunc) {
      if ( propTempoFunc <= 2 && propTempoFunc >= -2 ) { return colors.rgba (124, 252, 0, 70); }
      if ( propTempoFunc <= 5 && propTempoFunc >= -5 ) { return colors.rgba (255, 255, 0, 70); }
      if ( propTempoFunc >= 5 || propTempoFunc <= -5 ) { return colors.rgba (255, 69, 0, 100); }
    }
    color:          tempoOffsetTextColor(((propTempo.value-1)*100).toFixed(0))
		visible:				isLoaded

		Text {
			id: 					tempoOffset_text

			function textTempoOffset() {
				return ((propTempo.value-1 < 0)?"":"+") + ((propTempo.value-1)*100).toFixed(2).toString() + "%";
			}
			text: 					textTempoOffset()

			color:     				colors.rgba (119,136,153, 200)
			font.pixelSize:     	fonts.scale(14)
			anchors.horizontalCenter: 	parent.horizontalCenter
			anchors.top:    		parent.top
			anchors.topMargin:  	-2
			visible:				isLoaded
		}
	}

	// ###############################################################
	// ### ORIGINAL TRACK BEATS PER MINUTE (MIDDLE - MIDDLE/RIGHT) ### - OK
	// ###############################################################

	// Displays the tracks original BPM as is.
	// Is not influenced by manual BPM changes or synced BPM changes.

	Rectangle {
		id: 					trackbpm_backgnd
		height: 				14
		width: 					55
		anchors.left: 			vertical_seperator_middle.right
		anchors.leftMargin: 	1
		anchors.bottom:    		middle_line.top
		anchors.bottomMargin:  	1
		color: 					colors.rgba (255, 255, 255, 16)
		visible:				isLoaded

		Text {
			id: 					trackbpm_text
			text: 					propTrackBpm.value.toFixed(2).toString()
			color:     				colors.rgba (255, 255, 255, 48)
			font.pixelSize:     	fonts.scale(14)
			anchors.horizontalCenter: 	parent.horizontalCenter
			anchors.top:    		parent.top
			anchors.topMargin:  	-2
			visible:				isLoaded
		}
	}

	// #######################
	// ### ADD DECK LETTER ### - OK
	// #######################

	// Displays the current deck letter.
	// Background color changes so it matches the DECK button in the S8

	Rectangle {
		id: 					deckletter_backgnd
		height: 				31
		width: 					30
		anchors.left: 			vertical_seperator_rightmiddle.right
		anchors.leftMargin: 	1
		anchors.top:       		top_line.bottom
		anchors.topMargin:  	1
		function colorDeckLetterBackgnd() {
			if (deck_Id == 0) {	return colors.rgba (0, 0, 255, 255); }
			if (deck_Id == 1) {	return colors.rgba (0, 0, 255, 255); }
			if (deck_Id == 2) {	return colors.rgba (255, 255, 255, 255); }
			if (deck_Id == 3) {	return colors.rgba (255, 255, 255, 255); }
		}
		color:     				headerState == "small" ? colors.rgba (255, 255, 255, 16) : colorDeckLetterBackgnd()
		visible:				isLoaded

		Text {
			id: 					deckletter_text

			function textDeckLetter() {
				if (deck_Id == 0) {	return "A"; }
				if (deck_Id == 1) {	return "B"; }
				if (deck_Id == 2) {	return "C"; }
				if (deck_Id == 3) {	return "D"; }
			}
			text: 					textDeckLetter()

			function colorDeckLetter() {
				if (deck_Id == 0) {	return colors.rgba (255, 255, 255, 175); }
				if (deck_Id == 1) {	return colors.rgba (255, 255, 255, 175); }
				if (deck_Id == 2) {	return colors.rgba (0, 0, 0, 255); }
				if (deck_Id == 3) {	return colors.rgba (0, 0, 0, 255); }
			}
			color:     				headerState == "small" ? colors.rgba (255, 255, 255, 48) : colorDeckLetter()

			font.pixelSize:     	fonts.scale(26)
			anchors.top:       		parent.top
			anchors.topMargin:  	-1
			anchors.horizontalCenter: deckletter_backgnd.horizontalCenter
			visible:				isLoaded
		}
	}

	// ###################################################
	// ### ADD TIME BAR & DOWN COUNTER (BOTTOM - LEFT) ### - OK
	// ###################################################

	// Displays progress bar and remaining time (mm:ss:hh)
	// Fade/Blink Orange/Red when track-end threshold is passed.
	// Set the track-end warning threshold in seconds (warningtime : 0..59 seconds)

	readonly property int warningtime: 30

	Rectangle {
      	id: 					timeRemaining_backgnd
		height: 				14
		width: 					276
		anchors.left: 			vertical_seperator_rightcover.right
		anchors.leftMargin: 	1
		anchors.top:       		middle_line.bottom
		anchors.topMargin:  	1
		color: 					colors.rgba (255, 255, 255, 16)
		visible:				isLoaded

		Rectangle {
			id: 					timeRemaining_progress
			height: 				14
			width: 					(propElapsedTime.value)/(propTrackLength.value)*timeRemaining_backgnd.width
			anchors.left: 			cover.left
			anchors.leftMargin: 	2
			anchors.top:       		middle_line.bottom
			anchors.topMargin:  	1

			function timeRemainingColor() {
				var seconds = (propTrackLength.value)-(propElapsedTime.value);
				var neg = (seconds < 0);

				if (neg) { seconds = -seconds; }

				var hun = Math.floor((seconds % 1) * 100);
				var sec = Math.floor(seconds % 60);
				var min = (Math.floor(seconds) - sec) / 60;

				if ((sec < warningtime) && (min == 0)) {
					if (hun < 50) {
						return colors.rgba (255, (128-(hun*128/50)), 0, 120); }
					else { return colors.rgba (255, ((hun-50)*128/50), 0, 120); }
					}
				else { return colors.rgba (255, 128, 0, 120); }
			}
			color:     				headerState == "small" ? colors.rgba (240, 240, 240, 16) : timeRemainingColor()

			visible:				isLoaded
		}

		Text {
			id: 					timeRemaining_text

			function stringTimeConvert() {
				var seconds = (propTrackLength.value)-(propElapsedTime.value);
				var neg = (seconds < 0);

				if (neg) { seconds = -seconds; }

				var tho = Math.floor((seconds % 1) * 1000);
				var sec = Math.floor(seconds % 60);
				var min = (Math.floor(seconds) - sec) / 60;

				var thoStr = tho.toString();
				if (tho < 10) { thoStr = "0" + thoStr; }
				if (tho < 100) { thoStr = "0" + thoStr; }

				var secStr = sec.toString();
				if (sec < 10) { secStr = "0" + secStr; }

				var minStr = min.toString();
				if (min < 10) { minStr = "0" + minStr; }

				return ("-" + minStr + ":" + secStr + ":" + thoStr);
			}
			text:   				stringTimeConvert()

			color:     				headerState == "small" ? colors.rgba (255, 255, 255, 48) : colors.rgba (240, 240, 240, 255);
			font.pixelSize:     	fonts.scale(13)
			font.family: 			"Pragmatica"
			anchors.top:       		parent.top
			anchors.topMargin:  	1
			anchors.horizontalCenter: timeRemaining_backgnd.horizontalCenter
			visible:				isLoaded
		}
	}

	// ##################################################
	// ### CURRENT TRACK BEATS (BOTTOM - MIDDLE/LEFT) ### - OK
	// ##################################################

	// Displays the current track beats in PP:BB.bb format. (PP : Phrases - BB : Bars - bb : beats)
	// Hightlight number in orange when counter indicates next phrase count start.
	// Set the phrase length (phraseLength : 4-8-16 phrases) (default : 8).
	// Set the beat length (beatLength : 4-8-16 beats) (default : 4).
	// Use Original Track BPM for calculations (propTrackBpm).

	readonly property int phraseLength: 8
	readonly property int beatLength: 4

	Rectangle {
		id: 					currentBeat_backgnd
		height: 				14
		width: 					55
		anchors.left: 			vertical_seperator_left.right
		anchors.leftMargin: 	1
		anchors.top:       		middle_line.bottom
		anchors.topMargin:  	1

		function currentBeat_colorCalc() {
			var beat = ((propElapsedTime.value*1000-propGridOffset.value)*propTrackBpm.value)/60000.0
			var curBeat  = parseInt(beat);

			if ( beat < 0.0 ) {	curBeat = curBeat*-1; }

			var value1 = parseInt(((curBeat/beatLength)/phraseLength)+1);
			var value2 = parseInt(((curBeat/beatLength)%phraseLength)+1);
			var value3 = parseInt( (curBeat%beatLength)+1);

			if ( (value2 == phraseLength/2) && (value3 == beatLength) && (beat > 0.0) ) { return colors.rgba (255, 128, 0, 120); }
			if ( (value2 == phraseLength) && (value3 == beatLength) && (beat > 0.0) ) { return colors.rgba (0, 220, 0, 128); }
			if ( (value2 == 1) && (value3 == 1) && (beat < 0.0) ) { return colors.rgba (0, 220, 0, 128); }

			return colors.rgba (255, 255, 255, 16);
		}

		color: 					currentBeat_colorCalc() //colors.rgba (255, 255, 255, 16)
		visible:				isLoaded

		Text {
			id: 					currentBeat_text

			function currentBeat_stringCalc() {
				var beat = ((propElapsedTime.value*1000-propGridOffset.value)*propTrackBpm.value)/60000.0
				var curBeat  = parseInt(beat);

				if ( beat < 0.0 ) {	curBeat = curBeat*-1; }

				var value1 = parseInt(((curBeat/beatLength)/phraseLength)+1);
				var value2 = parseInt(((curBeat/beatLength)%phraseLength)+1);
				var value3 = parseInt( (curBeat%beatLength)+1);

				if (beat < 0.0) { return "-" + value1.toString() + ":" + value2.toString() + "." + value3.toString(); }

				return value1.toString() + ":" + value2.toString() + "." + value3.toString();
			}
			text:   				currentBeat_stringCalc()

			function currentBeat_colortextCalc() {
				var beat = ((propElapsedTime.value*1000-propGridOffset.value)*propTrackBpm.value)/60000.0
				var curBeat  = parseInt(beat);

				if ( beat < 0.0 ) {	curBeat = curBeat*-1; }

				var value1 = parseInt(((curBeat/beatLength)/phraseLength)+1);
				var value2 = parseInt(((curBeat/beatLength)%phraseLength)+1);
				var value3 = parseInt( (curBeat%beatLength)+1);

				if ( (value2 == phraseLength) && (value3 == beatLength) && (beat > 0.0) ) { return colors.rgba (0, 0, 0, 232); }
				if ( (value2 == 1) && (value3 == 1) && (beat < 0.0) ) { return colors.rgba (0, 0, 0, 232); }

				return colors.rgba (255, 255, 255, 232);
			}

			color:     				headerState == "small" ? colors.rgba (255, 255, 255, 48) : currentBeat_colortextCalc()

			font.pixelSize:     	fonts.scale(14)
			anchors.top:       		parent.top
			anchors.topMargin:  	-2
			anchors.horizontalCenter: currentBeat_backgnd.horizontalCenter
			visible:				isLoaded
		}
	}

	// #########################################################
	// ### BEATS TILL NEXT CUE POINT (BOTTOM - MIDDLE/RIGHT) ### - OK
	// #########################################################

	// Displays the number of beats till next user-defined CUE point in PP:BB.bb format. (PP : Phrases - BB : Bars - bb : beats)
	// Phrase length is set @ CURRENT TRACK BEATS.
	// Beat length is set @ CURRENT TRACK BEATS.
	// Use Original Track BPM for calculations (propTrackBpm).

	Rectangle {
		id: 					keyAdjustChange_backgnd
		height: 				14
		width: 					55
		anchors.left: 			vertical_seperator_middle.right
		anchors.leftMargin: 	1
		anchors.top:       		middle_line.bottom
		anchors.topMargin:  	1
    function keyBgColorIfAdjusted() {
      if (key.toFixed(0)!=0) {
        return colors.rgba (255, 255, 0, 150)
      } else {
        return colors.rgba (255, 255, 255, 16)
      }
    }
		color: 					keyBgColorIfAdjusted()
		visible:				isLoaded


    Text {
      id:           keyAdjustChange_string
      text:           ((key<0)?"":"+") + key.toFixed(2).toString()
      function keyTextColorIfAdjusted() {
        if (key.toFixed(0)!=0) {
          return headerState == "small" ? colors.rgba (0, 0, 0, 48) : colors.rgba (0, 0, 0, 232)
        } else {
          return headerState == "small" ? colors.rgba (255, 255, 255, 48) : colors.rgba (255, 255, 255, 232)
        }
      }
      color:            keyTextColorIfAdjusted()
      font.pixelSize:       fonts.scale(14)
      anchors.top:          parent.top
      anchors.topMargin:    -2
      anchors.horizontalCenter: parent.horizontalCenter
      visible:        isLoaded
    }

/*		Text {
			id: 					nextCueBeat_string

			function nextCueBeat_stringCalc() {
				var beat = ((propElapsedTime.value*1000-cuePos)*propTrackBpm.value)/60000.0
				var curBeat  = parseInt(beat);

				if (beat < 0.0) { curBeat = curBeat*-1; }

				var value1 = parseInt(((curBeat/beatLength)/phraseLength)+1);
				var value2 = parseInt(((curBeat/beatLength)%phraseLength)+1);
				var value3 = parseInt( (curBeat%beatLength)+1);

				if (beat < 0.0) { return "-" + value1.toString() + ":" + value2.toString() + "." + value3.toString(); }

				return value1.toString() + "." + value2.toString() + "." + value3.toString();
			}
			text:   				nextCueBeat_stringCalc()

			color:     				headerState == "small" ? colors.rgba (255, 255, 255, 48) : colors.rgba (255, 255, 255, 232)
			font.pixelSize:     	fonts.scale(14)
			anchors.top:       		parent.top
			anchors.topMargin:  	-2
			anchors.horizontalCenter: nextCueBeat_backgnd.horizontalCenter
			visible:				isLoaded
		}
*/
  }

	// ###################################################
	// ### ORIGINAL TRACK MUSICAL KEY (BOTTOM - RIGHT) ###
	// ###################################################

	// Displays the Musical Key for the current track. (CAMELOT FORMAT)

	Rectangle {
    	id:						musickey_backgnd
    	width:  				30
    	height: 				14
    	anchors.left: 			vertical_seperator_rightmiddle.right
    	anchors.leftMargin: 	1
		anchors.top:       		middle_line.bottom
		anchors.topMargin:  	1
		color:     				headerState == "small" ? colors.rgba (255, 255, 255, 16) : colors.rgba (255, 255, 255, 48)

		visible:				isLoaded

		Text {
			id: 					musickey_text
			text: 					keyAdjustedDisplay.value
			color:     				headerState == "small" ? colors.rgba (255, 255, 255, 48) : colors.rgba (255, 255, 255, 232)
			font.pixelSize:     	fonts.scale(14)
			anchors.top:       		parent.top
			anchors.topMargin:  	-2
			anchors.horizontalCenter: musickey_backgnd.horizontalCenter
			visible:				isLoaded
		}
	  }



}
