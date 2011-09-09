request = require 'request'
{ EventEmitter } = require 'events'

cloudq =
  url: null 
  watch: (interval, queue, cb) ->
    setInterval (@_get(queue, cb)), interval
    
  publish: (queue, job, cb) ->
    request
      uri: [@url, queue].join('/')
      method: 'POST'
      json: true
      body: JSON.stringify(job: job)
      (err, resp, body) ->
        cb(err, body)

  _get: (queue, cb) ->
    request 
      uri: [@url, queue].join '/'
      json: true
      (err, resp, body) ->
        cb err, body

  _complete: (queue, id, cb) ->
    request 
      uri: [@url, queue, id].join('/')
      method: 'DELETE'
      json: true
      (err, resp, body) -> cb(err, body)

  _work: (job, cb) ->
    #@emit 'work-job'
    require[job.klass].perform job.args, (err) ->
      @_complete job.id unless err
      cb err, 'completed'
      #@emit 'completed-job', job.id

# mixin EventEmitter
cloudq[k] = func for k, func of EventEmitter.prototype

exports.cloudq = cloudq