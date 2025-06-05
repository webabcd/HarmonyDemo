/*
 * 用户认证
 * 可以拉起系统级的用户认证功能，其提供了密码、人脸、指纹的认证方式
 *
 * 注：如需人脸、指纹的认证方式，需要申请 ohos.permission.ACCESS_BIOMETRIC 权限（参见 module.json5 中的相关配置）
 */

import { TitleBar } from '../TitleBar';
import { userAuth, UserAuthIcon } from '@kit.UserAuthenticationKit';
import { cryptoFramework } from '@kit.CryptoArchitectureKit';

@Entry
@Component
struct UserAuthenticationDemo {

  build() {
    Column() {
      TitleBar()
      Tabs() {
        TabContent() { MySample1() }.tabBar('查询支持的用户认证能力').align(Alignment.Top)
        TabContent() { MySample2() }.tabBar('通过 api 发起用户认证').align(Alignment.Top)
        TabContent() { MySample3() }.tabBar('通过组件发起用户认证').align(Alignment.Top)
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
   * userAuth.getAvailableStatus() - 用于查询系统是否支持指定的用户认证能力（如果不具备指定的用户认证能力，则会抛出异常）
   *   authType - 认证类型（UserAuthType 枚举）
   *     PIN - 密码
   *     FACE - 人脸
   *     FINGERPRINT - 指纹
   *   authTrustLevel - 认证等级（AuthTrustLevel 枚举）
   *     ATL1 - 一般等级
   *     ATL2 - 应用级
   *     ATL3 - 设备级
   *     ATL4 - 支付级
   */
  getUserAuthAvailableStatus() {
    try {
      userAuth.getAvailableStatus(userAuth.UserAuthType.PIN, userAuth.AuthTrustLevel.ATL4);
      this.message += `PIN, ATL4 ok\n`
    } catch (e) {
      this.message += `PIN, ATL4 error: ${JSON.stringify(e)}\n`
    }

    try {
      userAuth.getAvailableStatus(userAuth.UserAuthType.FACE, userAuth.AuthTrustLevel.ATL4);
      this.message += `FACE, ATL4 ok\n`
    } catch (e) {
      this.message += `FACE, ATL4 error: ${JSON.stringify(e)}\n`
    }

    try {
      userAuth.getAvailableStatus(userAuth.UserAuthType.FINGERPRINT, userAuth.AuthTrustLevel.ATL4);
      this.message += `FINGERPRINT, ATL4 ok\n`
    } catch (e) {
      this.message += `FINGERPRINT, ATL4 error: ${JSON.stringify(e)}\n`
    }
  }

  build() {
    Column({ space: 10 }) {

      Button("查询支持的用户认证能力").onClick(() => {
        this.getUserAuthAvailableStatus()
      })

      Text(this.message)
    }
  }
}

@Component
struct MySample2 {

  @State message: string = ""

  /*
   * UserAuthInstance - 用户认证器对象
   *   userAuth.getUserAuthInstance() - 创建一个用户认证器对象
   *     authParam - 认证参数（一个 AuthParam 对象）
   *       challenge - 随机值，用于防止重放攻击
   *       authType - 认证窗口需要提供的认证类型（UserAuthType 枚举）
   *         PIN - 密码
   *         FACE - 人脸
   *         FINGERPRINT - 指纹
   *       authTrustLevel - 认证等级（AuthTrustLevel 枚举）
   *         ATL1 - 一般等级
   *         ATL2 - 应用级
   *         ATL3 - 设备级
   *         ATL4 - 支付级
   *     widgetParam - 认证窗口的界面参数（一个 WidgetParam 对象）
   *       title - 标题
   *   on('result')/off('result') - 用户认证有结果后的回调，回调参数是一个 UserAuthResult 对象
   *     result - 认证结果（12500000 代表成功）
   *     authType - 当认证成功时，此值代表认证的类型
   *     token - 当认证成功时，此值代表认证通过的令牌信息
   *   start() - 开始认证
   *   cancel() - 取消认证
   */
  startUserAuth() {
    try {
      const authParam: userAuth.AuthParam = {
        challenge: cryptoFramework.createRandom().generateRandomSync(16).data,
        authType: [userAuth.UserAuthType.PIN, userAuth.UserAuthType.FACE, userAuth.UserAuthType.FINGERPRINT],
        authTrustLevel: userAuth.AuthTrustLevel.ATL4,
      };
      const widgetParam: userAuth.WidgetParam = {
        title: 'title',
      };
      const userAuthInstance: userAuth.UserAuthInstance = userAuth.getUserAuthInstance(authParam, widgetParam);

      userAuthInstance.on('result', {
        onResult: (result: userAuth.UserAuthResult) => {
          this.message = `result: ${result.result}\n`;
          this.message += `authType: ${result.authType}\n`;
          this.message += `token: ${result.token}\n`;
          userAuthInstance.off('result');
        }
      });

      userAuthInstance.start();
      // userAuthInstance.cancel();

    } catch (e) {
      this.message += `通过 api 发起用户认证失败: ${JSON.stringify(e)}\n`
    }

  }

  build() {
    Column({ space: 10 }) {

      Button("通过 api 发起用户认证").onClick(() => {
        this.startUserAuth()
      })

      Text(this.message)
    }
  }
}

@Component
struct MySample3 {

  @State message: string = ""

  getAuthParam(userAuthType: userAuth.UserAuthType) {
    let authParam: userAuth.AuthParam = {
      challenge: cryptoFramework.createRandom().generateRandomSync(16).data,
      authType: [userAuth.UserAuthType.PIN, userAuthType],
      authTrustLevel: userAuth.AuthTrustLevel.ATL4,
    };
    return authParam;
  }

  widgetParam: userAuth.WidgetParam = {
    title: 'title'
  };

  build() {
    Column({ space: 10 }) {

      /*
       * UserAuthIcon - 人脸或指纹图标，点击后会弹出用户认证器
       *   authParam - 认证参数（一个 AuthParam 对象）
       *     challenge - 随机值，用于防止重放攻击
       *     authType - 认证窗口需要提供的认证类型（UserAuthType 枚举）
       *       PIN - 密码
       *       FACE - 人脸
       *       FINGERPRINT - 指纹
       *     authTrustLevel - 认证等级（AuthTrustLevel 枚举）
       *       ATL1 - 一般等级
       *       ATL2 - 应用级
       *       ATL3 - 设备级
       *       ATL4 - 支付级
       *   widgetParam - 认证窗口的界面参数（一个 WidgetParam 对象）
       *     title - 标题
       *   iconHeight - 图标高度（注：宽度和高度一致）
       *   iconColor - 图标颜色
       *   onIconClick() - 图标点击后的回调
       *   onAuthResult() - 用户认证有结果后的回调，回调参数是一个 UserAuthResult 对象
       *     result - 认证结果（12500000 代表成功）
       *     authType - 当认证成功时，此值代表认证的类型
       *     token - 当认证成功时，此值代表认证通过的令牌信息
       */
      UserAuthIcon({
        authParam: this.getAuthParam(userAuth.UserAuthType.FACE),
        widgetParam: this.widgetParam,
        iconHeight: 50,
        iconColor: Color.Orange,
        onIconClick: () => {
          this.message = "onIconClick\n"
        },
        onAuthResult: (result: userAuth.UserAuthResult) => {
          this.message += `result: ${result.result}\n`;
          this.message += `authType: ${result.authType}\n`;
          this.message += `token: ${result.token}\n`;
        }
      })

      UserAuthIcon({
        authParam: this.getAuthParam(userAuth.UserAuthType.FINGERPRINT),
        widgetParam: this.widgetParam,
        iconHeight: 50,
        iconColor: Color.Orange,
        onIconClick: () => {
          this.message = "onIconClick\n"
        },
        onAuthResult: (result: userAuth.UserAuthResult) => {
          this.message += `result: ${result.result}\n`;
          this.message += `authType: ${result.authType}\n`;
          this.message += `token: ${result.token}\n`;
        }
      })

      Text(this.message)
    }
  }
}
