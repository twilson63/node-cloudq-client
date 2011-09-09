{ cloudq } = require '../lib/cloudq'
cloudq.url = 'http://localhost:8000'

describe 'node cloudq client', ->
  it 'publish job success', ->
    cloudq.publish 'batcher', { klass: 'AwesomeSauce', args: ['12345', '12346'] }, (err, data) ->
      expect(data.status).toEqual('success')
      asyncSpecDone()
    asyncSpecWait()
  # it 'publish job fail', ->
  #   cloudq.publish 'foobar', null, (err, data) ->
  #     expect(err).toBeDefined()
  #     asyncSpecDone()
  #   asyncSpecWait()
  # it 'get job', ->
  #   cloudq._get 'foobar', (err, job) -> 
  #     expect(job.klass).toEqual('AwesomeSauce')
  #     asyncSpecDone()
  #   asyncSpecWait()
  # it 'complete job', ->
  #   cloudq._get 'foobar', (err, job) ->
  #     cloudq._complete 'foobar', job.id, (err, result) -> 
  #       expect(result.status).toEqual('success')
  #       asyncSpecDone()
  #   asyncSpecWait()
