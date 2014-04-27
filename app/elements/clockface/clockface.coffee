Polymer "tock-clockface",
  time: 0
  timeChanged: ->
    seconds = Math.floor @time / 1000
    minutes = Math.floor seconds / 60
    hours = Math.floor seconds / 60
    @formattedTime = "#{ljust(minutes, 2, '0')}:#{ljust(seconds, 2, '0')}"
    if hours > 0
      @formattedTime = "#{ljust(hours,2,'0')}:#{formattedTime}"

  formattedTime: '00:00'

ljust = (string, minLength, padder = ' ') ->
  string = string.toString()
  paddingLength = minLength - string.length
  return string if paddingLength < 0
  new Array( paddingLength + 1 ).join(padder) + string


