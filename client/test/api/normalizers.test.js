import { normalizeJsonApi } from 'app/api/normalizers'

describe('api/normalizers', function() {
  it('normalize single JSON API resource', function() {
    const payload = {
      data: {
        id: '1',
        type: 'users',
        attributes: {
          firstName: 'David',
          lastName: 'Chen',
        },
      },
    }

    const normalized = {
      result: { id: '1', type: 'users' },
      entities: {
        users: {
          '1': {
            id: '1',
            firstName: 'David',
            lastName: 'Chen',
            assoc: {},
          },
        },
      },
    }

    expect(normalizeJsonApi(payload)).to.deep.equal(normalized)
  })

  it("normalize a list of JSON API resources", function() {
    const payload = {
      data: [{
        id: '1',
        type: 'users',
        attributes: {
          firstName: 'David',
          lastName: 'Chen',
        },
      }, {
        id: '2',
        type: 'users',
        attributes: {
          firstName: 'Berry',
          lastName: 'Tan',
        },
      }]
    }

    const normalized = {
      result: [{
        id: '1', type: 'users',
      }, {
        id: '2', type: 'users',
      }],
      entities: {
        users: {
          '1': {
            id: '1',
            firstName: 'David',
            lastName: 'Chen',
            assoc: {},
          },
          '2': {
            id: '2',
            firstName: 'Berry',
            lastName: 'Tan',
            assoc: {},
          }
        }
      }
    }

    expect(normalizeJsonApi(payload)).to.deep.equal(normalized)
  })

  it("normalize relationships", function() {
    const payload = {
      data: {
        id: '1',
        type: 'users',
        attributes: {
          firstName: 'David',
          lastName: 'Chen',
        },
        relationships: {
          profile: {
            data: { id: 'p1', type: 'profiles' },
          },
          appointments: {
            data: [{
              id: 'a1', type: 'appointments',
            }, {
              id: 'a2', type: 'appointments',
            }],
          },
        },
      },
      included: [{
        id: 'p1',
        type: 'profiles',
        attributes: {
          address: 'address 1',
        }
      }, {
        id: 'a1',
        type: 'appointments',
        attributes: {
          time: 'aaa',
        },
      }, {
        id: 'a2',
        type: 'appointments',
        attributes: {
          time: 'bbb',
        },
      }],
    }

    const normalized = {
      result: { id: '1', type: 'users' },
      entities: {
        users: {
          '1': {
            id: '1',
            firstName: 'David',
            lastName: 'Chen',
            assoc: {
              profile: { id: 'p1', type: 'profiles' },
              appointments: [{
                id: 'a1', type: 'appointments'
              }, {
                id: 'a2', type: 'appointments'
              }],
            }
          }
        },
        profiles: {
          'p1': {
            id: 'p1',
            address: 'address 1',
            assoc: {},
          }
        },
        appointments: {
          'a1': {
            id: 'a1',
            time: 'aaa',
            assoc: {},
          },
          'a2': {
            id: 'a2',
            time: 'bbb',
            assoc: {},
          }
        }
      }
    }

    expect(normalizeJsonApi(payload)).to.deep.equal(normalized)
  })
})
