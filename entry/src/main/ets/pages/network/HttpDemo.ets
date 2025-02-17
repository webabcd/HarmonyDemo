/*
 *
 */

import { TitleBar } from '../TitleBar';
import { http } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';

@Entry
@Component
struct HttpDemo {

  build() {
    Column() {
      TitleBar()
      Tabs() {
        TabContent() { MySample1() }.tabBar('get/post').align(Alignment.Top)
      }
      .scrollable(true)
      .barMode(BarMode.Scrollable)
      .layoutWeight(1)
    }
  }
}

@Component
struct MySample1 {

  @State message: string = ""

  async get_sample() {
    this.message = ""
    let httpRequest = http.createHttp()

    httpRequest.on('headersReceive', (header) => {
      this.message += `header: ${JSON.stringify(header)}\n`
    });

    httpRequest.request(
      "http://192.168.8.197:8001/api?k1=v1&k2=v2",
      {
        header: {
          'custom-header1': 'abc'
        },
        method: http.RequestMethod.GET,
        expectDataType: http.HttpDataType.STRING,
        connectTimeout: 60_000,
        readTimeout: 60_000,
      },
      (err: BusinessError, data: http.HttpResponse) => {
        httpRequest.off('headersReceive');
        if (!err) {
          this.message += `result: ${JSON.stringify(data.result)}\n`
          this.message += `response code: ${data.responseCode}\n`
          httpRequest.destroy();
        } else {
          this.message += `error: ${JSON.stringify(err)}\n`
          httpRequest.destroy();
        }
      }
    );
  }

  async post_sample() {
    interface IPerson {
      name: string
      age: number
    }
    const person: IPerson = {
      name: "webabcd",
      age: 44,
    }
    const postData = JSON.stringify(person)

    this.message = ""
    let httpRequest = http.createHttp()

    httpRequest.on('headersReceive', (header) => {
      this.message += `header: ${JSON.stringify(header)}\n`
    });

    httpRequest.request(
      "http://192.168.8.197:8001/api?k1=v1&k2=v2",
      {
        header: {
          'Content-Type': 'application/json',
          'custom-header1': 'abc'
        },
        method: http.RequestMethod.POST,
        extraData: postData,
        expectDataType: http.HttpDataType.STRING,
        connectTimeout: 60_000,
        readTimeout: 60_000,
      },
      (err: BusinessError, data: http.HttpResponse) => {
        httpRequest.off('headersReceive');
        if (!err) {
          this.message += `result: ${JSON.stringify(data.result)}\n`
          this.message += `response code: ${data.responseCode}\n`
          httpRequest.destroy();
        } else {
          this.message += `error: ${JSON.stringify(err)}\n`
          httpRequest.destroy();
        }
      }
    );
  }

  build() {
    Column({space:10}) {
      Button("get").onClick(async () => {
        await this.get_sample()
      })

      Button("post").onClick(async () => {
        await this.post_sample()
      })

      Text(this.message)
    }
  }
}