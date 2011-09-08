(function() {
  var EventEmitter, cloudq, func, k, request, _ref;
  request = require('request');
  EventEmitter = require('events').EventEmitter;
  cloudq = {
    url: null,
    watch: function(interval, queue, cb) {
      this.on('completed-job', function(id) {
        return this._complete(id);
      });
      this.on('error-job', function(err) {
        return console.log(err);
      });
      return setInterval(_get(queue, this._work(job)), interval);
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
    _work: function(job) {
      emit('work-job');
      return require[job.klass].perform(job.args, function(err) {
        if (!err) {
          this._complete(job.id);
        }
        return emit('completed-job', job.id);
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
