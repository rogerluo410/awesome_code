api document
--------------

### registration

- login (GET '/v1/auth/login')

~~~
{
  "data": {
        "id": 21,
        "name": "David Grimes",
        "type": "Patient",
        "avatar_url": "/static/user_default_profile.jpg",
        "auth_token": "12705dba-8af9-4506-9faf-f29455368a8a"
        }
}
~~~

- Register (POST  '/v1/auth/register')

~~~
body:

{
  "data": {
     "email": "xxxx@xxx.com"
  }
}
~~~

response:
~~~
{
  "data": {
         "id": 21,
         "name": "David Grimes",
         "type": "Patient",
         "avatar_url": "/static/user_default_profile.jpg",
         "auth_token": "12705dba-8af9-4506-9faf-f29455368a8a"
    }
}
~~~


### Search Doctors

- doctors (GET 'v1/doctors')

~~~
{
  "date": "2016-06-15",
  "from": "07",
  "to": "12",
  "page": "1"
  "tz": "Australia/Lord_Howe"
  "q": 'Messi'
}
~~~

~~~
{
  "data": [
    {
      id: 10,
      is_available_now: false,
      name: "Tremayne Mertz",
      avatar_url: "/static/user_default_profile.jpg",
      total_patient_count: 0,
      specialty_name: "Physiotherapist",
      bio_info: "Repellat voluptas accusamus enim sit. Vitae alias ut assumenda tempore quasi quidem laudantium. Consequatur placeat itaque qui corrupti repellendus dolores similique. Illo magni quia adipisci tempore.",
      years_experience: "9.0",
      specialty_id: 4,
      appointment_periods: [
        {
          id: 65,
          start_time: "2016-06-21T01:00:00.000+09:30",
          end_time: "2016-06-21T02:00:00.000+09:30",
          week_day: "tuesday",
          available_slots: 0
        }
      ],
      total_available_slots: 0
    },,
    ...
  ],
  "meta": {
    "next_page": null,
    "prev_page": null,
    "current_page": 1,
    "total_pages": 1,
    "total_count": 8
  }
}
~~~

- Get doctor (GET '/v1/doctors/:id/profile')

request headers:
~~~
headers: {
  Authorization: "12705dba-8af9-4506-9faf-f29455368a8a"
}
~~~

response:
~~~
{
  "data": {
    "id": 2,
    "name": "Landen Kohler",
    "type": "Doctor",
    "avatar_url": "https://helloe-care-development.s3-ap-southeast-2.amazonaws.com/doctor/2/p1.png?X-Amz-Expires=600&X-Amz-Date=20160810T083807Z&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAJZQVDWCWLYNDBETA/20160810/ap-southeast-2/s3/aws4_request&X-Amz-SignedHeaders=host&X-Amz-Signature=d34332e69d4f12c19eb42b57bc106f37f7186185224cf8e537d8e62f62f1decf",
    "time_zone": "Australia/Currie",
    "specialty_name": "General Practitioner",
    "is_available_now": false,
    "years_experience": "4.0",
    "total_patient_count": 0,
    "created_at": "2016-07-27T02:43:08.247Z",
    "bio_info": "Quod quae sint tempore voluptate aut voluptatem nesciunt omnis. Doloremque aspernatur eligendi error rem qui sit. Labore ex voluptatem similique modi aut nemo asperiores amet."
  }
}
~~~

- Get doctors' appointment periods (GET   '/v1/doctors/:id/appointment_periods')

request headers:
~~~
headers: {
  Authorization: "12705dba-8af9-4506-9faf-f29455368a8a"
}
~~~

body:
~~~
{
  "date": "xxxxx",
  "timezone": "Australia/Sydney"
}
~~~

response:
~~~
{
  "data": [
    {
      "id": 141,
      "price": 49.95,
      "start_time": "2016-07-13T22:00:00.000+10:00",
      "end_time": "2016-07-13T23:00:00.000+10:00",
      "remain_slots": 0,
      "booked_slots": 0
    }
  ]
}
~~~

### User

