# CloudQ Client for NodeJs

CloudQ is a service worker queue that enables job publishing and consuming anywhere.

This is a client connector library for nodejs, it is very simple and easy to use.

    cloudq = require 'cloudq'

    myjob =
      perform: (...args, cb) ->
        # Do Stuff

    cloudq.watch 5000, 'myqueue', (err, job) ->
      console.log 'Got Job Now Do Something'
      cloudq.consume job, (err) ->
        cloudq.complete job.id
