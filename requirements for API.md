# API 
### get
*four kind json files and one raw data file (all updated in time )*
 * time2016-mm-dd
 * vin2016-mm-dd
 * responsecode2016-mm-dd
 * cep_access_log

### input
*accept input containing time,vin,url,response code*
 
### vin2016-07-15    
*JSON demo*
```json
 {
    "results": {
        "date": "2016-07-15", 
        "unique value": [
            "fg23444@1w0007808djknfkkfj"
        ], 
        "vin": {
            "fg23444@1w0007808djknfkkfj": [
                {
                    "url": "/hackingwithjson/", 
                    "response code": "502", 
                    "time": "2015-04-15T09:39:28(GMT)"
                }, 
                {
                    "url": "/hackingwithjson2/", 
                    "response code": "200", 
                    "time": "2015-04-15T11:39:22(GMT)"
                }
            ]
        }, 
        "mode": "vin"
    }
}
```
