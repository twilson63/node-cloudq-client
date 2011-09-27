request = require 'request'

module.exports =
  url: null 
  uri: (queue) -> [@url, queue].join('/')

  # Queue job for processing...
  # callback (err, resp, body)
  queue: (queue, klass, args, cb) ->
    job = { job: { klass: klass, args: args} }
    request.post 
      uri: @uri(queue)
      json: job
      cb

  # Reserve job for processing...
  # callback (err, resp, body)
  reserve: (queue, cb) ->
    request { uri: @uri(queue), json: true }, cb

  # Complete job
  # callback (err, resp, body)
  complete: (queue, id, cb) ->
    request.del { uri: [@uri(queue), id].join('/'), json: true }, cb

