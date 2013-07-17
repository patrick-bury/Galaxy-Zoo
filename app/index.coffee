require 'lib/setup'

Config = require 'lib/config'
Spine = require 'spine'
Api = require 'zooniverse/lib/api'
Navigation = require 'controllers/navigation'
Main = require 'controllers/main'
Quizzes = require 'controllers/quizzes'
TopBar = require 'zooniverse/lib/controllers/top_bar'
googleAnalytics = require 'zooniverse/lib/google_analytics'
BrowserCheck = require 'zooniverse/lib/controllers/browser_check'

class App extends Spine.Controller
  constructor: ->
    super
   
    Api.init host: Config.apiHost
    @topBar = new TopBar
      el: '.zooniverse-top-bar'
      languages:
        en: 'English'
      app: 'galaxy_zoo_starburst'
      appName: 'Galaxy Zoo Quench'
    
    @navigation = new Navigation
    @main = new Main
    @quizzes = new Quizzes
    
    @append @navigation.active(), @main
    Spine.Route.setup()

preload = (image) ->
  img = new Image
  img.src = image

preload '/images/icons.png'
preload '/images/workflow.png'
preload '/images/examples.jpg'


project = Api.get "/projects/galaxy_zoo_starburst"

project.onSuccess (data) =>

  $(".classification_count").html (data.classification_count*100.0/60000.0).toFixed(1)

# googleAnalytics.init account: 'UA-1224199-9', domain: 'galaxyzoo.org'

(new BrowserCheck).check()

module.exports = App
