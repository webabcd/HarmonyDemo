/*
 * 本例用于演示如何获取网络信息，以及如何监听网络变化等
 * 需要 ohos.permission.INTERNET 和 ohos.permission.GET_NETWORK_INFO 权限
 */

import { TitleBar } from '../TitleBar';
import { connection } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';

@Entry
@Component
struct NetworkInfoDemo {

  build() {
    Column() {
      TitleBar()
      Tabs() {
        TabContent() { MySample1() }.tabBar('获取网络信息').align(Alignment.Top)
        TabContent() { MySample2() }.tabBar('监听网络变化').align(Alignment.Top)
        TabContent() { MySample3() }.tabBar('获取指定域名的所有 IP').align(Alignment.Top)
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

  /*
   * connection.getDefaultNet() - 获取当前默认的网络（返回一个 NetHandle 对象）
   * connection.getAllNets() - 获取当前的所有网络（返回一个 NetHandle 数组）
   * NetHandle - 网络句柄
   *   netId - 标识
   * getNetCapabilities() - 获取指定 NetHandle 的网络的能力，返回一个 NetCapabilities 对象
   *   linkDownBandwidthKbps - 下行带宽，单位：kbps
   *   linkUpBandwidthKbps - 上行带宽，单位：kbps
   *   bearerTypes - 网络类型（connection.NetBearType 枚举）
   *     BEARER_CELLULAR（0） - 蜂窝
   *     BEARER_WIFI（1） - wifi
   *     BEARER_BLUETOOTH（2） - 蓝牙
   *     BEARER_ETHERNET（3） - 有线
   *     BEARER_VPN（4） - vpn
   *   networkCap - 网络能力（connection.NetCap 枚举）
   *     NET_CAPABILITY_MMS（0） - 多媒体短信
   *     NET_CAPABILITY_NOT_METERED（11） - 网络流量未被计费
   *     NET_CAPABILITY_INTERNET（12） - Internet
   *     NET_CAPABILITY_NOT_VPN（15） - 不使用 vpn
   *     NET_CAPABILITY_VALIDATED（16） - 该网络与华为云成功建立了连接
   * getConnectionProperties() - 获取指定 NetHandle 的网络连接的信息，返回一个 ConnectionProperties 对象
   *   interfaceName - 网卡名称
   */

  // 获取指定 NetHandle 的网络的能力
  async getNetCapabilities(netHandle:connection.NetHandle) {
    this.message += `网络标识: ${netHandle.netId}\n`

    let netCapabilities:connection.NetCapabilities = await connection.getNetCapabilities(netHandle)
    this.message += `网络的能力: ${JSON.stringify(netCapabilities, null, 2)}\n`

    this.message += `网络的下行带宽: ${netCapabilities.linkDownBandwidthKbps} kbps\n`
    this.message += `网络的上行带宽: ${netCapabilities.linkUpBandwidthKbps} kbps\n`

    let bearerTypes: Set<number> = new Set(netCapabilities.bearerTypes);
    for (let item of bearerTypes) {
      if (item == 0) {
        this.message += "网络的类型是：蜂窝网络（BEARER_CELLULAR）\n";
      } else if (item == 1) {
        this.message += "网络的类型是：wifi 网络（BEARER_WIFI）\n";
      } else if (item == 3) {
        this.message += "网络的类型是：以太网（BEARER_ETHERNET）\n";
      }
    }

    let itemNumber : Set<number> = new Set(netCapabilities.networkCap);
    for (let item of itemNumber) {
      if (item == 12) {
        this.message += "网络具有 NET_CAPABILITY_INTERNET 能力（互联网）\n"
      }
    }
  }

  // 获取指定 NetHandle 的网络连接的信息
  async getConnectionProperties(netHandle:connection.NetHandle) {
    this.message += `网络标识: ${netHandle.netId}\n`

    let connectionProperties:connection.ConnectionProperties = await connection.getConnectionProperties(netHandle)
    this.message += `网络连接的信息: ${JSON.stringify(connectionProperties, null, 2)}\n`
  }

  async getDefaultNet() {
    let netHandle:connection.NetHandle = await connection.getDefaultNet();
    this.message = `当前默认网络: ${JSON.stringify(netHandle, null, 2)}\n`
    await this.getNetCapabilities(netHandle)
    await this.getConnectionProperties(netHandle)
  }

  async getAllNets() {
    let netHandleList:connection.NetHandle[] = await connection.getAllNets();
    this.message = `当前所有网络: ${JSON.stringify(netHandleList, null, 2)}\n`
    for (let netHandle of netHandleList) {
      await this.getNetCapabilities(netHandle)
      await this.getConnectionProperties(netHandle)
    }
  }

  build() {
    Column({space:10}) {
      Button("获取当前默认网络的能力，以及网络连接的信息").onClick(async () => {
        await this.getDefaultNet()
      })

      Button("获取当前所有网络的能力，以及网络连接的信息").onClick(async () => {
        await this.getAllNets()
      })

      Scroll() {
        Text(this.message)
      }
      .layoutWeight(1).align(Alignment.TopStart).backgroundColor(Color.Yellow).width('100%')
    }
  }
}

@Component
struct MySample2 {

  @State message: string = ""

  aboutToAppear(): void {

    /*
     * NetConnection - 网络连接对象
     *   connection.createNetConnection() - 创建一个 NetConnection 对象，后续可以监听此对象所属网络的变化
     *     netSpecifier - 指定网络（一个 NetSpecifier 对象），不指定的话，则创建的是默认网络的 NetConnection 对象
     *       netCapabilities - 用于设置指定网络的类型
     *     timeout - 超时时间，仅当指定了 netSpecifier 时才有效，单位：毫秒
     *   register() - 注册网络变化的通知（注册后才能监听网络变化）
     *   unregister() - 取消注册网络变化的通知
     *   on('netBlockStatusChange') - 网络的阻塞状态发生变化时的回调（回调参数是一个 NetBlockStatusInfo 对象）
     *     netHandle - 相关的 NetHandle 对象（参见 MySample1 中的说明）
     *     blocked - 网络是否是阻塞状态
     *   on('netCapabilitiesChange') - 网络的能力发生变化时的回调（回调参数是一个 NetCapabilityInfo 对象）
     *     netHandle - 相关的 NetHandle 对象（参见 MySample1 中的说明）
     *     netCap - 网络的能力，一个 NetCapabilities 对象（参见 MySample1 中的说明）
     *   on('netConnectionPropertiesChange') - 网络连接的信息发生变化时的回调（回调参数是一个 NetConnectionPropertyInfo 对象）
     *     netHandle - 相关的 NetHandle 对象（参见 MySample1 中的说明）
     *     connectionProperties - 网络连接的信息，一个 ConnectionProperties 对象（参见 MySample1 中的说明）
     *   on('netAvailable') - 网络可用时的回调，回调参数是一个 NetHandle 对象
     *   on('netUnavailable') - 网络不可用时的回调
     *   on('netLost') - 网络断开时的回调，回调参数是一个 NetHandle 对象
     */
    let netConnection = connection.createNetConnection(); // 创建默认网络的 NetConnection 对象

    /*
    let netSpecifier: connection.NetSpecifier = {
      netCapabilities: {
        bearerTypes: [connection.NetBearType.BEARER_CELLULAR], // 使用蜂窝网络创建 NetConnection 对象
        networkCap: [connection.NetCap.NET_CAPABILITY_INTERNET] // 网络需具有 Internet 的能力
      },
    };
    let timeout = 10 * 1000;
    let netConnection = connection.createNetConnection(netSpecifier, timeout); // 创建指定网络的 NetConnection 对象
    */

    // 注册网络变化的通知
    netConnection.register((error: BusinessError) => {
      this.message += "register\n"
    });

    /*
    // 取消注册网络变化的通知
    netConnection.unregister((error: BusinessError) => {
      this.message += "unregister\n"
    });
    */

    netConnection.on('netBlockStatusChange', (data: connection.NetBlockStatusInfo) => {
      this.message += `netBlockStatusChange: ${JSON.stringify(data, null, 2)}\n`
    });

    netConnection.on('netCapabilitiesChange', (data: connection.NetCapabilityInfo) => {
      this.message += `netCapabilitiesChange: ${JSON.stringify(data, null, 2)}\n`
    });

    netConnection.on('netConnectionPropertiesChange', (data: connection.NetConnectionPropertyInfo) => {
      this.message += `netConnectionPropertiesChange: ${JSON.stringify(data, null, 2)}\n`
    });

    netConnection.on('netAvailable', ((data: connection.NetHandle) => {
      this.message += `netAvailable: ${JSON.stringify(data, null, 2)}\n`
    }));

    netConnection.on('netUnavailable', () => {
      this.message += `netUnavailable\n`
    });

    netConnection.on('netLost', (data: connection.NetHandle) => {
      this.message += `netLost: ${JSON.stringify(data, null, 2)}\n`
    });
  }

  build() {
    Column({space:10}) {

      Scroll() {
        Text(this.message)
      }
      .layoutWeight(1).align(Alignment.TopStart).backgroundColor(Color.Yellow).width('100%')
    }
  }
}

@Component
struct MySample3 {

  @State message: string = ""

  async getAddressesByName() {
    try {
      /*
       * connection.getAddressesByName() - 获取指定域名的所有 IP（返回一个 NetAddress 数组）
       * NetAddress - 网络地址
       *   address - ip
       *   family - 1 代表 ipv4, 2 代表 ipv6
       */
      let netAddressList: connection.NetAddress[] = await connection.getAddressesByName("www.huawei.com")
      this.message += JSON.stringify(netAddressList, null, 2)
    } catch (e) {
      this.message += JSON.stringify(e)
    }
  }

  build() {
    Column({space:10}) {
      Button("获取指定域名的所有 IP").onClick(async () => {
        await this.getAddressesByName()
      })

      Scroll() {
        Text(this.message)
      }
      .layoutWeight(1).align(Alignment.TopStart).backgroundColor(Color.Yellow).width('100%')
    }
  }
}
