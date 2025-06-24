ohpm（OpenHarmony Package Manager）

1、先在 har 模块中的 oh-package.json5 文件中做一些配置

2、OpenHarmony 三方库中心仓
https://ohpm.openharmony.cn/

3、若需发布组织化库，需先在 ohpm.openharmony.cn 的“个人中心”->“组织管理”中，新增组织并等待审核（通常1-2小时）

4、生成 SSH 密钥生成
ssh-keygen -m PEM -t RSA -b 4096 -f d://ohpm.pub
注：ssh-keygen 的地址可能是 C:\Windows\System32\OpenSSH\ssh-keygen.exe

5、在 ohpm.openharmony.cn 的“个人中心”->“认证管理”中，添加一个 OHPM 公钥
公钥的值保存在 d://ohpm.pub.pub

6、配置私钥
ohpm config set key_path d://ohpm.pub
注：ohpm 的地址可能是 h:\Program Files\Huawei\DevEco Studio\tools\ohpm\bin\ohpm.bat

7、配置发布码
ohpm config set publish_id 发布码
注：在 ohpm.openharmony.cn 的“个人中心”中有名为“复制发布码”的按钮，

8、在 DevEco Studio 中，选中 har 项目，然后在 Build 中执行 Make Module 'xxx'
生成的 .har 文件在 D:\gitroot\HarmonyHttpServer\harmony_httpserver\build\default\outputs\default\harmony_httpserver.har

9、发布 .har 到 ohpm.openharmony.cn
ohpm publish D:\gitroot\HarmonyHttpServer\harmony_httpserver\build\default\outputs\default\harmony_httpserver.har
当出现 what is your passphrase of the private key: 提示时，输入你在执行 ssh-keygen 时输入的密码
