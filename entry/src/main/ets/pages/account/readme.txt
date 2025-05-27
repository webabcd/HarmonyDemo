注：关于证书和华为账号登录的示例请参见 /atomicservicedemo 项目


几个概念：
AGC - AppGallery Connect
CSR - Certificate Signing Request
AGC 的地址 https://developer.huawei.com/consumer/cn/service/josp/agc/index.html
AGC 中的一个项目可以包含多个应用，这里所谓的项目比较类似分组的概念


证书相关：
1、生成证书请求文件
在 DevEco Studio 中选择 Build -> Generate Key and CSR
如果有密钥库文件（.p12）那么就选择它，如果没有则新建密钥库文件
选择好密钥库文件之后，设置一个秘钥别名（可以用应用的名称做为秘钥别名，后续在配置签名的时候会用到）
然后指定 .csr 文件的路径之后，就可以生成 .csr 文件了
注：选择保存路径的时候，最好都指向一个单独的文件夹，最终会生成一个 .p12 文件（密钥库文件），一个 .csr 文件（证书请求文件），一个名为 material 的文件夹（存放一些相关的资料）
2、在 AGC 的“证书、APP ID和Profile”中生成证书
证书类型分为“调试证书”和“发布证书”，为证书起名时，调试证书可以起名为：应用名称_debug，发布证书可以起名为：应用名称_release
选择 .csr 文件后就可以生成证书了
3、如果需要调试的话，则需要在 AGC 的“证书、APP ID和Profile”中注册调试设备，最多注册 100 个设备
获取设备的 UDID 的方法如下：
进入设备的“设置” -> “关于本机”，然后多次点击版本号，打开开发者模式
进入设备的“设置” -> “系统”，在最下方找到“开发人员选项”，然后打开“USB调试”开关
通过 hdc shell bm get --udid 获取设备的 UDID
hdc 的地址在 DevEco Studio 安装目录/sdk/default/openharmony/toolchains 中
4、在 AGC 的“证书、APP ID和Profile”中生成 profile
需要选择相关的证书
为 profile 起名时，调试 profile 可以起名为：应用名称_debug，发布 profile 可以起名为：应用名称_release
如果是调试 profile 还要选择已注册的设备
5、配置签名
在 DevEco Studio 中选择 File -> Project Structure -> Project -> Signing Configs 做配置（对应的配置文件为: 根目录/build-profile.json5）
调试场景时，可以使用自动签名也可以使用手动签名
发布场景时，只能使用手动签名


华为账号登录相关：
1、在 AGC 中创建相关的项目和相关的应用
2、在 AGC 中选择“我的项目”，然后点击相关的项目，然后点击相关的应用，然后在“常规”中找到指定应用的“OAuth 2.0客户端ID（凭据）”中的 Client ID
3、在本地开发项目中的 entry 模块的 module.json5 中做如下配置
"module": {
  "type": "entry",
  "metadata": [
    {
      "name": "client_id",
      "value": "从 AGC 上拿到的指定应用的“OAuth 2.0客户端ID（凭据）”中的 Client ID"
    }
  ]
}
4、配置证书指纹
在 DevEco Studio 中选择 File -> Project Structure -> Project -> Signing Configs
点击 Store file(*.p12): 最右侧的指纹按钮，然后复制证书指纹信息
在 AGC 中选择“我的项目”，然后点击相关的项目，然后点击相关的应用，然后在“常规”中找到指定应用的“SHA256证书/公钥指纹”，然后点击“添加证书指纹”，然后粘贴之前复制的证书指纹信息
注：配置成功后，大约 25 小时生效
5、配置公钥指纹
在 AGC 中选择“我的项目”，然后点击相关的项目，然后点击相关的应用，然后在“常规”中找到指定应用的“SHA256证书/公钥指纹”，然后点击“添加公钥指纹 (HarmonyOS API 9及以上)”，然后选择相关的公钥指纹信息即可
注：配置成功后，大约 25 小时生效
6、申请 scope 权限
进入 https://developer.huawei.com/consumer/cn/console/api/scopeManage 
先在左上角选择好项目和凭证（凭证名称是由应用名称和应用的 APP ID 组成的），然后再查看或申请 scope 权限
默认有 openid, profile 权限，敏感权限需要单独申请