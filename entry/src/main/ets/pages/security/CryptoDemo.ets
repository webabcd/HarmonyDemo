/*
 * 加密解密
 *
 * sym 是 symmetric 的缩写，是对称的意思
 * asy 是 asymmetric 的缩写，是不对称的意思
 */

import { TitleBar } from '../TitleBar';
import { buffer, util } from '@kit.ArkTS';
import { cryptoFramework } from '@kit.CryptoArchitectureKit';
import { fileIo as fs } from '@kit.CoreFileKit';

@Entry
@Component
struct CryptoDemo {

  build() {
    Column() {
      TitleBar()
      Tabs() {
        TabContent() { MySample1() }.tabBar('基础').align(Alignment.Top)
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

  aboutToAppear(): void {
    let x = CryptoHelper

    // 生成随机数
    this.message += `${x.uuid()}\n`
    this.message += `${x.random()}\n`
    this.message += `${x.uint8ArrayToHexStr(x.randomKey(8))}\n\n`

    // 哈希算法
    this.message += `${x.uint8ArrayToHexStr(x.sha256(x.stringToUint8Array("abc")))}\n`
    this.message += `${x.uint8ArrayToHexStr(x.md5(x.stringToUint8Array("abc")))}\n`
    this.message += `${x.uint8ArrayToHexStr(x.md5File(`${getContext(this).resourceDir + "/son.jpg"}`))}\n`
    this.message += `${x.uint8ArrayToHexStr(x.hmac(x.stringToUint8Array("abc"), x.stringToUint8Array("123456")))}\n\n`

    // 对称加密解密（aes 加密解密）
    this.message += `${x.uint8ArrayToHexStr(x.encryptAes(x.stringToUint8Array("abc"), new Uint8Array([183, 17, 31, 176, 128, 13, 123, 19, 50, 271, 9, 10, 5, 297, 232, 59])))}\n`
    this.message += `${x.uint8ArrayToString(x.decryptAes(x.hexStrToUint8Array("a776ca5f284c3ffcc20e09bd2acfb283"), new Uint8Array([183, 17, 31, 176, 128, 13, 123, 19, 50, 271, 9, 10, 5, 297, 232, 59])))}\n\n`

    // 非对称加密解密（生成密钥对）
    let rsaKeyPair = CryptoHelper.generateRsaKeyPair()
    this.message += `${x.uint8ArrayToHexStr(rsaKeyPair.pubKey.getEncoded().data)}\n`
    this.message += `${x.uint8ArrayToHexStr(rsaKeyPair.priKey.getEncoded().data)}\n\n`

    // 非对称加密解密（rsa 加密解密）
    this.message += `${x.uint8ArrayToHexStr(x.encryptRsa(x.stringToUint8Array("abc"), x.hexStrToUint8Array('30819f300d06092a864886f70d010101050003818d0030818902818100dcb8c28991771fdf16d28c14ab4a9347349054a6b28010fd45d00ef920658a259e0078967a03378ee606bd75008d0f5eff5c126f8c32466bcd692cd3fe0f884c0a0d9a40e85b05cfc7e5db215ade847224666442a31f488d7019510e785819f0056c408d9752fe99d9b075891881226bb667aafa59f98d01ad28b588de50a77b0203010001')))}\n`
    this.message += `${x.uint8ArrayToString(x.decryptRsa(x.hexStrToUint8Array("66ff08b39c86c4bc0fd6d81ac551155d46f4c704076d38e50dbddcc8d55412bc41e01a293cf98dabfd3803afbcc6638f2c6a934560c5d73f8801d17e13dafc14734ef25998c5698891d886ab516b2bdde383e7740fafec36a65090a22a2c9aa9d9ab2785faec53579b0a6685b680f9ff6d073359512aee746737f1b8815c63a5"), x.hexStrToUint8Array('30820277020100300d06092a864886f70d0101010500048202613082025d02010002818100dcb8c28991771fdf16d28c14ab4a9347349054a6b28010fd45d00ef920658a259e0078967a03378ee606bd75008d0f5eff5c126f8c32466bcd692cd3fe0f884c0a0d9a40e85b05cfc7e5db215ade847224666442a31f488d7019510e785819f0056c408d9752fe99d9b075891881226bb667aafa59f98d01ad28b588de50a77b02030100010281810096d9f3a33ff711a2501fd03b642290ebee81e24917e02d3c5c9569565d0ce8d0f2ded18bce921a4ba0ece4596de9faa26b968ac71023603bd764d58d81ab2df3bd3747ce9caaf36cba11f3ea9d1ea1b6ca2780c31d1f1d7560cd425cfa7d3a1f96d721c5552f793363363f587dabd7e8a40742b265b783c0ce75015803448eb1024100f3d9ed5e168b2859037afdc20423a85082bf91f6990666667407b17c208656b4cc8396b96f1a7935b5c4f1daaf9769645eea1ae2291bbd1be79184ac32005443024100e7b7d6c2058e69528bb47c3db86c246518e1301e39a5f7301f443cff0750fa9d6cd2df670e319d56f25d10c0499ff1d36dc7ff1cf023c140b57ad7ec8d840869024100b825a3764109f77f38fca132e9d34fa0f50bdc1b6036101060a10aac1517bdd4acf8d652d48f2667a40bc5248323916845b0fe7a39d703b955e7734c623a136702404d74cb69f1d787e75ae1cb020aaac383b3cc5a7c5002e55d05a696c91d15f9a033e74d5c32876d33ca3247ce2f0e3314dcc694c584943f1e354bc9efbde25bb9024066d6c0e4f4798592fdbee884fd879977836b2b030823d703dea14d30da5c9615f95748ea5f55529899963b4052e3666b155f14cf9075b840578a5c6d8a6ba188')))}\n\n`

    // 非对称加密解密（rsa 私钥签名，rsa 公钥验证签名）
    this.message += `${x.uint8ArrayToHexStr(x.signRsa(x.stringToUint8Array("abc"), x.hexStrToUint8Array('30820277020100300d06092a864886f70d0101010500048202613082025d02010002818100dcb8c28991771fdf16d28c14ab4a9347349054a6b28010fd45d00ef920658a259e0078967a03378ee606bd75008d0f5eff5c126f8c32466bcd692cd3fe0f884c0a0d9a40e85b05cfc7e5db215ade847224666442a31f488d7019510e785819f0056c408d9752fe99d9b075891881226bb667aafa59f98d01ad28b588de50a77b02030100010281810096d9f3a33ff711a2501fd03b642290ebee81e24917e02d3c5c9569565d0ce8d0f2ded18bce921a4ba0ece4596de9faa26b968ac71023603bd764d58d81ab2df3bd3747ce9caaf36cba11f3ea9d1ea1b6ca2780c31d1f1d7560cd425cfa7d3a1f96d721c5552f793363363f587dabd7e8a40742b265b783c0ce75015803448eb1024100f3d9ed5e168b2859037afdc20423a85082bf91f6990666667407b17c208656b4cc8396b96f1a7935b5c4f1daaf9769645eea1ae2291bbd1be79184ac32005443024100e7b7d6c2058e69528bb47c3db86c246518e1301e39a5f7301f443cff0750fa9d6cd2df670e319d56f25d10c0499ff1d36dc7ff1cf023c140b57ad7ec8d840869024100b825a3764109f77f38fca132e9d34fa0f50bdc1b6036101060a10aac1517bdd4acf8d652d48f2667a40bc5248323916845b0fe7a39d703b955e7734c623a136702404d74cb69f1d787e75ae1cb020aaac383b3cc5a7c5002e55d05a696c91d15f9a033e74d5c32876d33ca3247ce2f0e3314dcc694c584943f1e354bc9efbde25bb9024066d6c0e4f4798592fdbee884fd879977836b2b030823d703dea14d30da5c9615f95748ea5f55529899963b4052e3666b155f14cf9075b840578a5c6d8a6ba188')))}\n`
    this.message += `${x.verifySignRsa(x.stringToUint8Array("abc"), x.hexStrToUint8Array('d80ca4b995d848d4b8e667804c21dd0735599fa693859d09aeda6d4c81f827a14d73da0c9ebcec7033b2996a307bb649d4ea8b7d468f8aad004e12f7a1105100a1b1d8a3277c0e30ac41f9bf1be80aafb002b786beb19552df7ab7523c97030617492580275c9ec1051b5e661258d7798bc651aeb4a5f92ec4a58701dd063260'), x.hexStrToUint8Array('30819f300d06092a864886f70d010101050003818d0030818902818100dcb8c28991771fdf16d28c14ab4a9347349054a6b28010fd45d00ef920658a259e0078967a03378ee606bd75008d0f5eff5c126f8c32466bcd692cd3fe0f884c0a0d9a40e85b05cfc7e5db215ade847224666442a31f488d7019510e785819f0056c408d9752fe99d9b075891881226bb667aafa59f98d01ad28b588de50a77b0203010001'))}\n\n`
  }

  build() {
    Column({ space: 10 }) {

      Scroll() {
        Text(this.message)
      }.layoutWeight(1).align(Alignment.TopStart).backgroundColor(Color.Yellow).width('100%')
    }
  }
}

class CryptoHelper
{
  /**
   * 生成一个 uuid
   */
  public static uuid(): string {
    return util.generateRandomUUID()
  }

  /**
   * 生成一个随机数，取值范围为 [0, 1)，即大于等于 0 且小于 1
   */
  public static random(): number {
    return Math.random()
  }

  /**
   * 生成一个指定长度的随机的二进制数据
   */
  public static randomKey(len: number): Uint8Array {
    return cryptoFramework.createRandom().generateRandomSync(len).data
  }

  /**
   * 计算指定数据的 sha256 哈希值
   */
  public static sha256(data: Uint8Array): Uint8Array {
    let sha256 = cryptoFramework.createMd('SHA256');
    sha256.updateSync({ data: data });
    let sha256Result = sha256.digestSync();
    return sha256Result.data
  }

  /**
   * 计算指定数据的 md5 哈希值
   */
  public static md5(data: Uint8Array): Uint8Array {
    let md5 = cryptoFramework.createMd('MD5');
    md5.updateSync({ data: data });
    let md5Result = md5.digestSync();
    return md5Result.data
  }

  /**
   * 计算指定路径的文件的 md5 哈希值
   */
  public static md5File(filePath: string): Uint8Array {
    const file = fs.openSync(filePath, fs.OpenMode.READ_ONLY);
    const md5 = cryptoFramework.createMd('MD5');

    const bufferSize = 1 * 1024;
    const buffer = new ArrayBuffer(bufferSize);
    let readLength: number;

    while ((readLength = fs.readSync(file.fd, buffer)) !== 0) {
      const dataBlob: cryptoFramework.DataBlob = {
        data: new Uint8Array(buffer, 0, readLength)
      };
      md5.updateSync(dataBlob);
    }

    fs.closeSync(file);
    const md5Result = md5.digestSync();

    return md5Result.data
  }

  /**
   * 将 hmac 的秘钥数据转为 cryptoFramework.SymKey 对象
   */
  public static getHmacSymKey(keyData: Uint8Array): cryptoFramework.SymKey {
    let symKeyBlob: cryptoFramework.DataBlob = { data: keyData };
    let symKeyGenerator = cryptoFramework.createSymKeyGenerator('HMAC');
    let symKey = symKeyGenerator.convertKeySync(symKeyBlob);
    return symKey
  }
  /**
   * 计算指定数据的 hmac 哈希值
   * hmac 是一种基于密钥的哈希算法，其通过结合哈希函数和密钥对数据进行哈希处理
   */
  public static hmac(data: Uint8Array, keyData: Uint8Array): Uint8Array {
    let symKey = CryptoHelper.getHmacSymKey(keyData);

    let mac = cryptoFramework.createMac('SHA256');
    mac.initSync(symKey);
    mac.updateSync({ data: data });
    let macResult = mac.doFinalSync();

    return macResult.data
  }

  /**
   * 将 aes128 的秘钥数据转为 cryptoFramework.SymKey 对象
   */
  public static getAes128SymKey(keyData: Uint8Array): cryptoFramework.SymKey {
    let symKeyBlob: cryptoFramework.DataBlob = { data: keyData };
    let symKeyGenerator = cryptoFramework.createSymKeyGenerator('AES128');
    let symKey = symKeyGenerator.convertKeySync(symKeyBlob);
    return symKey;
  }
  /**
   * aes 加密
   * 本例演示的 ecb 模式，cbc 模式和 gcm 模式请参见文档
   */
  public static encryptAes(plainData: Uint8Array, keyData: Uint8Array): Uint8Array {
    let plainBlob: cryptoFramework.DataBlob = { data: plainData };
    let symKey = CryptoHelper.getAes128SymKey(keyData)

    let cipher = cryptoFramework.createCipher('AES128|ECB|PKCS7');
    cipher.initSync(cryptoFramework.CryptoMode.ENCRYPT_MODE, symKey, null);
    let cipherData = cipher.doFinalSync(plainBlob);
    return cipherData.data;
  }
  /**
   * aes 解密
   * 本例演示的 ecb 模式，cbc 模式和 gcm 模式请参见文档
   */
  public static decryptAes(cipherData: Uint8Array, keyData: Uint8Array): Uint8Array {
    let cipherBlog: cryptoFramework.DataBlob = { data: cipherData };
    let symKey = CryptoHelper.getAes128SymKey(keyData)

    let cipher = cryptoFramework.createCipher('AES128|ECB|PKCS7');
    cipher.initSync(cryptoFramework.CryptoMode.DECRYPT_MODE, symKey, null);
    let plainData = cipher.doFinalSync(cipherBlog);
    return plainData.data;
  }

  /**
   * 随机生成 rsa1024 的密钥对，返回一个 cryptoFramework.KeyPair 对象
   */
  public static generateRsaKeyPair(): cryptoFramework.KeyPair {
    let asyKeyGenerator = cryptoFramework.createAsyKeyGenerator('RSA1024');
    let keyPair = asyKeyGenerator.generateKeyPairSync();
    return keyPair;
  }
  /**
   * 将 rsa1024 的指定的公钥数据和私钥数据转为 cryptoFramework.KeyPair 对象
   */
  public static getRsaKeyPair(publicKeyData: Uint8Array | null, privateKeyData: Uint8Array | null): cryptoFramework.KeyPair {
    let publicKeyBlob: cryptoFramework.DataBlob | null = publicKeyData ? { data: publicKeyData } : null;
    let privateKeyBlob: cryptoFramework.DataBlob | null = privateKeyData? { data: privateKeyData } : null;
    let asyKeyGenerator = cryptoFramework.createAsyKeyGenerator('RSA1024');
    let keyPair = asyKeyGenerator.convertKeySync(publicKeyBlob, privateKeyBlob);
    return keyPair;
  }
  /**
   * rsa 加密，通过公钥加密
   */
  public static encryptRsa(plainData: Uint8Array, publicKeyData: Uint8Array): Uint8Array {
    let plainBlog: cryptoFramework.DataBlob = { data: plainData };
    let publicKey = CryptoHelper.getRsaKeyPair(publicKeyData, null).pubKey

    let cipher = cryptoFramework.createCipher('RSA1024|PKCS1');
    cipher.initSync(cryptoFramework.CryptoMode.ENCRYPT_MODE, publicKey, null);
    let cipherData = cipher.doFinalSync(plainBlog);
    return cipherData.data;
  }
  /**
   * rsa 解密，通过私钥解密
   */
  public static decryptRsa(cipherData: Uint8Array, privateKeyData: Uint8Array): Uint8Array {
    let cipherBlog: cryptoFramework.DataBlob = { data: cipherData };
    let privateKey = CryptoHelper.getRsaKeyPair(null, privateKeyData).priKey

    let cipher = cryptoFramework.createCipher('RSA1024|PKCS1');
    cipher.initSync(cryptoFramework.CryptoMode.DECRYPT_MODE, privateKey, null);
    let plainData = cipher.doFinalSync(cipherBlog);
    return plainData.data;
  }
  /**
   * rsa 私钥签名
   * 注：如果源数据较大，可以对源数据的哈希值做签名
   */
  public static signRsa(plainData: Uint8Array, privateKeyData: Uint8Array): Uint8Array {
    let plainBlog: cryptoFramework.DataBlob = { data: plainData };
    let privateKey = CryptoHelper.getRsaKeyPair(null, privateKeyData).priKey

    let sign = cryptoFramework.createSign("RSA1024|PKCS1|SHA256");
    sign.initSync(privateKey);
    let signData = sign.signSync(plainBlog);
    return signData.data;
  }
  /**
   * rsa 公钥验证签名
   */
  public static verifySignRsa(plainData: Uint8Array, signData: Uint8Array, publicKeyData: Uint8Array): boolean {
    let plainBlog: cryptoFramework.DataBlob = { data: plainData };
    let signBlob: cryptoFramework.DataBlob = { data: signData };
    let publicKey = CryptoHelper.getRsaKeyPair(publicKeyData, null).pubKey

    let verify = cryptoFramework.createVerify("RSA1024|PKCS1|SHA256");
    verify.initSync(publicKey);
    let result = verify.verifySync(plainBlog, signBlob);
    return result;
  }



  public static stringToUint8Array(str: string): Uint8Array {
    let textEncoder = util.TextEncoder.create('utf-8');
    return textEncoder.encodeInto(str);
  }

  public static uint8ArrayToString(input: Uint8Array): string {
    let textDecoder = util.TextDecoder.create('utf-8');
    return textDecoder.decodeToString(input);
  }

  public static base64ToUint8Array(str: string): Uint8Array {
    let base64Helper = new util.Base64Helper();
    return base64Helper.decodeSync(str);
  }

  public static uint8ArrayToBase64(input: Uint8Array): string {
    let base64Helper = new util.Base64Helper();
    return base64Helper.encodeToStringSync(input);
  }

  public static hexStrToUint8Array(data: string): Uint8Array {
    return new Uint8Array(buffer.from(data, 'hex').buffer);
  }

  public static uint8ArrayToHexStr(input: Uint8Array): string {
    let bufferStr = buffer.from(input).toString('hex');
    return bufferStr;
  }

  public static arrayBufferToUint8Array(arrayBuffer: ArrayBuffer): Uint8Array {
    return new Uint8Array(arrayBuffer);
  }

  public static uint8ArrayToArrayBuffer(uint8Array: Uint8Array): ArrayBuffer {
    return uint8Array.buffer;
  }
}