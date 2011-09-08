request = require 'request'
{ EventEmitter } = require 'events'

cloudq =
  url: null 
  watch: (interval, queue, cb) ->
    @on 'completed-job', (id) -> @_complete(id)
    @on 'error-job', (err) -> console.log(err)

    setInterval _get(queue, @_work(job)), interval

  publish: (queue, job, cb) ->
    request
      uri: [@url, queue].join('/')
      method: 'POST'
      json: true
      body: JSON.stringify(job: job)
      (err, resp, body) ->
        cb(err, body)

  _get: (queue, cb) ->
    # request job from queue
    #my_emit = @emit
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

  _work: (job) ->
    emit 'work-job'
    require[job.klass].perform job.args, (err) ->
      @_complete job.id unless err
      emit 'completed-job', job.id

# mixin EventEmitter
cloudq[k] = func for k, func of EventEmitter.prototype

exports.cloudq = cloudq