- user (GET '/v1/user)

request headers:
~~~
headers: {
  Authorization: "12705dba-8af9-4506-9faf-f29455368a8a"
}
~~~

response:
~~~
{
  "data": {
         "id": 21,
         "name": "David Grimes",
         "type": "Patient",
         "avatar_url": "/static/user_default_profile.jpg",
         "auth_token": "12705dba-8af9-4506-9faf-f29455368a8a"
    }
}
~~~

- specialties (GET '/v1/specialties')

~~~
{
  "data": [
    {
      "id": 1,
      "name": "Endocrinology"
    },
    ....
    ]
}
~~~

### Notifications

- notifications (GET '/v1/notificaions')

request headers:
~~~
headers: {
  Authorization: "12705dba-8af9-4506-9faf-f29455368a8a"
}
~~~

response:
~~~
{
  "data": [
    {
      "id": 24,
      "title": "Your appointment is handle by doctor Lonnie Stoltenberg",
      "body": "enim",
      "is_read": false,
      "resource_type": "Patient",
      "resource_id": 38,
      "n_type": "appointing"
    },
    ....
  ],
  "meta": {
    "unread_count": 8,
    "next_cursor": 22
  }

}
~~~

- Update notification as read  (PATCH   '/v1/notifications/:id/mark_read')

request headers:
~~~
headers: {
  Authorization: "12705dba-8af9-4506-9faf-f29455368a8a"
}
~~~

response:
~~~
{
  "data":
    {
      "id": 24,
      "title": "Your appointment is handle by doctor Lonnie Stoltenberg",
      "body": "enim",
      "is_read": false,
      "resource_type": "Patient",
      "resource_id": 38,
      "n_type": "appointing"
    }
}
~~~

### conference

- new conference (POST '/v1/conferences')

request headers:
~~~
headers: {
  Authorization: "12705dba-8af9-4506-9faf-f29455368a8a"
}
~~~

body:
~~~
{
  "appointment_id": "1",
}
~~~

response:
~~~
{
 data: {
   conference_id: 1,
   patient: {
    "id": 1,
    "name": 'patient one',
    "type": "Patient",
    "avatar_url": "/static/user_default_profile.jpg",
    "time_zone": "xxxx-xx-xx xx:xx:xx"
    }
  }
}
~~~

- update conference (PUT '/v1/conferences/:id')

request headers:
~~~
headers: {
  Authorization: "12705dba-8af9-4506-9faf-f29455368a8a"
}
~~~

body:
~~~
{
  "update_type": "1",
  "status": 'xxx'
  "twilio_id": '2',
  "time_type": 'xxxx'
}
~~~

response:
~~~
{
  data: {
      {
        message: :success
      }
    }
}
~~~

- notify conference (POST '/v1/conferences/notify')

request headers:
~~~
headers: {
  Authorization: "12705dba-8af9-4506-9faf-f29455368a8a"
}
~~~

body:
~~~
{
  "appointment_id": "1"
}
~~~

response:
~~~
{
  data: {
      {
        "message": "success"
      }
    }
}
~~~

- token of conference (POST '/v1/conferences/token')

request headers:
~~~
headers: {
  Authorization: "12705dba-8af9-4506-9faf-f29455368a8a"
}
~~~

body:
~~~
{
  "appointment_id": "1"
}
~~~

response:
~~~
{
  data:
    {
      "token": "xxxxxxxxxxxxxxxxxxxxxxxxx"
    }
}
~~~

- can start call (GET '/v1/conferences/can_start_call/:appointment_id')

request headers:
~~~
headers: {
  Authorization: "12705dba-8af9-4506-9faf-f29455368a8a"
}
~~~

body:
~~~
{
  "appointment_id": "1"
}
~~~

response:
~~~
{
  data: {
      {
        "message": "success"
      }
    }
}
~~~

- decline call ( POST '/v1/conferences/decline_call/:appointment_id')

request headers:
~~~
headers: {
  Authorization: "12705dba-8af9-4506-9faf-f29455368a8a"
}
~~~

body:
~~~
{
  "appointment_id": "1"
}
~~~

response:
~~~
{
  data: {
      {
        "message": "success"
      }
    }
}
~~~


### Comment

- get comments  (GET '/v1/comments')

request headers:
~~~
headers: {
  Authorization: "12705dba-8af9-4506-9faf-f29455368a8a"
}
~~~

body:
~~~
{
  "appointment_id": "1"
}
~~~

response:
~~~
{
  "data": [
    {
      "id": "1",
      "type": "comments",
      "attributes": {
        "senderId": 23,
        "senderName": "Jaida Kuvalis",
        "body": "ts",
        "createdAt": "2016-08-08T15:09:22.000Z"
      },
      "relationships": {
        "appointment": {
          "data": {
            "id": "1",
            "type": "patAppointments"
          }
        }
      }
    }
  ]
}
~~~

- post comment (POST '/v1/comments')

request headers:
~~~
headers: {
  Authorization: "12705dba-8af9-4506-9faf-f29455368a8a"
}
~~~

body:
~~~
{
  "appointment_id": "1",
  "body": "test"
}
~~~

response:
~~~
{
  "data": {
    "id": "2",
    "type": "comments",
    "attributes": {
      "senderId": 21,
      "senderName": "Kayden Erdman",
      "body": "test",
      "createdAt": "2016-08-08T07:14:22.519Z"
    },
    "relationships": {
      "appointment": {
        "data": {
          "id": "3",
          "type": "patAppointments"
        }
      }
    }
  },
  "included": [
    {
      "id": "3",
      "type": "patAppointments",
      "attributes": {
        "status": "decline",
        "doctorId": 21,
        "doctorName": "Kayden Erdman",
        "doctorEmail": "doctor19@example.com",
        "doctorSpecialtyName": "General Practitioner",
        "doctorAvatarUrl": "/static/user_default_profile.jpg",
        "conferenceEndTime": null,
        "prescriptionsStatus": null,
        "prescriptionsPharmacyName": null
      },
      "relationships": {
        "medicalCertificate": {
          "data": null
        },
        "comments": {
          "data": [
            {
              "id": "2",
              "type": "comments"
            }
          ]
        },
        "prescriptions": {
          "data": []
        }
      }
    }
  ]
}
~~~


### Doctors

- get doctor bank account  (GET '/v1/d/bank_account')

request headers:
~~~
headers: {
  Authorization: "12705dba-8af9-4506-9faf-f29455368a8a"
}
~~~

response:
~~~
{
  "data": {
    "id": "7",
    "type": "bankAccounts",
    "attributes": {
      "userId": 2,
      "accountId": "acct_18f2JJJxuroAbwGl",
      "country": "AU",
      "currency": "aud",
      "accountHolderName": null,
      "accountHolderType": null,
      "bankName": "STRIPE TEST BANK",
      "last4": "3456",
      "routingNumber": "11 0000"
    }
  }
}
~~~

- destroy doctor Bank account (DELETE '/v1/d/bank_account')

request headers:
~~~
headers: {
  Authorization: "12705dba-8af9-4506-9faf-f29455368a8a"
}
~~~

response:
~~~
{
  "data": true
}
~~~

- create doctor Bank account (POST '/v1/d/bank_account')
request headers:
~~~
headers: {
  Authorization: "12705dba-8af9-4506-9faf-f29455368a8a"
}
~~~

body:
~~~
{
  "number": "000123456",
  "country": "Australia",
  "currency": "AUD"
}
~~~

response:
~~~
{
  "data": true
}
~~~


- get appointment settings (GET '/v1/d/appointment_settings')

request headers:
~~~
headers: {
  Authorization: "12705dba-8af9-4506-9faf-f29455368a8a"
}
~~~

response:
~~~
{
  "data": [
  {
  id: "Tus",
  periods: [
    {start_time: "09AM", end_time: "10AM"},
    {start_time: "10AM", end_time: "11AM"}
  ]
  }
}
~~~

- update appointment settings (PUT '/v1/d/appointment_settings/:id')

request headers:
~~~
headers: {
  Authorization: "12705dba-8af9-4506-9faf-f29455368a8a"
}
~~~

response:
~~~
{
  "data": [
  {
  id: "Tus",
  periods: [
    {start_time: "09AM", end_time: "10AM"}
  ]
  }
}
~~~

- Approve (PUT '/v1/d/appointments/:id/approve')

request headers:
~~~
headers: {
  Authorization: "12705dba-8af9-4506-9faf-f29455368a8a"
}
~~~

response:
~~~
{
  "data": [
    {
      "id": "23",
      "type": "docAppointments",
      "attributes": {
        "status": "finished",
        "periodStartTime": "2016-08-25T01:00:00.000Z",
        "periodEndTime": "2016-08-25T02:00:00.000Z",
        "consultationFee": "37.50",
        "paid": false,
        "patientFullName": "Roger Luo",
        "patientShortName": "RL",
        "conferenceEndTime": null
      },
      "relationships": {
        "survey": {
          "data": {
            "id": "13",
            "type": "surveys"
          }
        },
        "medicalCertificate": {
          "data": null
        },
        "comments": {
          "data": []
        },
        "prescriptions": {
          "data": []
        }
      }
    },
    {
      "id": "22",
      "type": "docAppointments",
      "attributes": {
        "status": "finished",
        "periodStartTime": "2016-08-25T01:00:00.000Z",
        "periodEndTime": "2016-08-25T02:00:00.000Z",
        "consultationFee": "37.50",
        "paid": false,
        "patientFullName": "Roger Luo",
        "patientShortName": "RL",
        "conferenceEndTime": null
      },
      "relationships": {
        "survey": {
          "data": {
            "id": "12",
            "type": "surveys"
          }
        },
        "medicalCertificate": {
          "data": null
        },
        "comments": {
          "data": []
        },
        "prescriptions": {
          "data": []
        }
      }
    },
    {
      "id": "21",
      "type": "docAppointments",
      "attributes": {
        "status": "finished",
        "periodStartTime": "2016-08-25T01:00:00.000Z",
        "periodEndTime": "2016-08-25T02:00:00.000Z",
        "consultationFee": "37.50",
        "paid": false,
        "patientFullName": "Roger Luo",
        "patientShortName": "RL",
        "conferenceEndTime": null
      },
      "relationships": {
        "survey": {
          "data": {
            "id": "11",
            "type": "surveys"
          }
        },
        "medicalCertificate": {
          "data": null
        },
        "comments": {
          "data": []
        },
        "prescriptions": {
          "data": []
        }
      }
    },
    {
      "id": "20",
      "type": "docAppointments",
      "attributes": {
        "status": "finished",
        "periodStartTime": "2016-08-25T01:00:00.000Z",
        "periodEndTime": "2016-08-25T02:00:00.000Z",
        "consultationFee": "37.50",
        "paid": false,
        "patientFullName": "Roger Luo",
        "patientShortName": "RL",
        "conferenceEndTime": null
      },
      "relationships": {
        "survey": {
          "data": {
            "id": "10",
            "type": "surveys"
          }
        },
        "medicalCertificate": {
          "data": null
        },
        "comments": {
          "data": []
        },
        "prescriptions": {
          "data": []
        }
      }
    },
    {
      "id": "19",
      "type": "docAppointments",
      "attributes": {
        "status": "finished",
        "periodStartTime": "2016-08-24T08:00:00.000Z",
        "periodEndTime": "2016-08-24T09:00:00.000Z",
        "consultationFee": "37.50",
        "paid": false,
        "patientFullName": "Roger Luo",
        "patientShortName": "RL",
        "conferenceEndTime": null
      },
      "relationships": {
        "survey": {
          "data": {
            "id": "9",
            "type": "surveys"
          }
        },
        "medicalCertificate": {
          "data": null
        },
        "comments": {
          "data": []
        },
        "prescriptions": {
          "data": []
        }
      }
    },
    {
      "id": "16",
      "type": "docAppointments",
      "attributes": {
        "status": "finished",
        "periodStartTime": "2016-08-11T09:00:00.000Z",
        "periodEndTime": "2016-08-11T10:00:00.000Z",
        "consultationFee": "49.95",
        "paid": false,
        "patientFullName": "Roger Luo",
        "patientShortName": "RL",
        "conferenceEndTime": null
      },
      "relationships": {
        "survey": {
          "data": {
            "id": "6",
            "type": "surveys"
          }
        },
        "medicalCertificate": {
          "data": null
        },
        "comments": {
          "data": []
        },
        "prescriptions": {
          "data": []
        }
      }
    },
    {
      "id": "15",
      "type": "docAppointments",
      "attributes": {
        "status": "finished",
        "periodStartTime": "2016-08-11T06:00:00.000Z",
        "periodEndTime": "2016-08-11T07:00:00.000Z",
        "consultationFee": "37.50",
        "paid": true,
        "patientFullName": "Roger Luo",
        "patientShortName": "RL",
        "conferenceEndTime": "2016-08-11T06:46:07.841Z"
      },
      "relationships": {
        "survey": {
          "data": {
            "id": "5",
            "type": "surveys"
          }
        },
        "medicalCertificate": {
          "data": {
            "id": "5",
            "type": "medicalCertificates"
          }
        },
        "comments": {
          "data": [
            {
              "id": "3",
              "type": "comments"
            },
            {
              "id": "4",
              "type": "comments"
            },
            {
              "id": "5",
              "type": "comments"
            },
            {
              "id": "6",
              "type": "comments"
            },
            {
              "id": "7",
              "type": "comments"
            },
            {
              "id": "8",
              "type": "comments"
            },
            {
              "id": "9",
              "type": "comments"
            },
            {
              "id": "10",
              "type": "comments"
            },
            {
              "id": "11",
              "type": "comments"
            },
            {
              "id": "12",
              "type": "comments"
            },
            {
              "id": "13",
              "type": "comments"
            },
            {
              "id": "14",
              "type": "comments"
            },
            {
              "id": "15",
              "type": "comments"
            }
          ]
        },
        "prescriptions": {
          "data": [
            {
              "id": "8",
              "type": "prescriptions"
            }
          ]
        }
      }
    },
    {
      "id": "14",
      "type": "docAppointments",
      "attributes": {
        "status": "finished",
        "periodStartTime": "2016-08-11T07:00:00.000Z",
        "periodEndTime": "2016-08-11T08:00:00.000Z",
        "consultationFee": "37.50",
        "paid": false,
        "patientFullName": "Roger Luo",
        "patientShortName": "RL",
        "conferenceEndTime": null
      },
      "relationships": {
        "survey": {
          "data": {
            "id": "4",
            "type": "surveys"
          }
        },
        "medicalCertificate": {
          "data": null
        },
        "comments": {
          "data": []
        },
        "prescriptions": {
          "data": []
        }
      }
    },
    {
      "id": "9",
      "type": "docAppointments",
      "attributes": {
        "status": "finished",
        "periodStartTime": "2016-08-11T06:00:00.000Z",
        "periodEndTime": "2016-08-11T07:00:00.000Z",
        "consultationFee": "37.50",
        "paid": false,
        "patientFullName": "Roger Luo",
        "patientShortName": "RL",
        "conferenceEndTime": null
      },
      "relationships": {
        "survey": {
          "data": null
        },
        "medicalCertificate": {
          "data": null
        },
        "comments": {
          "data": []
        },
        "prescriptions": {
          "data": []
        }
      }
    },
    {
      "id": "8",
      "type": "docAppointments",
      "attributes": {
        "status": "finished",
        "periodStartTime": "2016-08-11T06:00:00.000Z",
        "periodEndTime": "2016-08-11T07:00:00.000Z",
        "consultationFee": "37.50",
        "paid": false,
        "patientFullName": "Roger Luo",
        "patientShortName": "RL",
        "conferenceEndTime": null
      },
      "relationships": {
        "survey": {
          "data": null
        },
        "medicalCertificate": {
          "data": null
        },
        "comments": {
          "data": []
        },
        "prescriptions": {
          "data": []
        }
      }
    }
  ],
  "links": {}
}
~~~

- Decline  (PUT '/v1/d/appointments/:id/decline')

request headers:
~~~
headers: {
  Authorization: "12705dba-8af9-4506-9faf-f29455368a8a"
}
~~~

response:
~~~
{
  "data": [
    {
      "id": "23",
      "type": "docAppointments",
      "attributes": {
        "status": "finished",
        "periodStartTime": "2016-08-25T01:00:00.000Z",
        "periodEndTime": "2016-08-25T02:00:00.000Z",
        "consultationFee": "37.50",
        "paid": false,
        "patientFullName": "Roger Luo",
        "patientShortName": "RL",
        "conferenceEndTime": null
      },
      "relationships": {
        "survey": {
          "data": {
            "id": "13",
            "type": "surveys"
          }
        },
        "medicalCertificate": {
          "data": null
        },
        "comments": {
          "data": []
        },
        "prescriptions": {
          "data": []
        }
      }
    },
    {
      "id": "22",
      "type": "docAppointments",
      "attributes": {
        "status": "finished",
        "periodStartTime": "2016-08-25T01:00:00.000Z",
        "periodEndTime": "2016-08-25T02:00:00.000Z",
        "consultationFee": "37.50",
        "paid": false,
        "patientFullName": "Roger Luo",
        "patientShortName": "RL",
        "conferenceEndTime": null
      },
      "relationships": {
        "survey": {
          "data": {
            "id": "12",
            "type": "surveys"
          }
        },
        "medicalCertificate": {
          "data": null
        },
        "comments": {
          "data": []
        },
        "prescriptions": {
          "data": []
        }
      }
    },
    {
      "id": "21",
      "type": "docAppointments",
      "attributes": {
        "status": "finished",
        "periodStartTime": "2016-08-25T01:00:00.000Z",
        "periodEndTime": "2016-08-25T02:00:00.000Z",
        "consultationFee": "37.50",
        "paid": false,
        "patientFullName": "Roger Luo",
        "patientShortName": "RL",
        "conferenceEndTime": null
      },
      "relationships": {
        "survey": {
          "data": {
            "id": "11",
            "type": "surveys"
          }
        },
        "medicalCertificate": {
          "data": null
        },
        "comments": {
          "data": []
        },
        "prescriptions": {
          "data": []
        }
      }
    },
    {
      "id": "20",
      "type": "docAppointments",
      "attributes": {
        "status": "finished",
        "periodStartTime": "2016-08-25T01:00:00.000Z",
        "periodEndTime": "2016-08-25T02:00:00.000Z",
        "consultationFee": "37.50",
        "paid": false,
        "patientFullName": "Roger Luo",
        "patientShortName": "RL",
        "conferenceEndTime": null
      },
      "relationships": {
        "survey": {
          "data": {
            "id": "10",
            "type": "surveys"
          }
        },
        "medicalCertificate": {
          "data": null
        },
        "comments": {
          "data": []
        },
        "prescriptions": {
          "data": []
        }
      }
    },
    {
      "id": "19",
      "type": "docAppointments",
      "attributes": {
        "status": "finished",
        "periodStartTime": "2016-08-24T08:00:00.000Z",
        "periodEndTime": "2016-08-24T09:00:00.000Z",
        "consultationFee": "37.50",
        "paid": false,
        "patientFullName": "Roger Luo",
        "patientShortName": "RL",
        "conferenceEndTime": null
      },
      "relationships": {
        "survey": {
          "data": {
            "id": "9",
            "type": "surveys"
          }
        },
        "medicalCertificate": {
          "data": null
        },
        "comments": {
          "data": []
        },
        "prescriptions": {
          "data": []
        }
      }
    },
    {
      "id": "16",
      "type": "docAppointments",
      "attributes": {
        "status": "finished",
        "periodStartTime": "2016-08-11T09:00:00.000Z",
        "periodEndTime": "2016-08-11T10:00:00.000Z",
        "consultationFee": "49.95",
        "paid": false,
        "patientFullName": "Roger Luo",
        "patientShortName": "RL",
        "conferenceEndTime": null
      },
      "relationships": {
        "survey": {
          "data": {
            "id": "6",
            "type": "surveys"
          }
        },
        "medicalCertificate": {
          "data": null
        },
        "comments": {
          "data": []
        },
        "prescriptions": {
          "data": []
        }
      }
    },
    {
      "id": "15",
      "type": "docAppointments",
      "attributes": {
        "status": "finished",
        "periodStartTime": "2016-08-11T06:00:00.000Z",
        "periodEndTime": "2016-08-11T07:00:00.000Z",
        "consultationFee": "37.50",
        "paid": true,
        "patientFullName": "Roger Luo",
        "patientShortName": "RL",
        "conferenceEndTime": "2016-08-11T06:46:07.841Z"
      },
      "relationships": {
        "survey": {
          "data": {
            "id": "5",
            "type": "surveys"
          }
        },
        "medicalCertificate": {
          "data": {
            "id": "5",
            "type": "medicalCertificates"
          }
        },
        "comments": {
          "data": [
            {
              "id": "3",
              "type": "comments"
            },
            {
              "id": "4",
              "type": "comments"
            },
            {
              "id": "5",
              "type": "comments"
            },
            {
              "id": "6",
              "type": "comments"
            },
            {
              "id": "7",
              "type": "comments"
            },
            {
              "id": "8",
              "type": "comments"
            },
            {
              "id": "9",
              "type": "comments"
            },
            {
              "id": "10",
              "type": "comments"
            },
            {
              "id": "11",
              "type": "comments"
            },
            {
              "id": "12",
              "type": "comments"
            },
            {
              "id": "13",
              "type": "comments"
            },
            {
              "id": "14",
              "type": "comments"
            },
            {
              "id": "15",
              "type": "comments"
            }
          ]
        },
        "prescriptions": {
          "data": [
            {
              "id": "8",
              "type": "prescriptions"
            }
          ]
        }
      }
    },
    {
      "id": "14",
      "type": "docAppointments",
      "attributes": {
        "status": "finished",
        "periodStartTime": "2016-08-11T07:00:00.000Z",
        "periodEndTime": "2016-08-11T08:00:00.000Z",
        "consultationFee": "37.50",
        "paid": false,
        "patientFullName": "Roger Luo",
        "patientShortName": "RL",
        "conferenceEndTime": null
      },
      "relationships": {
        "survey": {
          "data": {
            "id": "4",
            "type": "surveys"
          }
        },
        "medicalCertificate": {
          "data": null
        },
        "comments": {
          "data": []
        },
        "prescriptions": {
          "data": []
        }
      }
    },
    {
      "id": "9",
      "type": "docAppointments",
      "attributes": {
        "status": "finished",
        "periodStartTime": "2016-08-11T06:00:00.000Z",
        "periodEndTime": "2016-08-11T07:00:00.000Z",
        "consultationFee": "37.50",
        "paid": false,
        "patientFullName": "Roger Luo",
        "patientShortName": "RL",
        "conferenceEndTime": null
      },
      "relationships": {
        "survey": {
          "data": null
        },
        "medicalCertificate": {
          "data": null
        },
        "comments": {
          "data": []
        },
        "prescriptions": {
          "data": []
        }
      }
    },
    {
      "id": "8",
      "type": "docAppointments",
      "attributes": {
        "status": "finished",
        "periodStartTime": "2016-08-11T06:00:00.000Z",
        "periodEndTime": "2016-08-11T07:00:00.000Z",
        "consultationFee": "37.50",
        "paid": false,
        "patientFullName": "Roger Luo",
        "patientShortName": "RL",
        "conferenceEndTime": null
      },
      "relationships": {
        "survey": {
          "data": null
        },
        "medicalCertificate": {
          "data": null
        },
        "comments": {
          "data": []
        },
        "prescriptions": {
          "data": []
        }
      }
    }
  ],
  "links": {}
}
~~~

- upcoming (GET '/v1/d/appointments/upcoming')

request headers:
~~~
headers: {
  Authorization: "12705dba-8af9-4506-9faf-f29455368a8a"
}
~~~

response:
~~~
{
  "data": {
    "id": "18",
    "type": "docAppointments",
    "attributes": {
      "status": "accepted",
      "periodStartTime": "2016-08-22T08:30:00.000Z",
      "periodEndTime": "2016-08-22T09:30:00.000Z",
      "consultationFee": "49.95",
      "paid": false,
      "patientFullName": "Roger Luo",
      "patientShortName": "RL",
      "conferenceEndTime": null
    },
    "relationships": {
      "survey": {
        "data": {
          "id": "8",
          "type": "surveys"
        }
      },
      "medicalCertificate": {
        "data": null
      },
      "comments": {
        "data": []
      },
      "prescriptions": {
        "data": []
      }
    }
  },
  "included": [
    {
      "id": "8",
      "type": "surveys",
      "attributes": {
        "fullName": "Roger Luo",
        "suburb": null,
        "age": null,
        "gender": "female",
        "streetAddress": null,
        "weight": null,
        "height": null,
        "occupation": null,
        "medicalCondition": null,
        "medications": null,
        "reason": "Prescription Refil",
        "reasonId": 1,
        "allergies": null
      }
    }
  ]
}
~~~


- finished (GET '/v1/d/appointments/finished')

request headers:
~~~
headers: {
  Authorization: "12705dba-8af9-4506-9faf-f29455368a8a"
}
~~~

response:
~~~
{
  "data": [
    {
      "id": "23",
      "type": "docAppointments",
      "attributes": {
        "status": "finished",
        "periodStartTime": "2016-08-25T01:00:00.000Z",
        "periodEndTime": "2016-08-25T02:00:00.000Z",
        "consultationFee": "37.50",
        "paid": false,
        "patientFullName": "Roger Luo",
        "patientShortName": "RL",
        "conferenceEndTime": null
      },
      "relationships": {
        "survey": {
          "data": {
            "id": "13",
            "type": "surveys"
          }
        },
        "medicalCertificate": {
          "data": null
        },
        "comments": {
          "data": []
        },
        "prescriptions": {
          "data": []
        }
      }
    },
    {
      "id": "22",
      "type": "docAppointments",
      "attributes": {
        "status": "finished",
        "periodStartTime": "2016-08-25T01:00:00.000Z",
        "periodEndTime": "2016-08-25T02:00:00.000Z",
        "consultationFee": "37.50",
        "paid": false,
        "patientFullName": "Roger Luo",
        "patientShortName": "RL",
        "conferenceEndTime": null
      },
      "relationships": {
        "survey": {
          "data": {
            "id": "12",
            "type": "surveys"
          }
        },
        "medicalCertificate": {
          "data": null
        },
        "comments": {
          "data": []
        },
        "prescriptions": {
          "data": []
        }
      }
    },
    {
      "id": "21",
      "type": "docAppointments",
      "attributes": {
        "status": "finished",
        "periodStartTime": "2016-08-25T01:00:00.000Z",
        "periodEndTime": "2016-08-25T02:00:00.000Z",
        "consultationFee": "37.50",
        "paid": false,
        "patientFullName": "Roger Luo",
        "patientShortName": "RL",
        "conferenceEndTime": null
      },
      "relationships": {
        "survey": {
          "data": {
            "id": "11",
            "type": "surveys"
          }
        },
        "medicalCertificate": {
          "data": null
        },
        "comments": {
          "data": []
        },
        "prescriptions": {
          "data": []
        }
      }
    },
    {
      "id": "20",
      "type": "docAppointments",
      "attributes": {
        "status": "finished",
        "periodStartTime": "2016-08-25T01:00:00.000Z",
        "periodEndTime": "2016-08-25T02:00:00.000Z",
        "consultationFee": "37.50",
        "paid": false,
        "patientFullName": "Roger Luo",
        "patientShortName": "RL",
        "conferenceEndTime": null
      },
      "relationships": {
        "survey": {
          "data": {
            "id": "10",
            "type": "surveys"
          }
        },
        "medicalCertificate": {
          "data": null
        },
        "comments": {
          "data": []
        },
        "prescriptions": {
          "data": []
        }
      }
    },
    {
      "id": "19",
      "type": "docAppointments",
      "attributes": {
        "status": "finished",
        "periodStartTime": "2016-08-24T08:00:00.000Z",
        "periodEndTime": "2016-08-24T09:00:00.000Z",
        "consultationFee": "37.50",
        "paid": false,
        "patientFullName": "Roger Luo",
        "patientShortName": "RL",
        "conferenceEndTime": null
      },
      "relationships": {
        "survey": {
          "data": {
            "id": "9",
            "type": "surveys"
          }
        },
        "medicalCertificate": {
          "data": null
        },
        "comments": {
          "data": []
        },
        "prescriptions": {
          "data": []
        }
      }
    },
    {
      "id": "16",
      "type": "docAppointments",
      "attributes": {
        "status": "finished",
        "periodStartTime": "2016-08-11T09:00:00.000Z",
        "periodEndTime": "2016-08-11T10:00:00.000Z",
        "consultationFee": "49.95",
        "paid": false,
        "patientFullName": "Roger Luo",
        "patientShortName": "RL",
        "conferenceEndTime": null
      },
      "relationships": {
        "survey": {
          "data": {
            "id": "6",
            "type": "surveys"
          }
        },
        "medicalCertificate": {
          "data": null
        },
        "comments": {
          "data": []
        },
        "prescriptions": {
          "data": []
        }
      }
    },
    {
      "id": "15",
      "type": "docAppointments",
      "attributes": {
        "status": "finished",
        "periodStartTime": "2016-08-11T06:00:00.000Z",
        "periodEndTime": "2016-08-11T07:00:00.000Z",
        "consultationFee": "37.50",
        "paid": true,
        "patientFullName": "Roger Luo",
        "patientShortName": "RL",
        "conferenceEndTime": "2016-08-11T06:46:07.841Z"
      },
      "relationships": {
        "survey": {
          "data": {
            "id": "5",
            "type": "surveys"
          }
        },
        "medicalCertificate": {
          "data": {
            "id": "5",
            "type": "medicalCertificates"
          }
        },
        "comments": {
          "data": [
            {
              "id": "3",
              "type": "comments"
            },
            {
              "id": "4",
              "type": "comments"
            },
            {
              "id": "5",
              "type": "comments"
            },
            {
              "id": "6",
              "type": "comments"
            },
            {
              "id": "7",
              "type": "comments"
            },
            {
              "id": "8",
              "type": "comments"
            },
            {
              "id": "9",
              "type": "comments"
            },
            {
              "id": "10",
              "type": "comments"
            },
            {
              "id": "11",
              "type": "comments"
            },
            {
              "id": "12",
              "type": "comments"
            },
            {
              "id": "13",
              "type": "comments"
            },
            {
              "id": "14",
              "type": "comments"
            },
            {
              "id": "15",
              "type": "comments"
            }
          ]
        },
        "prescriptions": {
          "data": [
            {
              "id": "8",
              "type": "prescriptions"
            }
          ]
        }
      }
    },
    {
      "id": "14",
      "type": "docAppointments",
      "attributes": {
        "status": "finished",
        "periodStartTime": "2016-08-11T07:00:00.000Z",
        "periodEndTime": "2016-08-11T08:00:00.000Z",
        "consultationFee": "37.50",
        "paid": false,
        "patientFullName": "Roger Luo",
        "patientShortName": "RL",
        "conferenceEndTime": null
      },
      "relationships": {
        "survey": {
          "data": {
            "id": "4",
            "type": "surveys"
          }
        },
        "medicalCertificate": {
          "data": null
        },
        "comments": {
          "data": []
        },
        "prescriptions": {
          "data": []
        }
      }
    },
    {
      "id": "9",
      "type": "docAppointments",
      "attributes": {
        "status": "finished",
        "periodStartTime": "2016-08-11T06:00:00.000Z",
        "periodEndTime": "2016-08-11T07:00:00.000Z",
        "consultationFee": "37.50",
        "paid": false,
        "patientFullName": "Roger Luo",
        "patientShortName": "RL",
        "conferenceEndTime": null
      },
      "relationships": {
        "survey": {
          "data": null
        },
        "medicalCertificate": {
          "data": null
        },
        "comments": {
          "data": []
        },
        "prescriptions": {
          "data": []
        }
      }
    },
    {
      "id": "8",
      "type": "docAppointments",
      "attributes": {
        "status": "finished",
        "periodStartTime": "2016-08-11T06:00:00.000Z",
        "periodEndTime": "2016-08-11T07:00:00.000Z",
        "consultationFee": "37.50",
        "paid": false,
        "patientFullName": "Roger Luo",
        "patientShortName": "RL",
        "conferenceEndTime": null
      },
      "relationships": {
        "survey": {
          "data": null
        },
        "medicalCertificate": {
          "data": null
        },
        "comments": {
          "data": []
        },
        "prescriptions": {
          "data": []
        }
      }
    }
  ],
  "links": {}
}
~~~

- find prescriptions (GET '/v1/d/appointments/:appointment_id/prescriptions')

request headers:
~~~
headers: {
  Authorization: "12705dba-8af9-4506-9faf-f29455368a8a"
}
~~~

response:
~~~
{
  "data": [
    {
      "id": "6",
      "type": "prescriptions",
      "attributes": {
        "appointmentId": 1,
        "pharmacyId": 51,
        "fileIdentifier": "HTTP_____.pdf",
        "fileUrl": "https://helloe-care-development.s3-ap-southeast-2.amazonaws.com/prescription/6/HTTP_____.pdf?X-Amz-Expires=600&X-Amz-Date=20160808T080210Z&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAJZQVDWCWLYNDBETA/20160808/ap-southeast-2/s3/aws4_request&X-Amz-SignedHeaders=host&X-Amz-Signature=d7e31ec631810fa7c4fee3c8b1c433abd0ef6ea99694c115bed2ee4684dc3012",
        "status": "delivered"
      },
      "relationships": {
        "appointment": {
          "data": {
            "id": "1",
            "type": "appointments"
          }
        }
      }
    },
    {
      "id": "7",
      "type": "prescriptions",
      "attributes": {
        "appointmentId": 1,
        "pharmacyId": 51,
        "fileIdentifier": "HTTP_____.pdf",
        "fileUrl": "https://helloe-care-development.s3-ap-southeast-2.amazonaws.com/prescription/7/HTTP_____.pdf?X-Amz-Expires=600&X-Amz-Date=20160808T080210Z&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAJZQVDWCWLYNDBETA/20160808/ap-southeast-2/s3/aws4_request&X-Amz-SignedHeaders=host&X-Amz-Signature=15bb8f0dacf87d8a34386a4fae8a89206257fa8c7bce1ad2f090999a9928e02e",
        "status": "delivered"
      },
      "relationships": {
        "appointment": {
          "data": {
            "id": "1",
            "type": "appointments"
          }
        }
      }
    }
  ]
}
~~~

- Create prescription (POST '/v1/d/appointments/:appointment_id/prescriptions')

request headers:
~~~
headers: {
  Authorization: "12705dba-8af9-4506-9faf-f29455368a8a"
}
~~~

~~~
body: {
  "file": "xxx.pdf"
}
~~~

response:
~~~
{
  "data":
    {
      "id": "6",
      "type": "prescriptions",
      "attributes": {
        "appointmentId": 1,
        "pharmacyId": 51,
        "fileIdentifier": "HTTP_____.pdf",
        "fileUrl": "https://helloe-care-development.s3-ap-southeast-2.amazonaws.com/prescription/6/HTTP_____.pdf?X-Amz-Expires=600&X-Amz-Date=20160808T080210Z&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAJZQVDWCWLYNDBETA/20160808/ap-southeast-2/s3/aws4_request&X-Amz-SignedHeaders=host&X-Amz-Signature=d7e31ec631810fa7c4fee3c8b1c433abd0ef6ea99694c115bed2ee4684dc3012",
        "status": "delivered"
      },
      "relationships": {
        "appointment": {
          "data": {
            "id": "1",
            "type": "appointments"
          }
        }
      }
    }
}
~~~

- DELETE prescription (DELETE '/v1/d/appointments/:appointment_id/prescriptions/:id')

request headers:
~~~
headers: {
  Authorization: "12705dba-8af9-4506-9faf-f29455368a8a"
}
~~~

response:
~~~
{
  "data":
    {
      "id": "6",
      "type": "prescriptions",
      "attributes": {
        "appointmentId": 1,
        "pharmacyId": 51,
        "fileIdentifier": "HTTP_____.pdf",
        "fileUrl": "https://helloe-care-development.s3-ap-southeast-2.amazonaws.com/prescription/6/HTTP_____.pdf?X-Amz-Expires=600&X-Amz-Date=20160808T080210Z&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAJZQVDWCWLYNDBETA/20160808/ap-southeast-2/s3/aws4_request&X-Amz-SignedHeaders=host&X-Amz-Signature=d7e31ec631810fa7c4fee3c8b1c433abd0ef6ea99694c115bed2ee4684dc3012",
        "status": "delivered"
      },
      "relationships": {
        "appointment": {
          "data": {
            "id": "1",
            "type": "appointments"
          }
        }
      }
    }
}
~~~

- Create medical certificate (POST '/v1/d/appointments/:appointment_id/medical_certificate')

request headers:
~~~
headers: {
  Authorization: "12705dba-8af9-4506-9faf-f29455368a8a"
}
~~~

response:
~~~
{
  "data": {
    "id": "4",
    "type": "medicalCertificates",
    "attributes": {
      "appointmentId": 1,
      "fileIdentifier": "http.pdf",
      "fileUrl": "https://helloe-care-development.s3-ap-southeast-2.amazonaws.com/medical_certificate/4/http.pdf?X-Amz-Expires=600&X-Amz-Date=20160808T081741Z&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAJZQVDWCWLYNDBETA/20160808/ap-southeast-2/s3/aws4_request&X-Amz-SignedHeaders=host&X-Amz-Signature=1b1faa8d5d5a2dc3bff29ce6256e556d66ac36279bbea9fe652930cb913c7b01"
    },
    "relationships": {
      "appointment": {
        "data": {
          "id": 1,
          "doctor_id": 21,
          "patient_id": 23,
          "status": "decline",
          "created_at": "2016-07-27T02:43:20.355Z",
          "updated_at": "2016-07-27T02:43:20.355Z",
          "appointment_product_id": 1,
          "consultation_fee": "49.95",
          "doctor_fee": "29.0",
          "job_id": null
        }
      }
    }
  }
}
~~~

- Show medical certificate (POST '/v1/d/appointments/:appointment_id/medical_certificate')

request headers:
~~~
headers: {
  Authorization: "12705dba-8af9-4506-9faf-f29455368a8a"
}
~~~

response:
~~~
{
  "data": {
    "id": "4",
    "type": "medicalCertificates",
    "attributes": {
      "appointmentId": 1,
      "fileIdentifier": "http.pdf",
      "fileUrl": "https://helloe-care-development.s3-ap-southeast-2.amazonaws.com/medical_certificate/4/http.pdf?X-Amz-Expires=600&X-Amz-Date=20160808T081741Z&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAJZQVDWCWLYNDBETA/20160808/ap-southeast-2/s3/aws4_request&X-Amz-SignedHeaders=host&X-Amz-Signature=1b1faa8d5d5a2dc3bff29ce6256e556d66ac36279bbea9fe652930cb913c7b01"
    },
    "relationships": {
      "appointment": {
        "data": {
          "id": 1,
          "doctor_id": 21,
          "patient_id": 23,
          "status": "decline",
          "created_at": "2016-07-27T02:43:20.355Z",
          "updated_at": "2016-07-27T02:43:20.355Z",
          "appointment_product_id": 1,
          "consultation_fee": "49.95",
          "doctor_fee": "29.0",
          "job_id": null
        }
      }
    }
  }
}
~~~

- Delete medical certificate (DELETE '/v1/d/appointments/:appointment_id/medical_certificate')

request headers:
~~~
headers: {
  Authorization: "12705dba-8af9-4506-9faf-f29455368a8a"
}
~~~

response:
~~~
{
  "data": {
    "id": "4",
    "type": "medicalCertificates",
    "attributes": {
      "appointmentId": 1,
      "fileIdentifier": "http.pdf",
      "fileUrl": "https://helloe-care-development.s3-ap-southeast-2.amazonaws.com/medical_certificate/4/http.pdf?X-Amz-Expires=600&X-Amz-Date=20160808T081741Z&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAJZQVDWCWLYNDBETA/20160808/ap-southeast-2/s3/aws4_request&X-Amz-SignedHeaders=host&X-Amz-Signature=1b1faa8d5d5a2dc3bff29ce6256e556d66ac36279bbea9fe652930cb913c7b01"
    },
    "relationships": {
      "appointment": {
        "data": {
          "id": 1,
          "doctor_id": 21,
          "patient_id": 23,
          "status": "decline",
          "created_at": "2016-07-27T02:43:20.355Z",
          "updated_at": "2016-07-27T02:43:20.355Z",
          "appointment_product_id": 1,
          "consultation_fee": "49.95",
          "doctor_fee": "29.0",
          "job_id": null
        }
      }
    }
  }
}
~~~

- Get Appointment by doctor (GET '/v1/d/appointments/:id')

request headers:
~~~
headers: {
  Authorization: "12705dba-8af9-4506-9faf-f29455368a8a"
}
~~~

response:
~~~
{
  "data": {
    "id": "1",
    "type": "docAppointments",
    "attributes": {
      "status": "decline",
      "periodStartTime": "2016-07-27T12:00:00.000Z",
      "periodEndTime": "2016-07-27T13:00:00.000Z",
      "consultationFee": "49.95",
      "paid": false,
      "patientFullName": "Jaida Kuvalis",
      "patientShortName": "JK",
      "conferenceEndTime": null
    },
    "relationships": {
      "survey": {
        "data": null
      },
      "medicalCertificate": {
        "data": {
          "id": "4",
          "type": "medicalCertificates"
        }
      },
      "comments": {
        "data": [
          {
            "id": "1",
            "type": "comments"
          }
        ]
      },
      "prescriptions": {
        "data": [
          {
            "id": "6",
            "type": "prescriptions"
          },
          {
            "id": "7",
            "type": "prescriptions"
          }
        ]
      }
    }
  },
  "included": [
    {
      "id": "4",
      "type": "medicalCertificates",
      "attributes": {
        "appointmentId": 1,
        "fileIdentifier": "http.pdf",
        "fileUrl": "https://helloe-care-development.s3-ap-southeast-2.amazonaws.com/medical_certificate/4/http.pdf?X-Amz-Expires=600&X-Amz-Date=20160808T082123Z&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAJZQVDWCWLYNDBETA/20160808/ap-southeast-2/s3/aws4_request&X-Amz-SignedHeaders=host&X-Amz-Signature=1198d2d7cf11a9135c3a0e7b82dbdcd2a2c07eaadc33569d3a12633879a662b2"
      },
      "relationships": {
        "appointment": {
          "data": {
            "id": 1,
            "doctor_id": 21,
            "patient_id": 23,
            "status": "decline",
            "created_at": "2016-07-27T02:43:20.355Z",
            "updated_at": "2016-07-27T02:43:20.355Z",
            "appointment_product_id": 1,
            "consultation_fee": "49.95",
            "doctor_fee": "29.0",
            "job_id": null
          }
        }
      }
    },
    {
      "id": "1",
      "type": "comments",
      "attributes": {
        "senderId": 23,
        "senderName": "Jaida Kuvalis",
        "body": "ts",
        "createdAt": "2016-08-08T15:09:22.000Z"
      },
      "relationships": {
        "appointment": {
          "data": {
            "id": "1",
            "type": "patAppointments"
          }
        }
      }
    },
    {
      "id": "6",
      "type": "prescriptions",
      "attributes": {
        "appointmentId": 1,
        "pharmacyId": 51,
        "fileIdentifier": "HTTP_____.pdf",
        "fileUrl": "https://helloe-care-development.s3-ap-southeast-2.amazonaws.com/prescription/6/HTTP_____.pdf?X-Amz-Expires=600&X-Amz-Date=20160808T082123Z&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAJZQVDWCWLYNDBETA/20160808/ap-southeast-2/s3/aws4_request&X-Amz-SignedHeaders=host&X-Amz-Signature=fcb964abd4cb652e7f26a95cb23f7d22e221da2263d7b26780b6b0fae9a32b97",
        "status": "delivered"
      },
      "relationships": {
        "appointment": {
          "data": {
            "id": "1",
            "type": "appointments"
          }
        }
      }
    },
    {
      "id": "7",
      "type": "prescriptions",
      "attributes": {
        "appointmentId": 1,
        "pharmacyId": 51,
        "fileIdentifier": "HTTP_____.pdf",
        "fileUrl": "https://helloe-care-development.s3-ap-southeast-2.amazonaws.com/prescription/7/HTTP_____.pdf?X-Amz-Expires=600&X-Amz-Date=20160808T082123Z&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAJZQVDWCWLYNDBETA/20160808/ap-southeast-2/s3/aws4_request&X-Amz-SignedHeaders=host&X-Amz-Signature=2ba35ec8f5b58cd5e485daa7ca93370d7a96146c05dd5d9213e62a7f8ca13b42",
        "status": "delivered"
      },
      "relationships": {
        "appointment": {
          "data": {
            "id": "1",
            "type": "appointments"
          }
        }
      }
    }
  ]
}
~~~

- Get scheduled (GET '/v1/d/appointment_products/scheduled')

request headers:
~~~
headers: {
  Authorization: "12705dba-8af9-4506-9faf-f29455368a8a"
}
~~~

response:
~~~
{
  "data": [
    {
      "id": "1",
      "type": "appointmentProducts",
      "attributes": {
        "startTime": "2016-08-07T14:00:00.000Z",
        "endTime": "2016-08-08T13:00:00.000Z"
      },
      "relationships": {
        "scheduledAppointments": {
          "data": []
        }
      }
    }
  ]
}
~~~

### Patients

-  Update Pay (PUT '/v1/p/appointments/:id/pay')

request headers:
~~~
headers: {
  Authorization: "12705dba-8af9-4506-9faf-f29455368a8a"
}
~~~

~~~
body:
{
  "appointment_id": "1",
  "checkout_id": "2"
}
~~~

response:
~~~
{
  "data": {
    "id": 5,
    "status": "pending",
    "doctor_id": 21,
    "doctor_name": "Kayden Erdman",
    "doctor_email": "doctor19@example.com",
    "doctor_specialty_name": "General Practitioner",
    "doctor_avatar_url": "/static/user_default_profile.jpg",
    "period_start_time": "2016-08-27T10:00:00.000Z",
    "period_end_time": "2016-07-27T11:00:00.000Z",
    "queue_before_me": "not in queue",
    "estimate_consult_time": "not in queue",
    "consultation_fee": "49.95",
    "paid": false,
    "survey_id": 3
  }
}
~~~

- Active appointments (GET  '/v1/p/appointments/active')

request headers:
~~~
headers: {
  Authorization: "12705dba-8af9-4506-9faf-f29455368a8a"
}
~~~

response:
~~~
{
  "data": {
    "id": 5,
    "status": "pending",
    "doctor_id": 21,
    "doctor_name": "Kayden Erdman",
    "doctor_email": "doctor19@example.com",
    "doctor_specialty_name": "General Practitioner",
    "doctor_avatar_url": "/static/user_default_profile.jpg",
    "period_start_time": "2016-08-27T10:00:00.000Z",
    "period_end_time": "2016-07-27T11:00:00.000Z",
    "queue_before_me": "not in queue",
    "estimate_consult_time": "not in queue",
    "consultation_fee": "49.95",
    "paid": false,
    "survey_id": 3
  }
}
~~~

- Finish appointments (GET  '/v1/p/appointments/finished')

request headers:
~~~
headers: {
  Authorization: "12705dba-8af9-4506-9faf-f29455368a8a"
}
~~~

response:
~~~
{
  "data": [
    {
      "id": 23,
      "status": "finished",
      "period_start_time": "2016-08-25T01:00:00.000Z",
      "period_end_time": "2016-08-25T02:00:00.000Z",
      "consultation_fee": "37.50",
      "paid": false,
      "patient_full_name": "Roger Luo",
      "patient_short_name": "RL",
      "conference_end_time": null,
      "pay_status": "unpaid",
      "survey": {
        "id": 13,
        "full_name": "Roger Luo",
        "suburb": null,
        "age": 43,
        "gender": "male",
        "street_address": "Guangbutun, Wuchang District, Wuhan",
        "weight": 79,
        "height": 187,
        "occupation": "Farmer",
        "medical_condition": "I cant eat everything",
        "medications": "As strong as a cow",
        "reason": "Prescription Refil",
        "reason_id": 1,
        "allergies": "I dont know what it is even"
      },
      "medical_certificate": null,
      "comments": [],
      "prescriptions": []
    },
    {
      "id": 22,
      "status": "finished",
      "period_start_time": "2016-08-25T01:00:00.000Z",
      "period_end_time": "2016-08-25T02:00:00.000Z",
      "consultation_fee": "37.50",
      "paid": false,
      "patient_full_name": "Roger Luo",
      "patient_short_name": "RL",
      "conference_end_time": null,
      "pay_status": "unpaid",
      "survey": {
        "id": 12,
        "full_name": "Roger Luo",
        "suburb": null,
        "age": 43,
        "gender": "male",
        "street_address": "Guangbutun, Wuchang District, Wuhan",
        "weight": 79,
        "height": 187,
        "occupation": "Farmer",
        "medical_condition": "I cant eat everything",
        "medications": "As strong as a cow",
        "reason": "Prescription Refil",
        "reason_id": 1,
        "allergies": "I dont know what it is even"
      },
      "medical_certificate": null,
      "comments": [],
      "prescriptions": []
    }
  ],
  "meta": {
    "next_page": 2,
    "prev_page": null,
    "current_page": 1,
    "total_pages": 5,
    "total_count": 10
  }
}
~~~

-  Refund (PUT  '/v1/p/appointments/:id/refund')

request headers:
~~~
headers: {
  Authorization: "12705dba-8af9-4506-9faf-f29455368a8a"
}
~~~

response:
~~~
{
  "data":  'success'
}
~~~

-  Transfer (PUT   '/v1/p/appointments/:id/transfer')

request headers:
~~~
headers: {
  Authorization: "12705dba-8af9-4506-9faf-f29455368a8a"
}
~~~

response:
~~~
{
  "data":  'success'
}
~~~

- prescription deliver (PUT  '/v1/p/appointments/:appointment_id/prescriptions/deliver')

request headers:
~~~
headers: {
  Authorization: "12705dba-8af9-4506-9faf-f29455368a8a"
}
~~~

response:
~~~
{
  "data": [
    {
      "id": "6",
      "type": "prescriptions",
      "attributes": {
        "appointmentId": 1,
        "pharmacyId": 51,
        "fileIdentifier": "HTTP_____.pdf",
        "fileUrl": "https://helloe-care-development.s3-ap-southeast-2.amazonaws.com/prescription/6/HTTP_____.pdf?X-Amz-Expires=600&X-Amz-Date=20160810T065157Z&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAJZQVDWCWLYNDBETA/20160810/ap-southeast-2/s3/aws4_request&X-Amz-SignedHeaders=host&X-Amz-Signature=f2c71f08ec57e7f9e46a2dc5df376efc9720e286b42352ac61dd7216f3b2ef91",
        "status": "delivered"
      },
      "relationships": {
        "appointment": {
          "data": {
            "id": 1,
            "doctor_id": 2,
            "patient_id": 23,
            "status": "decline",
            "created_at": "2016-07-27T02:43:20.355Z",
            "updated_at": "2016-07-27T02:43:20.355Z",
            "appointment_product_id": 1,
            "consultation_fee": "49.95",
            "doctor_fee": "29.0",
            "job_id": null
          }
        }
      }
    },
    {
      "id": "7",
      "type": "prescriptions",
      "attributes": {
        "appointmentId": 1,
        "pharmacyId": 51,
        "fileIdentifier": "HTTP_____.pdf",
        "fileUrl": "https://helloe-care-development.s3-ap-southeast-2.amazonaws.com/prescription/7/HTTP_____.pdf?X-Amz-Expires=600&X-Amz-Date=20160810T065157Z&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAJZQVDWCWLYNDBETA/20160810/ap-southeast-2/s3/aws4_request&X-Amz-SignedHeaders=host&X-Amz-Signature=8c6a2bdc23b0f6ec325b8b73134d1b9bf1a897e8f247e8536e9a3c59624fb2e3",
        "status": "delivered"
      },
      "relationships": {
        "appointment": {
          "data": {
            "id": 1,
            "doctor_id": 2,
            "patient_id": 23,
            "status": "decline",
            "created_at": "2016-07-27T02:43:20.355Z",
            "updated_at": "2016-07-27T02:43:20.355Z",
            "appointment_product_id": 1,
            "consultation_fee": "49.95",
            "doctor_fee": "29.0",
            "job_id": null
          }
        }
      }
    }
  ]
}
~~~

- Create Appointment (POST '/v1/p/appointments')

request headers:
~~~
headers: {
  Authorization: "12705dba-8af9-4506-9faf-f29455368a8a"
}
~~~

~~~
body:
{
  "appointment_setting_id": "1",
  "start_time": "xxxx",
  "end_time": "xxxx",
  "doctor_id": "1"
}
~~~

response:
~~~
{ survey_id: 1 }
~~~


- Get Appointment by patient (GET '/v1/d/appointments/:id')

request headers:
~~~
headers: {
  Authorization: "12705dba-8af9-4506-9faf-f29455368a8a"
}
~~~

response:
~~~
{
  "data": [
    {
      "id": "23",
      "type": "docAppointments",
      "attributes": {
        "status": "finished",
        "periodStartTime": "2016-08-25T01:00:00.000Z",
        "periodEndTime": "2016-08-25T02:00:00.000Z",
        "consultationFee": "37.50",
        "paid": false,
        "patientFullName": "Roger Luo",
        "patientShortName": "RL",
        "conferenceEndTime": null
      },
      "relationships": {
        "survey": {
          "data": {
            "id": "13",
            "type": "surveys"
          }
        },
        "medicalCertificate": {
          "data": null
        },
        "comments": {
          "data": []
        },
        "prescriptions": {
          "data": []
        }
      }
    },
    {
      "id": "22",
      "type": "docAppointments",
      "attributes": {
        "status": "finished",
        "periodStartTime": "2016-08-25T01:00:00.000Z",
        "periodEndTime": "2016-08-25T02:00:00.000Z",
        "consultationFee": "37.50",
        "paid": false,
        "patientFullName": "Roger Luo",
        "patientShortName": "RL",
        "conferenceEndTime": null
      },
      "relationships": {
        "survey": {
          "data": {
            "id": "12",
            "type": "surveys"
          }
        },
        "medicalCertificate": {
          "data": null
        },
        "comments": {
          "data": []
        },
        "prescriptions": {
          "data": []
        }
      }
    },
    {
      "id": "21",
      "type": "docAppointments",
      "attributes": {
        "status": "finished",
        "periodStartTime": "2016-08-25T01:00:00.000Z",
        "periodEndTime": "2016-08-25T02:00:00.000Z",
        "consultationFee": "37.50",
        "paid": false,
        "patientFullName": "Roger Luo",
        "patientShortName": "RL",
        "conferenceEndTime": null
      },
      "relationships": {
        "survey": {
          "data": {
            "id": "11",
            "type": "surveys"
          }
        },
        "medicalCertificate": {
          "data": null
        },
        "comments": {
          "data": []
        },
        "prescriptions": {
          "data": []
        }
      }
    },
    {
      "id": "20",
      "type": "docAppointments",
      "attributes": {
        "status": "finished",
        "periodStartTime": "2016-08-25T01:00:00.000Z",
        "periodEndTime": "2016-08-25T02:00:00.000Z",
        "consultationFee": "37.50",
        "paid": false,
        "patientFullName": "Roger Luo",
        "patientShortName": "RL",
        "conferenceEndTime": null
      },
      "relationships": {
        "survey": {
          "data": {
            "id": "10",
            "type": "surveys"
          }
        },
        "medicalCertificate": {
          "data": null
        },
        "comments": {
          "data": []
        },
        "prescriptions": {
          "data": []
        }
      }
    },
    {
      "id": "19",
      "type": "docAppointments",
      "attributes": {
        "status": "finished",
        "periodStartTime": "2016-08-24T08:00:00.000Z",
        "periodEndTime": "2016-08-24T09:00:00.000Z",
        "consultationFee": "37.50",
        "paid": false,
        "patientFullName": "Roger Luo",
        "patientShortName": "RL",
        "conferenceEndTime": null
      },
      "relationships": {
        "survey": {
          "data": {
            "id": "9",
            "type": "surveys"
          }
        },
        "medicalCertificate": {
          "data": null
        },
        "comments": {
          "data": []
        },
        "prescriptions": {
          "data": []
        }
      }
    },
    {
      "id": "16",
      "type": "docAppointments",
      "attributes": {
        "status": "finished",
        "periodStartTime": "2016-08-11T09:00:00.000Z",
        "periodEndTime": "2016-08-11T10:00:00.000Z",
        "consultationFee": "49.95",
        "paid": false,
        "patientFullName": "Roger Luo",
        "patientShortName": "RL",
        "conferenceEndTime": null
      },
      "relationships": {
        "survey": {
          "data": {
            "id": "6",
            "type": "surveys"
          }
        },
        "medicalCertificate": {
          "data": null
        },
        "comments": {
          "data": []
        },
        "prescriptions": {
          "data": []
        }
      }
    },
    {
      "id": "15",
      "type": "docAppointments",
      "attributes": {
        "status": "finished",
        "periodStartTime": "2016-08-11T06:00:00.000Z",
        "periodEndTime": "2016-08-11T07:00:00.000Z",
        "consultationFee": "37.50",
        "paid": true,
        "patientFullName": "Roger Luo",
        "patientShortName": "RL",
        "conferenceEndTime": "2016-08-11T06:46:07.841Z"
      },
      "relationships": {
        "survey": {
          "data": {
            "id": "5",
            "type": "surveys"
          }
        },
        "medicalCertificate": {
          "data": {
            "id": "5",
            "type": "medicalCertificates"
          }
        },
        "comments": {
          "data": [
            {
              "id": "3",
              "type": "comments"
            },
            {
              "id": "4",
              "type": "comments"
            },
            {
              "id": "5",
              "type": "comments"
            },
            {
              "id": "6",
              "type": "comments"
            },
            {
              "id": "7",
              "type": "comments"
            },
            {
              "id": "8",
              "type": "comments"
            },
            {
              "id": "9",
              "type": "comments"
            },
            {
              "id": "10",
              "type": "comments"
            },
            {
              "id": "11",
              "type": "comments"
            },
            {
              "id": "12",
              "type": "comments"
            },
            {
              "id": "13",
              "type": "comments"
            },
            {
              "id": "14",
              "type": "comments"
            },
            {
              "id": "15",
              "type": "comments"
            }
          ]
        },
        "prescriptions": {
          "data": [
            {
              "id": "8",
              "type": "prescriptions"
            }
          ]
        }
      }
    },
    {
      "id": "14",
      "type": "docAppointments",
      "attributes": {
        "status": "finished",
        "periodStartTime": "2016-08-11T07:00:00.000Z",
        "periodEndTime": "2016-08-11T08:00:00.000Z",
        "consultationFee": "37.50",
        "paid": false,
        "patientFullName": "Roger Luo",
        "patientShortName": "RL",
        "conferenceEndTime": null
      },
      "relationships": {
        "survey": {
          "data": {
            "id": "4",
            "type": "surveys"
          }
        },
        "medicalCertificate": {
          "data": null
        },
        "comments": {
          "data": []
        },
        "prescriptions": {
          "data": []
        }
      }
    },
    {
      "id": "9",
      "type": "docAppointments",
      "attributes": {
        "status": "finished",
        "periodStartTime": "2016-08-11T06:00:00.000Z",
        "periodEndTime": "2016-08-11T07:00:00.000Z",
        "consultationFee": "37.50",
        "paid": false,
        "patientFullName": "Roger Luo",
        "patientShortName": "RL",
        "conferenceEndTime": null
      },
      "relationships": {
        "survey": {
          "data": null
        },
        "medicalCertificate": {
          "data": null
        },
        "comments": {
          "data": []
        },
        "prescriptions": {
          "data": []
        }
      }
    },
    {
      "id": "8",
      "type": "docAppointments",
      "attributes": {
        "status": "finished",
        "periodStartTime": "2016-08-11T06:00:00.000Z",
        "periodEndTime": "2016-08-11T07:00:00.000Z",
        "consultationFee": "37.50",
        "paid": false,
        "patientFullName": "Roger Luo",
        "patientShortName": "RL",
        "conferenceEndTime": null
      },
      "relationships": {
        "survey": {
          "data": null
        },
        "medicalCertificate": {
          "data": null
        },
        "comments": {
          "data": []
        },
        "prescriptions": {
          "data": []
        }
      }
    }
  ],
  "links": {}
}
~~~

- Get pharmacy list  (GET  '/v1/p/pharmacies')

request headers:
~~~
headers: {
  Authorization: "12705dba-8af9-4506-9faf-f29455368a8a"
}
~~~

~~~
body:
{
  "q":  "Pharmacy"
}
~~~

response:
~~~
{
  "data": [
    {
      "id": 7267,
      "company_name": "Pharmacy For Real Professional Compounding",
      "street": "Shop 7 544 Box Rd",
      "code": 2226,
      "phone": "(02) 9528 8333",
      "email": "info@pharmacyforreal.com.au"
    },
    {
      "id": 7258,
      "company_name": "Smithton Pharmacy",
      "street": "18 King St",
      "code": 7330,
      "phone": "(03) 6452 1129",
      "email": "smithton.pharmacy@nunet.com.au"
    },
    ... ...
    {
      "id": 7187,
      "company_name": "Youngtown Pharmacy",
      "street": "369 Hobart Rd",
      "code": 7249,
      "phone": "(03) 6343 1788",
      "email": "admin@youngtownpharmacy.com.au"
    }
  ],
  "meta": {
    "next_page": 2,
    "prev_page": null,
    "current_page": 1,
    "total_pages": 62,
    "total_count": 611
  }
}
~~~

- Get survey by patient (GET  '/v1/p/surveys/:id')

request headers:
~~~
headers: {
  Authorization: "12705dba-8af9-4506-9faf-f29455368a8a"
}
~~~

response:
~~~
{
  "data": {
    "id": 1,
    "full_name": "roger luo",
    "suburb": null,
    "age": null,
    "gender": "female",
    "street_address": null,
    "weight": null,
    "height": null,
    "occupation": null,
    "medical_condition": null,
    "medications": null,
    "reason": "Specialist Referral",
    "allergies": null
  }
}
~~~

- Update survey by patient (PUT/PATCH  '/v1/p/surveys/:id')

request headers:
~~~
headers: {
  Authorization: "12705dba-8af9-4506-9faf-f29455368a8a"
}
~~~

~~~
body:
{
  "data": {
  "full_name": "xxxx",
  "suburb": "xx",
  "age": "11",
  "gender": "0",
  "street_address": "xxxxx",
  "weight":  "70",
  "height": "180",
  "occupation": "xxxx",
  "medical_condition": "xxxx",
  "medications": "xxxx",
  "reason_id": "1",
  "allergies": "xxxxx"
  }
}
~~~

response:
~~~
{ "message": "success" }
~~~

- Get reasons for survey  (GET  '/v1/p/reasons')

request headers:
~~~
headers: {
  Authorization: "12705dba-8af9-4506-9faf-f29455368a8a"
}
~~~

response:
~~~
{
  "data": [
    {
      "id": 1,
      "text": "Prescription Refil"
    },
    {
      "id": 2,
      "text": "Doctors Certificate"
    },
    ... ...
    {
      "id": 28,
      "text": "Arthritis"
    },
    {
      "id": 29,
      "text": "Other"
    }
  ]
}
~~~

- Set default checkout by patient  (PUT  '/v1/p/checkouts/:id/set_default')

request headers:
~~~
headers: {
  Authorization: "12705dba-8af9-4506-9faf-f29455368a8a"
}
~~~

response:
~~~
{
  "data": {
    "id": 1,
    "card_last4": "3222",
    "brand": null,
    "exp_month": null,
    "exp_year": null,
    "funding": null,
    "default": true
  }
}
~~~

- Get all checkouts for patient  (GET '/v1/p/checkouts')

request headers:
~~~
headers: {
  Authorization: "12705dba-8af9-4506-9faf-f29455368a8a"
}
~~~

response:
~~~
{
  "data": [
    {
      "id": 1,
      "card_last4": "3222",
      "brand": null,
      "exp_month": null,
      "exp_year": null,
      "funding": null,
      "default": true
    }
  ]
}
~~~

- Add new checkout  (POST   '/v1/p/checkouts')

request headers:
~~~
headers: {
  Authorization: "12705dba-8af9-4506-9faf-f29455368a8a"
}
~~~

~~~
body:
 {
   "user_id": "1",
    "default": "true",
    "stripe_customer_id": "13",
    "card_last4": "2345",
    "brand": "VISA",
    "exp_month": "12",
    "exp_year": "2016",
    "country": "Australia",
    "funding": "xxxx"
}
~~~

response:
~~~
{
  "data": {
    "id": 1,
    "card_last4": "3222",
    "brand": null,
    "exp_month": null,
    "exp_year": null,
    "funding": null,
    "default": true
  }
}
~~~

- Delete one checkout  (DELETE   '/v1/p/checkouts/:id')
~~~
headers: {
  Authorization: "12705dba-8af9-4506-9faf-f29455368a8a"
}
~~~

response:  none
