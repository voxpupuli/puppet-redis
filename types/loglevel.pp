# @summary Specify the server verbosity level.
# This can be one of:
# * debug (a lot of information, useful for development/testing)
# * verbose (many rarely useful info, but not a mess like the debug level)
# * notice (moderately verbose, what you want in production probably)
# * warning (only very important / critical messages are logged)
type Redis::LogLevel = Enum['debug', 'verbose', 'notice', 'warning']
