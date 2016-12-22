# Description
#   Remove files
#
# Configuration:
#   HUBOT_RM_FILES_DAYS - The days to remove files created before that day
#   HUBOT_RM_FILES_API_TOKENS - A comma separate list of API tokens
#
# Commands:
#   hubot rm files (--dry-run)
#
# Notes:
#   commands are all transformed to lower case

Slack = require 'slack-node'
moment = require 'moment'
util = require 'util'

config =
  days: process.env.HUBOT_RM_FILES_DAYS
  api_tokens: process.env.HUBOT_RM_FILES_API_TOKENS

module.exports = (robot) ->

  unless config.api_tokens?
    robot.logger.warning 'The HUBOT_RM_FILES_API_TOKENS environment variable not set'

  if config.api_tokens?
    api_tokens = config.api_tokens.split ','
  else
    api_tokens = []

  if config.days?
    days = config.days
  else
    days = 90

  ts = moment().add(-(days), 'days').unix()

  robot.respond /rm files(| --dry-run)$/i, (msg) ->
    dry_run = msg.match[1].toLowerCase() != ''

    for api_token in api_tokens
      slack = new Slack(api_token)
      slack.api 'files.list', { ts_to: ts, count: 1000 }, (err, response) ->
        if dry_run
          msg.send util.inspect(response.files, false, null)
        else
          for file in response.files
            msg.send "Deleting #{file.title}"
            slack.api 'files.delete', { file: file.id }, (err, response) ->
              msg.send util.inspect(response, false, null)
        return
