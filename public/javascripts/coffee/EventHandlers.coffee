PORTAL.Handlers = {}


PORTAL.Handlers.treeClick = (element) ->
  element.parent().siblings().toggle()
  element.parent().children("i.icon-plus, i.icon-minus").toggleClass("icon-plus").toggleClass("icon-minus")


PORTAL.Handlers.sort = (element) ->
  element.sortable { stop: PORTAL.Utils.sortLayers  }


PORTAL.Handlers.layerToggled = (element) ->
  if priv.areAllLayersActivated element.parents(".tier2_content")
    priv.setChecked element, ".tier2", ".wms-toggler", true
  if priv.areAllLayersDeactivated element.parents(".tier2_content")
    priv.setChecked element, ".tier2", ".wms-toggler", false
  layer = PORTAL.Utils.findLayer PORTAL.Utils.buildIdWithPrefix element.attr("id"), "layer"
  if layer==null
    return
  layer.setVisibility element.is(":checked")


PORTAL.Handlers.wmsToggled = (element) ->
  if element.is(":checked")
    priv.setChecked element, ".tier2", ".layer-toggler", true
  else if priv.areAllLayersActivated element.parents(".tier2").children(".tier2_content")
    priv.setChecked element, ".tier2", ".layer-toggler", false
  if priv.areAllWmsActivated element.parents(".tier1_content")
    priv.setChecked element, ".tier1", ".source-toggler", true
  if priv.areAllWmsDeactivated element.parents(".tier1_content")
    priv.setChecked element, ".tier1", ".source-toggler", false


PORTAL.Handlers.sourceToggled = (element) ->
  if element.is(":checked")
    priv.setChecked element, ".tier1", ".wms-toggler", true
  else if priv.areAllWmsActivated element.parents(".tier1").children(".tier1_content")
    priv.setChecked element, ".tier1", ".wms-toggler", false


PORTAL.Handlers.removeWms = (removeIcon) ->
  olIndicies = []
  removeIcon.parents(".tier2").children(".tier2_content").find("input").each (i, layer) ->
    olIndicies.push PORTAL.Utils.buildIdWithPrefix( layer.id, "layer" )
  PORTAL.Utils.removeLayer index for index in olIndicies
  removeIcon.parents(".tier2").remove()


priv = {}

priv.setChecked = (element, tier, togglers, haveToBeChecked) ->
  $(element).parents(tier).find(togglers).each (i, toggler) ->
    oldState = $(toggler).is(":checked")
    $(toggler).attr "checked", haveToBeChecked
    if oldState!=$(toggler).is(":checked")
      $(toggler).change()

priv.areAllWmsActivated = (tier1Content) -> priv.areAllChecked tier1Content, ".wms-toggler", true
priv.areAllWmsDeactivated = (tier1Content) -> priv.areAllChecked tier1Content, ".wms-toggler", false
priv.areAllLayersActivated = (tier2Content) -> priv.areAllChecked tier2Content, ".layer-toggler", true
priv.areAllLayersDeactivated = (tier2Content) -> priv.areAllChecked tier2Content, ".layer-toggler", false

priv.areAllChecked = (tierContent, togglers, haveToBeChecked) ->
  result = true
  $(tierContent).find(togglers).each (i, e) ->
    if $(e).is(":checked")!=haveToBeChecked
      result = false
  result
