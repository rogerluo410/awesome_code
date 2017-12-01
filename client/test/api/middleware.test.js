import nock from 'nock'
import apiMiddleware from 'app/api/middleware'
import { callAPI } from 'app/api/actions'

describe('api/middleware', function() {
  const [pendingType, successType, failureType] = ['FETCH', 'FETCH_SUCCESS', 'FETCH_FAIL']

  function expectMultipleActions(actions) {
    let idx = 0

    return act => {
      if (idx === 0 || idx === 1) {
        expect(act).to.deep.equal(actions[idx])
        idx++
        return act
      }

      throw new Error('Unexpected 3rd action call!')
    }
  }

  it('handle success request', function() {
    nock('http://example.com')
      .get('/v1/users/1')
      .reply(200, {
        data: {
          id: '1',
          type: 'users',
          attributes: {
            firstName: 'David',
            lastName: 'Chen',
          },
        },
      })

    const action = callAPI({
      url: 'http://example.com/v1/users/1',
      actions: [pendingType, successType, failureType],
    })

    const next = expectMultipleActions([
      { type: pendingType },
      {
        type: successType,
        payload: { id: '1', type: 'users' },
        apiEntities: {
          users: {
            '1': {
              id: '1',
              firstName: 'David',
              lastName: 'Chen',
              assoc: {},
            },
          },
        },
      },
    ])

    return expect(apiMiddleware({})(next)(action)).to.eventually.deep.equal({
      id: '1',
      type: 'users',
    })
  })

  it("handle fail request", function() {
    nock('http://example.com')
      .get('/v1/users/1')
      .reply(422, {
        error: {
          message: "You do not have permission",
        },
      })

    const action = callAPI({
      url: 'http://example.com/v1/users/1',
      actions: [pendingType, successType, failureType],
    })

    const next = expectMultipleActions([
      { type: pendingType },
      {
        type: failureType,
        error: true,
        payload: {
          status: 422,
          message: "You do not have permission",
        },
      },
    ])

    return apiMiddleware({})(next)(action).catch(err => {
      expect(err).to.deep.equal({
        status: 422,
        message: "You do not have permission",
      })
    })
  })

  it("use custom normalizer", function() {
    nock('http://example.com')
      .get('/v1/users/1')
      .reply(200, {
        data: {
          id: 1,
          firstName: 'David',
          lastName: 'Chen',
        }
      })

    const action = callAPI({
      url: 'http://example.com/v1/users/1',
      actions: [pendingType, successType, failureType],
      normalizer: json => ({ result: '1', entities: '2' }),
    })

    const next = expectMultipleActions([
      { type: pendingType },
      {
        type: successType,
        payload: '1',
        apiEntities: '2',
      }
    ])

    return expect(apiMiddleware({})(next)(action)).to.eventually.deep.equal('1')
  })

})
