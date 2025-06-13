/*
 * 申请权限
 *
 * 申请权限分为：
 * 1、系统授权（system_grant），在 module.json5 中配置，应用安装后会自动获得授权
 * 比如 Internet 网络权限等，可用权限参见 https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/permissions-for-all
 * 示例及说明如下
 * {
 *   "module": {
 *     "requestPermissions":[ // 请求系统授权
 *       {
 *         "name": "ohos.permission.INTERNET", // Internet 网络权限
 *         "reason": "$string:hello_webabcd", // 申请此权限的原因
 *         "usedScene": {
 *           "abilities": [ ], // 需要使用此权限的 ability 的名称，配置为空则所有 ability 均可以使用此权限
 *           "when":"always" // inuse（使用时允许使用此权限），always（始终允许使用此权限）
 *         }
 *       }
 *     ]
 *   }
 * }
 *
 * 2、用户授权（user_grant），应用运行后通过弹窗的方式请求用户授权，需要用户手动授权
 * 比如定位权限等，可用权限参见 https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/permissions-for-all-user
 * 需要先在 module.json5 中配置相关权限，然后应用启动后在需要的地方通过 requestPermissionsFromUser() 申请用户授权
 */

import { TitleBar } from '../TitleBar';
import { abilityAccessCtrl, bundleManager, PermissionRequestResult, Permissions } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';

@Entry
@Component
struct PermissionDemo {

  build() {
    Column() {
      TitleBar()
      Tabs() {
        TabContent() { MySample1() }.tabBar('系统授权').align(Alignment.Top)
        TabContent() { MySample2() }.tabBar('用户授权').align(Alignment.Top)
      }
      .scrollable(true)
      .barMode(BarMode.Scrollable)
      .layoutWeight(1)
    }
  }
}

// 判断当前应用是否具有指定的授权
function checkPermission(permissionName: Permissions): boolean {
  try {
    // 获取当前应用的 tokenId
    const bundleInfo = bundleManager.getBundleInfoForSelfSync(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION);
    const tokenId = bundleInfo.appInfo.accessTokenId;

    // 创建权限管理器
    const atManager = abilityAccessCtrl.createAtManager(); // createAtManager() 中的 At 是 access token 的缩写
    // 检查指定的 tokenId 是否具有指定的授权
    const grantStatus = atManager.checkAccessTokenSync(tokenId, permissionName);

    // abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED - 已授权（0）
    // abilityAccessCtrl.GrantStatus.PERMISSION_DENIED - 授权被拒（-1）
    return grantStatus == abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED;
  } catch (err) {
    return false;
  }
}

@Component
struct MySample1 {

  @State message: string = ""

  build() {
    Column({ space: 10 }) {

      Button('检查是否有 ohos.permission.INTERNET 权限').onClick(() => {
        let result = checkPermission("ohos.permission.INTERNET")
        this.message = `ohos.permission.INTERNET: ${result}`
      })

      Text(this.message)
    }
  }
}

@Component
struct MySample2 {

  @State message: string = ""

  // 申请指定的用户授权
  requestPermissionsFromUser(permissions: Array<Permissions>): void {
    let context: Context = this.getUIContext().getHostContext()!
    /*
     * abilityAccessCtrl.createAtManager() - 创建权限管理器
     *   requestPermissionsFromUser() - 根据授权状态，弹出指定权限的授权框（返回值是一个 PermissionRequestResult 对象）
     *     permissions - 此次请求的每个权限的权限名列表（一个 Array<string> 数组）
     *     authResults - 此次请求的每个权限的授权状态（一个 Array<number> 数组）
     *       0 - 已授权
     *       -1 - 未授权或授权被拒
     *       2 - 因配置等原因导致的未授权
     *     dialogShownResults - 此次请求的每个权限是否弹出了授权框
     */
    let atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager(); // createAtManager() 中的 At 是 access token 的缩写
    atManager.requestPermissionsFromUser(context, permissions).then((data: PermissionRequestResult) => {
      let length: number = data.authResults.length;
      for (let i = 0; i < length; i++) {
        this.message += `${data.permissions[i]}: ${data.authResults[i]}, ${data.dialogShownResults?.[i]}\n`
      }
    }).catch((err: BusinessError) => {
      this.message = `requestPermissionsFromUser error, errCode:${err.code}, errMessage:${err.message}`
    })
  }

