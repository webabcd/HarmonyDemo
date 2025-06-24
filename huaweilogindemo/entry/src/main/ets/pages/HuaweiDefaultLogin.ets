/*
 * 本例用于演示华为账号的默认的登录体验
 * 登录后可以拿到 openID, unionID 等
 */

import { authentication } from '@kit.AccountKit';
import { BusinessError } from '@kit.BasicServicesKit';

@Entry
@Component
struct HuaweiDefaultLogin {

  @State message: string = '';

  /*
   * LoginWithHuaweiIDRequest - 华为账号登录请求对象
   *   authentication.HuaweiIDProvider().createLoginWithHuaweiIDRequest() - 创建一个 LoginWithHuaweiIDRequest 对象
   *   forceLogin - 如果之前未在系统中登录华为账号，是否弹出默认登录页
   *     false - 如果之前未在系统中登录华为账号，则返回异常
   *     true - 如果之前未在系统中登录华为账号，则弹出默认登录页
   * AuthenticationController - 用于控制华为账号登录
   *   authentication.AuthenticationController() - 创建一个 AuthenticationController 对象
   *   authentication.AuthenticationController(context) - 创建一个 AuthenticationController 对象（如果需要弹出默认登录页，则必须要传 context 参数）
   *   executeRequest() - 执行指定的 LoginWithHuaweiIDRequest 请求，返回一个 LoginWithHuaweiIDResponse 对象
   * LoginWithHuaweiIDResponse - 华为账号登录的结果
   *   data - 一个 LoginWithHuaweiIDCredential 对象
   * LoginWithHuaweiIDCredential - 当前登录的华为账号的相关信息
   *   authorizationCode - 临时凭据，用于获取 Access Token，有效时间 5 分钟
   *   idToken - JWT（JSON Web Token）格式的字符串，包含了一些用户信息
   *   openID - 华为账号用户在不同的应用中的身份ID，同一个用户，不同的应用，OpenID 值不同
   *   unionID - 华为账号用户在同一个开发者账号下的应用中的身份ID，同一个用户，同一个开发者账号下管理的不同应用，UnionID 值相同
   */
  // 使用当前在系统中登录的华为账号做静默登录，如果之前未在系统中登录华为账号，则返回异常
  private login1() {
    this.message = "";

    const loginRequest = new authentication.HuaweiIDProvider().createLoginWithHuaweiIDRequest();
    loginRequest.forceLogin = false;

    const controller = new authentication.AuthenticationController();
    controller.executeRequest(loginRequest).then((data: authentication.LoginWithHuaweiIDResponse) => {
      this.message += `登录成功\n`
      const loginWithHuaweiIDCredential = data.data;
      if (loginWithHuaweiIDCredential) {
        this.message += `authorizationCode: ${loginWithHuaweiIDCredential.authorizationCode}\n`
        this.message += `idToken: ${loginWithHuaweiIDCredential.idToken}\n`
        this.message += `openID: ${loginWithHuaweiIDCredential.openID}\n`
        this.message += `unionID: ${loginWithHuaweiIDCredential.unionID}\n`
      }
    }).catch((error: BusinessError) => {
      this.message += `errCode:${error.code}, errMessage:${error.message}\n`
      if (error.code === authentication.AuthenticationErrorCode.ACCOUNT_NOT_LOGGED_IN) {
        this.message += `用户未登录华为账号\n`
      }
    });
  }

