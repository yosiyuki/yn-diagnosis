# Adds plugin object to jQuery
$.fn.extend
  # Change pluginName to your plugin's name.
  ynDiagnosis: (answers, options) ->
    # Default settings
    settings =
      wrapperClass: 'ynDiagnosis'
      contentClass: 'ynDiagnosisContent'
      textYes: 'Yes'
      textNo: 'No'
      debug: false
      yesBgColor: "#5CB85C"
      noBgColor: "#D9524F"

    # Merge default settings with options.
    settings = $.extend settings, options

    # Simple logger.
    log = (msg) ->
      console.log msg if settings.debug

    createNode = (data) ->
      content = $('<div>').addClass(settings.contentClass)
      content.append($('<div>').addClass('ynText').text(data.text))
      if data.yes
        buttons = $('<div>').addClass('ynButtons')
        buttons.append($('<a>').attr('href', '#').data('next', data.yes)
          .addClass('ynYes').text(settings.textYes)
          .click((self) -> selectYes(self)))
        buttons.append($('<a>').attr('href', '#').data('next', data.no)
          .addClass('ynNo').text(settings.textNo)
          .click((self) -> selectNo(self)))
        content.append(buttons)
      else
        content.addClass('ynResult')
      content

    selectYes = (ev) ->
      el = $(ev.target)
      prev = el.parents('.' + settings.contentClass)
      node = createNode(answers[el.data('next')])
      node.css('zIndex', prev.css('zIndex') * 1 + 1)
      if node.hasClass('ynResult')
        showResult(node, prev)
      else
        node.css('left', "-#{prev.css('width')}")
        prev.after(node)
        node.animate({ left: "+=" + prev.css('width') }, 500)

    selectNo = (ev) ->
      el = $(ev.target)
      prev = el.parents('.' + settings.contentClass)
      node = createNode(answers[el.data('next')])
      node.css('zIndex', prev.css('zIndex') * 1 + 1)
      if node.hasClass('ynResult')
        showResult(node, prev)
      else
        node.css('left', "#{prev.css('width')}")
        prev.before(node)
        node.animate({ left: "-=" + prev.css('width') }, 500)

    showResult = (node, prev) ->
      node.css('top', "-#{prev.css('height')}")
      log prev.css('height')
      prev.after(node)
      node.animate({ top: "+=#{prev.css('height')}" }, 1000)

    # _Insert magic here._
    return @each (target)->
      log "Preparing magic show."
      # You can use your settings in here now.
      log "Option 1 value: #{settings.option1}"

      log self
      log $(@)

      log answers

      wrapper = $('<div>').addClass(settings.wrapperClass)
      node = createNode(answers[0]).css('zIndex', 10)
      wrapper.append(node)
      $(@).append(wrapper)