  // 被拒后再次申请指定的用户授权
  requestPermissionOnSetting(permissions: Array<Permissions>) {
    let context: Context = this.getUIContext().getHostContext()!
    /*
     * abilityAccessCtrl.createAtManager() - 创建权限管理器
     *   requestPermissionOnSetting() - 被拒后再次申请指定的用户授权，会弹出用户授权框（返回值是一个 Array<abilityAccessCtrl.GrantStatus> 数组，用于说明此次请求的每个权限的授权状态）
     *     PERMISSION_GRANTED - 已授权（0）
     *     PERMISSION_DENIED - 授权被拒（-1）
     */
    let atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
    atManager.requestPermissionOnSetting(context, permissions).then((data: Array<abilityAccessCtrl.GrantStatus>) => {
      let grantStatus: Array<number> = data;
      let length: number = grantStatus.length;
      for (let i = 0; i < length; i++) {
        this.message += `${permissions[i]}: ${grantStatus[i]}\n`
      }
    }).catch((err: BusinessError) => {
      this.message = `requestPermissionOnSetting error, errCode:${err.code}, errMessage:${err.message}`
    });
  }

  // 申请指定权限的系统级的全局开关
  requestGlobalSwitch(switchType: abilityAccessCtrl.SwitchType) {
    let context: Context = this.getUIContext().getHostContext()!
    /*
     * abilityAccessCtrl.createAtManager() - 创建权限管理器
     *   requestGlobalSwitch() - 申请指定权限的系统级的全局开关，会弹出一个对话框（返回值用于说明此开关是否被打开）
     *     可用开关有：abilityAccessCtrl.SwitchType.CAMERA, abilityAccessCtrl.SwitchType.MICROPHONE, abilityAccessCtrl.SwitchType.LOCATION
     *     注：只有在关闭状态下才能弹出对话框，否则会抛出异常
     */
    let atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
    atManager.requestGlobalSwitch(context, switchType).then((data: Boolean) => {
      this.message = `requestGlobalSwitch: ${data}`
    }).catch((err: BusinessError) => {
      this.message = `requestGlobalSwitch error, errCode:${err.code}, errMessage:${err.message}`
    });
  }

  build() {
    Column({ space: 10 }) {

      Button('检查是否有 ohos.permission.LOCATION 权限').onClick(() => {
        let result = checkPermission("ohos.permission.LOCATION")
        this.message += `ohos.permission.LOCATION: ${result}\n`
      })

      Button('请求 ohos.permission.LOCATION 权限').onClick(() => {
        // 注：如果要申请 ohos.permission.LOCATION（精确定位权限），则必须要具有 ohos.permission.APPROXIMATELY_LOCATION（模糊定位权限）
        let permissions: Array<Permissions> = ['ohos.permission.APPROXIMATELY_LOCATION', 'ohos.permission.LOCATION'];
        this.requestPermissionsFromUser(permissions)
      })

      Button('被拒后再次请求 ohos.permission.LOCATION 权限').onClick(() => {
        // 注：如果要申请 ohos.permission.LOCATION（精确定位权限），则必须要具有 ohos.permission.APPROXIMATELY_LOCATION（模糊定位权限）
        let permissions: Array<Permissions> = ['ohos.permission.APPROXIMATELY_LOCATION', 'ohos.permission.LOCATION'];
        this.requestPermissionOnSetting(permissions)
      })

      Button('申请定位权限的系统级的全局开关').onClick(() => {
        let switchType: abilityAccessCtrl.SwitchType = abilityAccessCtrl.SwitchType.LOCATION;
        this.requestGlobalSwitch(switchType)
      })

      Text(this.message)
    }
  }
}