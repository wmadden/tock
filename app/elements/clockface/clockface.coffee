Polymer "tock-clockface",
  time: 0
  timeChanged: ->
    milliseconds = @time
    seconds = Math.round milliseconds / 1000

    if seconds == 0
      return "00:00"

    result = _([
      60, # 60 seconds in a minute
      60  # 60 minutes in an hour
    ]).map( (count) ->
      if seconds > 0
        n = seconds % count
        seconds = Math.floor seconds / count
        ljust(n, 2, '0')
    )
    @formattedTime = result.reverse().join(':')

  formattedTime: '00:00'

ljust = (string, minLength, padder = ' ') ->
  string = string.toString()
  paddingLength = minLength - string.length
  return string if paddingLength < 0
  new Array( paddingLength + 1 ).join(padder) + string


