#= require_self

directives = angular.module('timekeeper.directives', ['timekeeper.templates'])

directives.directive 'tkEventCalendar', ['ui.config', '$parse', (uiConfig, $parse) ->
  uiConfig.uiCalendar = uiConfig.uiCalendar || {}

  #  returns the fullcalendar
  return {
    require: 'ngModel'
    restrict: 'A'

    link: (scope, elm, $attrs) ->
      eventOptions = scope.$eval($attrs.eventOptions)
#      console.log "$attr parse", eventOptions

      update = () ->
        options =
          header:
            left: 'prev,next today'
            center: 'title'
            right: 'month,basicWeek'

          editable: true
          disableResizing: true
          droppable: true
          weekends: false
          firstDay: 1
          defaultView: 'basicWeek'
          events: eventOptions.events

          # calendar callbacks
#          eventMouseover: (event, jsEvent, view) ->
#            $(jsEvent.target).attr('title', event.title)

          dayClick: (date, allDay, jsEvent, view) ->
            scope.$apply ->
              eventOptions.onDayClick(date, allDay, jsEvent, view) if angular.isFunction(eventOptions.onDayClick)

          eventClick: (event, jsEvent, view) ->
            scope.$emit 'showEventPopover', event: event, target: jsEvent.currentTarget

          drop: (day, allDay) ->
            scope.$apply ->
              eventOptions.onDrop(day, allDay) if angular.isFunction(eventOptions.onDrop)

          eventDrop: (event, dayDelta, minuteDelta, allDay, revertFunc, jsEvent, ui, view) ->
            scope.$apply ->
               eventOptions.onEventDrop(event, dayDelta) if angular.isFunction(eventOptions.onEventDrop)

        options.eventRender = eventOptions.onEventRender if angular.isFunction(eventOptions.onEventRender)

        # if attrs have been entered to the directive, then create a relative expression.
        if ($attrs.tkEventCalendar)
          expression = scope.$eval($attrs.tkEventCalendar)
        else
          expression = {}

        # extend the options to suite the custom directive.
        angular.extend(options, uiConfig.uiCalendar, expression)

        # call fullCalendar from an empty html tag, to keep angular happy.
        # console.log("new cal:", options)
        elm.html('').fullCalendar(options)

      # on load update call.
      update()

      refresh = ->
        elm.fullCalendar('refetchEvents')

      scope.$watch( eventOptions.eventsWatcher, refresh)
  }
]

# initializes draggable on element. on-stop & on-start attributes are evaluated on drag start & stop.
directives.directive 'tkDraggable', () ->
  return {
    restrict: 'A'
    link: (scope, elm, $attrs) ->
      elm.draggable
        zIndex: 999
        revert: true
        revertDuration: 0
        start: (event, ui) ->
          scope.$apply ->
            scope.$eval($attrs.onStart)
        stop: (event, ui) ->
          scope.$apply ->
            scope.$eval($attrs.onStop)

  }

# watch for showProgress and hideProgress messages and update display
directives.directive 'tkInProgress', ['$rootScope', '$timeout', 'INPROGRESS_TEMPLATE', ($rootScope, $timeout, INPROGRESS_TEMPLATE) ->
  factory =
    restrict: 'E'
    templateUrl: INPROGRESS_TEMPLATE
    scope: true
    replace: true
    link: (scope, elm, $attrs) ->
      pendingTimeout = null

      hide = ->
        elm.fadeOut()

      show = ->
        elm.show()

      $rootScope.$on 'showProgress', (event, options = {}) ->
        #console.log "showProgress", options
        $timeout.cancel pendingTimeout if pendingTimeout
        scope.title = options.title || 'Working...'
        pendingTimeout = $timeout show, 200, false

      $rootScope.$on 'hideProgress', (event, options = {}) ->
        #console.log "hideProgress", options
        $timeout.cancel pendingTimeout if pendingTimeout
        if options.slow
          pendingTimeout = $timeout hide, 500, false
        else
          hide()
]

