PORTAL.activateAdminSettings = ->
  do activateInitialMap
  do activateArmsModal


activateInitialMap = ->
  $(".initial-showlocation").click ->
    PORTAL.map.setCenter(
      new OpenLayers.LonLat(PORTAL.configurationSettings.mapInitialY, PORTAL.configurationSettings.mapInitialX), PORTAL.configurationSettings.mapInitialZ
    )
  $(".initial-setlocation").click ->
    xCoordinate = PORTAL.map.getCenter().lat.toFixed(0)
    yCoordinate = PORTAL.map.getCenter().lon.toFixed(0)
    zoomLevel = PORTAL.map.getZoom()
    $.ajax {
      type: "PUT",
      url: "admin/changeInitialMap",
      data: {xCoordinate: xCoordinate, yCoordinate: yCoordinate, zoomLevel: zoomLevel},
      success: (result) ->
        PORTAL.configurationSettings.mapInitialX = xCoordinate
        PORTAL.configurationSettings.mapInitialY = yCoordinate
        PORTAL.configurationSettings.mapInitialZ = zoomLevel
    }

activateArmsModal = ->
  $("#adminArmsModal").on "show", prepareArmsModal
  $("#adminArmsModal .modal-footer a").on "click", ->
    $("#adminArmsModal").modal 'hide'
  $("#adminArmsModal form input[type='submit']").on "click", ->
    $("#adminArmsModal iframe").show 'fast'
  $(".arms-set").click ->
    $("#adminArmsModal iframe").off("load").on "load", ->
      result = $(this).contents().find("img.result")
      if result.length
        PORTAL.configurationSettings.useArms = result.data("arms")
        PORTAL.configurationSettings.appTitle = result.data("title")
        PORTAL.configurationSettings.appLogo = result.attr("src")
        updateArms()
    $("#adminArmsModal").modal 'show'

updateArms = ->
  if (PORTAL.configurationSettings.useArms)
    $("#app_arms").attr("alt", PORTAL.configurationSettings.appOwner).attr("src", PORTAL.configurationSettings.appLogo)
    $("#app_title").text(PORTAL.configurationSettings.appOwner)
    $("#app_arms").toggle(PORTAL.configurationSettings.useArms)

prepareArmsModal = ->
  $("#adminArmsModal iframe").hide()
  $("#adminArmsModal iframe").attr "src", "about:blank"
  $("#adminArmsModal form input[type='reset']").click()
  $("#adminArmsModal form #armsUse").prop "checked", PORTAL.configurationSettings.useArms
  $("#adminArmsModal form #appTitle").val PORTAL.configurationSettings.appOwner