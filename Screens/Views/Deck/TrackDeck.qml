import CSI 1.0
import QtQuick 2.0
import QtGraphicalEffects 1.0

import '../../../Defines'
import './../Waveform' as WF

Item {
  id: trackDeck
  property int    deckId:          0
  property string deckSizeState:   "large"
  property color  deckColor:       colors.colorBgEmpty // transparent blue not possible for logo due to low bit depth of displays. was: // (deckId < 2) ? colors.colorDeckBlueBright12Full : colors.colorBgEmpty
  property bool   trackIsLoaded:   (primaryKey.value > 0)

  readonly property int waveformHeight: (deckSizeState == "small") ? 0 : ( parent ? ( (deckSizeState == "medium") ? (parent.height-43) : (parent.height-53) ) : 0 )

  property bool showLoopSize: false
  property int  zoomLevel:    1
  property bool isInEditMode: false
  property int    stemStyle:    StemStyle.track
  property string propertiesPath: ""

  readonly property int minSampleWidth: 0x800
  readonly property int sampleWidth: minSampleWidth << zoomLevel


  //--------------------------------------------------------------------------------------------------------------------

  AppProperty   { id: deckType;          path: "app.traktor.decks." + (deckId + 1) + ".type"                         }
  AppProperty   { id: primaryKey;        path: "app.traktor.decks." + (deckId + 1) + ".track.content.primary_key" }

  //--------------------------------------------------------------------------------------------------------------------
  // Waveform
  //--------------------------------------------------------------------------------------------------------------------

  WF.WaveformContainer {
    id: waveformContainer

    deckId:         trackDeck.deckId
    deckSizeState:  trackDeck.deckSizeState
    sampleWidth:    trackDeck.sampleWidth
    propertiesPath: trackDeck.propertiesPath

    anchors.top:          parent.top
    anchors.left:         parent.left
    anchors.right:        parent.right
    showLoopSize:         trackDeck.showLoopSize
    isInEditMode:         trackDeck.isInEditMode
    stemStyle:            trackDeck.stemStyle

    anchors.topMargin:    -2

    // the height of the waveform is defined as the remaining space of deckHeight - stripe.height - spacerWaveStripe.height
    height:  waveformHeight
    visible: (trackIsLoaded && deckSizeState != "small") ? 1 : 0

    Behavior on height { PropertyAnimation { duration: durations.deckTransition } }
  }


  //--------------------------------------------------------------------------------------------------------------------
  // Stripe
  //--------------------------------------------------------------------------------------------------------------------

  Rectangle {
    id: stripeGapFillerLeft
    anchors.left:   parent.left
    anchors.right:  stripe.left
    anchors.bottom: stripe.bottom
    height:         stripe.height
    color:          colors.colorBgEmpty
    visible:        trackDeck.trackIsLoaded && deckSizeState != "small"
  }

  Rectangle {
    id: stripeGapFillerRight
    anchors.left:   stripe.right
    anchors.right:  parent.right
    anchors.bottom: stripe.bottom
    height:         stripe.height
    color:          colors.colorBgEmpty
    visible:        trackDeck.trackIsLoaded && deckSizeState != "small"
  }

  //--------------------------------------------------------------------------------------------------------------------

  WF.Stripe {
    id: stripe

    readonly property int largeDeckBottomMargin: (waveformContainer.isStemStyleDeck) ? 6 : 12

    readonly property int smallDeckBottomMargin: (deckId > 1) ? 9 : 6

    anchors.left:           trackDeck.left
    anchors.right:          trackDeck.right
    anchors.bottom:         trackDeck.bottom
    anchors.bottomMargin:   (deckSizeState == "large") ? largeDeckBottomMargin : smallDeckBottomMargin
    anchors.leftMargin:     9
    anchors.rightMargin:    9
    height:                 28
    opacity:                trackDeck.trackIsLoaded ? 1 : 0

    deckId:                 trackDeck.deckId
    windowSampleWidth:      trackDeck.sampleWidth

    audioStreamKey: deckTypeValid(deckType.value) ? ["PrimaryKey", primaryKey.value] : ["PrimaryKey", 0]

    function deckTypeValid(deckType)      { return (deckType == DeckType.Track || deckType == DeckType.Stem);  }

    Behavior on anchors.bottomMargin { PropertyAnimation {  duration: durations.deckTransition } }
  }

  //--------------------------------------------------------------------------------------------------------------------
  // Empty Deck
  //--------------------------------------------------------------------------------------------------------------------

  // Image (Logo) for empty Track Deck  --------------------------------------------------------------------------------

/*  Rectangle {
      id:           artist_backgnd
      height:         14
      width:          285
      anchors.left:       deck_header.left
      anchors.leftMargin:   1
      anchors.top:          middleUpper_line.bottom
      anchors.topMargin:    1
      color:          colors.rgba (255, 255, 255, 0)
    visible:        isLoaded

    Text {
      id:           artist_text
      text:           propArtist.value
      color:            headerState == "small" ? colors.rgba (220, 220, 220, 150) : colors.rgba (220, 220, 220, 190)
      font.pixelSize:       fonts.scale(12)
      anchors.left:       parent.left
      anchors.leftMargin:   3
      anchors.top:        parent.top
      anchors.topMargin:    -2
      elide:            Text.ElideRight
      width:          parent.width - 6
    }

*/
  Rectangle {
    id: tensunsGapFillerLeft
    anchors.left:   deck_header.left
    anchors.right:  deck_header.right
    anchors.bottom: emptyTrackDeckImageColorOverlay.top
    height:         50
    width: parent.width
    color:          colors.colorBlack
    visible:        (!trackIsLoaded && deckSizeState != "small")

    Text {
      id:           tensunsText
      text:           "TenSuns"
      color:            colors.rgba (255,140,0,255)
      font.pixelSize:       fonts.scale(35)
      anchors.left:       parent.left
      anchors.leftMargin:   3
      anchors.top:        parent.top
      anchors.topMargin:    -2
      horizontalAlignment:  Text.AlignHCenter
      verticalAlignment:    Text.AlignVCenter
      // elide:            Text.ElideRight
      width:          parent.width - 6
    }

  }

  Image {
    id: emptyTrackDeckImage
    anchors.fill:         parent
    visible:              false // visibility is handled through the emptyTrackDeckImageColorOverlay
    source:               "./../images/eclipse-solar-resize.png"
    fillMode:             Image.PreserveAspectFit
  }

  // Deck color for empty deck image  ----------------------------------------------------------------------------------

  ColorOverlay {
    id: emptyTrackDeckImageColorOverlay
    anchors.fill: emptyTrackDeckImage
    visible:      (!trackIsLoaded && deckSizeState != "small")
    source:       emptyTrackDeckImage
  }

}