directives.directive 'tkError', ['$rootScope', 'ERROR_TEMPLATE', ($rootScope, TEMPLATEURL) ->
  factory =
    restrict: 'E'
    templateUrl: TEMPLATEURL
    scope: true
    replace: true
    link: (scope, elm, $attrs) ->
      scope.onToggleShowDetails = ->
        scope.showDetails = !scope.showDetails
        scope.detailButtonText = if scope.showDetails
          'Less Details'
        else
          'More Details'

      $rootScope.$on 'showError', (event, options) ->
        scope.$emit 'hideProgress'
        scope.title = options.title
        scope.description = options.description
        scope.details = options.details || []
        scope.showDetails = true
        scope.onToggleShowDetails()
        scope.hasDetails = scope.details.length > 0
        elm.modal('show')

      $rootScope.$on 'hideError', (event, options = {}) ->
        elm.modal('hide')
]

directives.directive 'tkEventPopup', ['EVENT_POPUP_TEMPLATE', (TEMPLATEURL) ->
  factory =
    restrict: 'E'
    replace: true,
    templateUrl: TEMPLATEURL
]

directives.directive 'tkEventPopover', ['$rootScope', '$compile', '$document', ($rootScope, $compile, $document) ->
  template = '<tk-event-popup></tk-event-popup>'

  factory =
    restrict: 'E'

    scope:
      onRemoveEvent: '&'

    controller: ['$scope', ($scope) ->
      $scope.removeEvent = ->
        $scope.close()
        #console?.log "removeEvent", $scope.event
        $scope.event.remove().then (result) ->
          #console?.log "success"
          $scope.onRemoveEvent()
        , (error) ->
          $scope.$emit 'showError',
                      title: 'Error deleting event'
                      description: 'Your event could not be deleted. Please try again.'
                      details: [JSON.stringify error]
          console?.log "failed:", error
    ]

    link: (scope) ->
      compiled = $compile( template )
      popover = null

      getPosition = (element) ->
        offset =
          width: element.prop( 'offsetWidth' )
          height: element.prop( 'offsetHeight' )
          top: element.prop( 'offsetTop' )
          left: element.prop( 'offsetLeft' )

      removePopover = ->
        popover.remove() if popover
        popover = null

      scope.close = ->
        removePopover()

      $rootScope.$on 'showEventPopover', (ngEvent, options) ->
        #console.log "showEventPopover", options

        removePopover()

        popover = compiled(scope)

        scope.$apply ->
          scope.event = options.event

        target = angular.element(options.target)

        # Set the initial positioning.
        popover.css({ top: 0, left: 0, display: 'block' })

        # Now we add it to the DOM because need some info about it. But it's not
        # visible yet anyway.
        target.after( popover )

        # Get the position of the target element.
        position = getPosition(target)

        bounds =
          top: $document.scrollTop()
          left: $document.scrollLeft()
          right: angular.element('body').width()
          bottom: angular.element('body').height()

        # Get the height and width of the popover so we can center it.
        actualWidth = popover.prop( 'offsetWidth' )
        actualHeight = popover.prop( 'offsetHeight' )

        # Calculate the popover's top and left coordinates to center it with
        # this directive.
        elementAbove =
          top: position.top - actualHeight
          left: position.left + position.width / 2 - actualWidth / 2

        elementBelow =
          top: position.top + position.height
          left: position.left + position.width / 2 - actualWidth / 2

        elementRight =
          top: (position.top + position.height / 2 - actualHeight / 2)
          left: (position.left + position.width)

        elementLeft =
          top: (position.top + position.height / 2 - actualHeight / 2)
          left: (position.left - actualWidth)

        isWithinBounds = (elementPosition) ->
          bounds.top < elementPosition.top and bounds.left < elementPosition.left and bounds.right > (elementPosition.left + actualWidth) and bounds.bottom > (elementPosition.top + actualHeight)

        if isWithinBounds(elementRight)
          newPosition = elementRight
          side = 'right'
        else if isWithinBounds(elementLeft)
          newPosition = elementLeft
          side = 'left'
        else if isWithinBounds(elementBelow)
          newPosition = elementBelow
          side = 'bottom'
        else
          newPosition = elementAbove
          side = 'top'

        newPosition.top += 'px'
        newPosition.left += 'px'

        scope.$apply ->
          scope.side = side

        # Now set the calculated positioning.
        popover.css(newPosition)
]


