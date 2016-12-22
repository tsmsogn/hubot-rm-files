expect = require('chai').expect
path   = require 'path'

Robot       = require 'hubot/src/robot'
TextMessage = require('hubot/src/message').TextMessage

describe 'rm-files', ->
  robot = {}
  user = {}
  adapter = {}

  beforeEach (done) ->
    # Create new robot, without http, using mock adapter
    robot = new Robot null, 'mock-adapter', false

    robot.adapter.on 'connected', ->

      # load the module under test and configure it for the
      # robot. This is in place of external-scripts
      require('../src/rm-files')(robot)

      adapter = robot.adapter

      done()

    robot.run()

  afterEach ->
    robot.shutdown()