  // 使用当前在系统中登录的华为账号做静默登录，如果之前未在系统中登录华为账号，则弹出默认登录页
  private login2() {
    this.message = "";

    const loginRequest = new authentication.HuaweiIDProvider().createLoginWithHuaweiIDRequest();
    loginRequest.forceLogin = true;

    const controller = new authentication.AuthenticationController(this.getUIContext().getHostContext());
    controller.executeRequest(loginRequest).then((data: authentication.LoginWithHuaweiIDResponse) => {
      this.message += `登录成功\n`
      const loginWithHuaweiIDCredential = data.data;
      if (loginWithHuaweiIDCredential) {
        this.message += `authorizationCode: ${loginWithHuaweiIDCredential.authorizationCode}\n`
        this.message += `idToken: ${loginWithHuaweiIDCredential.idToken}\n`
        this.message += `openID: ${loginWithHuaweiIDCredential.openID}\n`
        this.message += `unionID: ${loginWithHuaweiIDCredential.unionID}\n`
      }
    }).catch((error: BusinessError) => {
      this.message += `errCode:${error.code}, errMessage:${error.message}\n`
      if (error.code === authentication.AuthenticationErrorCode.ACCOUNT_NOT_LOGGED_IN) {
        this.message += `用户未登录华为账号\n`
      }
    });
  }

  /*
   * AuthorizationWithHuaweiIDRequest - 华为账号授权请求对象
   *   authentication.HuaweiIDProvider().createAuthorizationWithHuaweiIDRequest() - 创建一个 AuthorizationWithHuaweiIDRequest 对象
   *   forceLogin - 如果之前未在系统中登录华为账号，是否弹出默认登录页
   *     false - 如果之前未在系统中登录华为账号，则返回异常
   *     true - 如果之前未在系统中登录华为账号，则弹出默认登录页
   * AuthenticationController - 用于控制华为账号授权
   *   authentication.AuthenticationController() - 创建一个 AuthenticationController 对象
   *   authentication.AuthenticationController(context) - 创建一个 AuthenticationController 对象（如果需要弹出默认登录页，则必须要传 context 参数）
   *   executeRequest() - 执行指定的 AuthorizationWithHuaweiIDRequest 请求，返回一个 AuthorizationWithHuaweiIDResponse 对象
   * AuthorizationWithHuaweiIDResponse - 华为账号授权的结果
   *   data - 一个 AuthorizationWithHuaweiIDCredential 对象
   * AuthorizationWithHuaweiIDCredential - 当前登录的华为账号的相关信息
   *   avatarUri - 头像地址
   *   nickName - 昵称
   */
  // 使用当前在系统中登录的华为账号做静默登录，如果之前未在系统中登录华为账号，则弹出默认登录页
  // 然后获取华为账号头像和昵称
  private login3() {
    this.message = "";

    const authRequest = new authentication.HuaweiIDProvider().createAuthorizationWithHuaweiIDRequest();
    authRequest.scopes = ['profile'];
    authRequest.forceAuthorization = true;

    const controller = new authentication.AuthenticationController(this.getUIContext().getHostContext());
    controller.executeRequest(authRequest).then((data: authentication.AuthorizationWithHuaweiIDResponse) => {
      this.message += `登录成功\n`
      const authorizationWithHuaweiIDCredential = data.data;
      if (authorizationWithHuaweiIDCredential) {
        this.message += `avatarUri: ${authorizationWithHuaweiIDCredential.avatarUri}\n`
        this.message += `nickName: ${authorizationWithHuaweiIDCredential.nickName}\n`
      }
    }).catch((error: BusinessError) => {
      this.message += `errCode:${error.code}, errMessage:${error.message}\n`
      if (error.code === authentication.AuthenticationErrorCode.ACCOUNT_NOT_LOGGED_IN) {
        this.message += `用户未登录华为账号\n`
      }
    });
  }

  build() {
    Column({space:10}) {
      Button("静默登录，未登录则返回异常").onClick(() => {
        this.login1();
      })
      Button("静默登录，未登录则弹出默认登录页").onClick(() => {
        this.login2();
      })
      Button("静默登录，获取华为账号头像和昵称").onClick(() => {
        this.login3();
      })

      Scroll() {
        Text(this.message)
      }.layoutWeight(1).align(Alignment.TopStart).backgroundColor(Color.Yellow).width('100%')
    }
    .width('100%')
    .height('100%')
  }
}