directives.directive 'tkSelect2', ->
  factory =
    require: '?ngModel'
    restrict: 'ACE'
    link: (scope, elm, $attrs, controller) ->
      scope.$watch $attrs.collection, (data = []) ->
        setTimeout ->
          options =
            data: data
            initSelection: (element, callback) ->
              callback(scope.$eval($attrs.ngModel))

          # if attrs have been entered to the directive, then create a relative expression.
          if ($attrs.tkSelect2)
            expression = scope.$eval($attrs.tkSelect2)
          else
            expression = {}

          # extend the options to suite the custom directive.
          angular.extend(options, expression)

          #console.log "watch", data
          elm.select2(options)

      elm.bind "change", () ->
        scope.$apply ->
          controller.$setViewValue(elm.select2('data'))

      scope.$watch $attrs.ngModel, (value) ->
        #console.log "tkSelect2: ngModel", value
        elm.select2('val', value)

directives.directive 'tkSpreadsheet', ->
  factory =
    restrict: 'ACE'
    link: (scope, elm, $attrs) ->
      setTimeout ->
        elm.html('').wijspread({sheetCount:1})
        spread = elm.wijspread("spread")
        sheet = spread.getActiveSheet()
        sheet.setDataSource(scope.$eval($attrs.collection))

directives.directive 'tkGrid', ->
  factory =
    restrict: 'ACE'
    link: (scope, elm, $attrs) ->
      options =
        allowColSizing: true
        allowSorting: true

      # if attrs have been entered to the directive, then create a relative expression.
      if ($attrs.tkGrid)
        expression = scope.$eval($attrs.tkGrid)
      else
        expression = {}

      # extend the options to suite the custom directive.
      angular.extend(options, expression)

      setTimeout ->
        elm.wijgrid(options)

directives.directive 'tkDateFromNow', ->
  factory =
    restrict: 'A'
    link: (scope, elm, $attrs) ->
      $attrs.$observe 'tkDateFromNow', (date) ->
        text = moment(date).fromNow() if date?
        elm.text(text)

directives.directive 'tkDateFormat', ->
  factory =
    restrict: 'A'
    link: (scope, elm, $attrs) ->
      $attrs.$observe 'tkDateFormat', (date) ->
        text = moment(date).format($attrs.format) if date?
        elm.text(text)

# display a dialog message box asking for confirmation. if OK clicked the tk-confirm expression is evaluated
# configuration attributes are:
# title - title of the dialog box
# message - body of the dialog box
# <a href='#' tk-confirm='deleteEvent(event)' title='Delete {{event.name}}' message='Are you sure?'>
directives.directive 'tkConfirm', ['$dialog', ($dialog) ->
  factory =
    restrict: 'A'
    link: (scope, elm, attrs) ->
      startAction = ->
        console.log 'startAction', attrs
        title = attrs.title || 'Confirmation'
        message = attrs.messsage || 'Are you sure?'
        btns = [{result: false, label: 'Cancel'}, {result: true, label: 'OK', cssClass: 'btn-primary'}]
        $dialog.messageBox(title, message, btns).open().then (result) ->
          console.log 'result', result
          completeAction() if result

      completeAction = ->
        console.log 'completed'
        scope.$eval attrs.tkConfirm

      elm.on 'click', ->
        console.log 'clicked'
        scope.$apply ->
          startAction()

      scope.$on '$destroy', ->
        elm.off 'click'
]

directives.directive 'tkSpinner', ['$http', ($http) ->
  factory =
    restrict: 'E'
    replace: true
    scope: {}
    template: '<div ng-show="loading" id="spinnerG">\n<div id="blockG_1" class="spinner_blockG">\n  </div>\n  <div id="blockG_2" class="spinner_blockG">\n  </div>\n  <div id="blockG_3" class="spinner_blockG">\n  </div>\n</div>'
    link: (scope) ->
      inFlight = ->
        $http.pendingRequests.length

      scope.$watch inFlight, (count) ->
        scope.loading = count
]
