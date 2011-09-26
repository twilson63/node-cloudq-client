(function() {
  var request;
  request = require('request');
  module.exports = {
    url: null,
    this.uri: function(queue) {
      return [this.url, queue].join('/');
    },
    queue: function(queue, job, cb) {
      return request.post({
        uri: this.uri(queue),
        json: JSON.stringify({
          job: job
        })
      }, cb);
    },
    reserve: function(queue, cb) {
      return request({
        uri: this.uri(queue),
        json: true
      }, cb);
    },
    complete: function(queue, id, cb) {
      return request.del({
        uri: this.uri(queue),
        json: true
      }, cb);
    }
  };
}).call(this);
