(function() {
  var EventEmitter, cloudq, func, k, request, _ref;
  request = require('request');
  EventEmitter = require('events').EventEmitter;
  cloudq = {
    url: null,
    watch: function(interval, queue, cb) {
      return setInterval(this._get(queue, cb), interval);
    },
    publish: function(queue, job, cb) {
      return request({
        uri: [this.url, queue].join('/'),
        method: 'POST',
        json: true,
        body: JSON.stringify({
          job: job
        })
      }, function(err, resp, body) {
        return cb(err, body);
      });
    },
    _get: function(queue, cb) {
      return request({
        uri: [this.url, queue].join('/'),
        json: true
      }, function(err, resp, body) {
        return cb(err, body);
      });
    },
    _complete: function(queue, id, cb) {
      return request({
        uri: [this.url, queue, id].join('/'),
        method: 'DELETE',
        json: true
      }, function(err, resp, body) {
        return cb(err, body);
      });
    },
    _work: function(job, cb) {
      return require[job.klass].perform(job.args, function(err) {
        if (!err) {
          this._complete(job.id);
        }
        return cb(err, 'completed');
      });
    }
  };
  _ref = EventEmitter.prototype;
  for (k in _ref) {
    func = _ref[k];
    cloudq[k] = func;
  }
  exports.cloudq = cloudq;
}).call(this);
