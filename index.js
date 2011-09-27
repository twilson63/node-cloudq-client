(function() {
  var request;
  request = require('request');
  module.exports = {
    url: null,
    uri: function(queue) {
      return [this.url, queue].join('/');
    },
    queue: function(queue, klass, args, cb) {
      var job;
      job = {
        job: {
          klass: klass,
          args: args
        }
      };
      return request.post({
        uri: this.uri(queue),
        json: job
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
        uri: [this.uri(queue), id].join('/'),
        json: true
      }, cb);
    }
  };
}).call(this);
