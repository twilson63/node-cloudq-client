client = require '../index'
client.url = 'http://localhost:8000'

job_id = ""

describe 'Client', ->
  it '#queue', ->
    client.queue 'foobar', 'Patient', ['hello','world'], (err, resp, body) ->
      expect(body.status).toEqual('success')
      asyncSpecDone()
    asyncSpecWait()
  it '#reserve', ->
    client.reserve 'foobar', (err, resp, body) ->
      job_id = body._id
      expect(body.klass).toBeDefined()
      asyncSpecDone()
    asyncSpecWait()

  it '#complete', ->
    client.complete 'foobar', job_id, (err, resp, body) ->
      expect(body.status).toEqual('success')
      asyncSpecDone()
    asyncSpecWait()
    