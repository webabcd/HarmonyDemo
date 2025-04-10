/*
 * 卡片对应的 extension ability
 * 用于管理卡片的生命周期，以及和卡片做数据交互
 */

import { formBindingData, FormExtensionAbility, formProvider } from '@kit.FormKit';
import { Want } from '@kit.AbilityKit';
import { Helper } from '../utils/Helper';
import { MyLog } from '../utils/MyLog';
import { BusinessError } from '@kit.BasicServicesKit';
import { fileIo as fs } from '@kit.CoreFileKit';

export default class EntryFormAbility extends FormExtensionAbility {

  // 将指定的资源文件复制到指定的沙箱目录
  copyFile(src: Resource, dst: string) {
    let resourceManager = this.context.getApplicationContext().resourceManager
    let buffer = resourceManager.getMediaContentSync(src.id).buffer
    let outputStream = fs.createStreamSync(dst, 'w+');
    let writeLength = outputStream.writeSync(buffer, {
      offset: 0,
      length: buffer.byteLength
    })
    outputStream.closeSync();
  }

  // 卡片创建时的回调
  onAddForm(want: Want) {

    // 通过 want.parameters 可以获取卡片的规格，以及宽和高等
    MyLog.d(`onAddForm ${JSON.stringify(want.parameters)}`)

    // 将指定的资源文件复制到指定的沙箱目录
    // 如果需要卡片显示一个网络图片，则可以先将图片下载到沙箱目录（注：卡片每次活过来后，最多在后台存在 5 秒），然后再参照本例后续的方法
    let imagePath = this.context.getApplicationContext().filesDir + '/icon.png'
    this.copyFile($r('app.media.app_icon'), imagePath)

    // 创建一个保存多张图片的字典表，用于在卡片中显示图片
    // key 代表图片的标识
    // value 代表图片的文件描述符，打开文件到内存后，把文件描述符传给卡片，然后卡片再根据文件描述符显示内存中的图片
    let formImages: Record<string, number> = {};
    let file = fs.openSync(imagePath);
    formImages['myImage_0'] = file.fd; // 注意：如果图片更新了，则这里需要指定一个和之前不同的 key 以便卡片可以显示更新后的图片

    /*
     * formBindingData.createFormBindingData() - 创建一个 FormBindingData 对象
     *   此对象中的字段的值，可以在卡片中通过 @LocalStorageProp 引用
     */
    let formData: Record<string, string | Record<string, number>> = {
      'formId': `${want.parameters!['ohos.extra.param.key.form_identity']}`, // 卡片 id
      'dimension': `${want.parameters!['ohos.extra.param.key.form_dimension']}`, // 卡片的规格（1代表1*2, 2代表2*2, 3代表2*4, 4代表4*4, 7代表6*4）
      'width': `${want.parameters!['ohos.extra.param.key.form_width']}`, // 卡片的宽
      'height': `${want.parameters!['ohos.extra.param.key.form_height']}`, // 卡片的高
      'content': Helper.getTimestampString(), // 卡片中可以通过 @LocalStorageProp('content') 引用此值
      'myImage': 'myImage_0', // 指定在 formImages 中的指定 key 的图片，然后在卡片中可以通过 @LocalStorageProp('myImage') 引用此图片
      'formImages': formImages // 保存多张图片的字典表
    };
    return formBindingData.createFormBindingData(formData);
  }

  // 刷新时会执行 onUpdateForm() 回调
  // 当时间符合 scheduledUpdateTime 或 updateDuration 的条件时会触发刷新
  // 当系统语言或深色浅色模式发生变化时也会触发刷新
  // 卡片每次活过来后，最多在后台存在 5 秒
  onUpdateForm(formId: string) {

    MyLog.d(`onUpdateForm: ${formId}`)

    /*
     * formBindingData.createFormBindingData() - 创建一个 FormBindingData 对象
     *   此对象中的字段的值，可以在卡片中通过 @LocalStorageProp 引用
     * formProvider.updateForm() - 更新指定的卡片
     *   formId - 卡片 id
     *   formBindingData - 为卡片绑定的 FormBindingData 对象
     * formProvider.setFormNextRefreshTime() - 指定下一次刷新的时间（注：卡片每天最多刷新 50 次）
     *   formId - 卡片 id
     *   minute - 此时间后刷新（单位：分钟），最短为 5 分钟
     */
    let formData: Record<string, string> = {
      'content': Helper.getTimestampString() // 卡片中可以通过 @LocalStorageProp('content') 引用此值
    };
    let formInfo: formBindingData.FormBindingData = formBindingData.createFormBindingData(formData)
    formProvider.updateForm(formId, formInfo)

    try {
      // 设置过 5 分钟后刷新卡片
      formProvider.setFormNextRefreshTime(formId, 5, (err: BusinessError) => {

      })
    } catch (err) {

    }
  }

  onFormEvent(formId: string, message: string) {
    MyLog.d(`onFormEvent: ${formId}, ${message}`)

    let formData: Record<string, string> = {
      'content': Helper.getTimestampString() // 卡片中可以通过 @LocalStorageProp('content') 引用此值
    };
    let formInfo: formBindingData.FormBindingData = formBindingData.createFormBindingData(formData)
    formProvider.updateForm(formId, formInfo)
  }

  // 卡片销毁时的回调
  onRemoveForm(formId: string) {
    MyLog.d(`onRemoveForm: ${formId}`)
  }
};