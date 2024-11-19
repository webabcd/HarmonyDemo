/*
 * CheckboxGroup - 多选框组
 *   同组多选框都是选中状态，则多选框组是选中状态
 *   同组多选框都是未选中状态，则多选框组是未选中状态
 *   同组多选框有一部分是选中状态，则多选框组是部分选中状态
 */

import { TitleBar } from '../../TitleBar';

@Entry
@Component
struct CheckboxGroupDemo {

  @State message:string = ""

  build() {
    Column({ space: 10 }) {
      TitleBar()

      /*
       * CheckboxGroup - 多选框组
       *   group - 组名
       *   selectAll() - 是否选中同组的所有 Checkbox
       *   selectedColor() - 选中时的背景色
       *   backgroundColor() - 未选中时的背景色
       *   unselectedColor() - 未选中时的边框的颜色
       *   checkboxShape() - 多选框组的形状（CheckBoxShape 枚举）
       *     CIRCLE - 圆形
       *     ROUNDED_SQUARE - 圆角方形
       *   onChange() - 选中状态发生变化时的回调（回调参数是一个 CheckboxGroupResult 接口）
       *     name - 当前同组的所有被选中的 Checkbox 的名字数组
       *     status - 当前 CheckboxGroup 的状态（SelectStatus）
       *       All - 选中状态
       *       Part - 部分选中状态
       *       None - 未选中状态
       *   mark() - 多选框组中的对钩的样式（MarkStyle 接口）
       *     strokeColor - 对钩的颜色
       *     size - 对钩的大小
       *     strokeWidth - 对钩的画笔宽度
       *
       * Checkbox - 多选框
       *   name - 多选框的名字
       *   group - 组名
       *
       * 注：
       * 1、组名相同的 Checkbox 和 CheckboxGroup 是一组
       * 2、通过 contentModifier() 实现自定义 CheckboxGroup 的方法与自定义 Checkbox 是一样的，详见 CheckboxDemo.ets 中的说明
       */
      CheckboxGroup({ group: 'checkboxGroup' }).width(50).height(50)
        .selectAll(true)
        .selectedColor(Color.Orange)
        .unselectedColor(Color.Red)
        .checkboxShape(CheckBoxShape.ROUNDED_SQUARE)
        .onChange((event: CheckboxGroupResult) => {
          this.message = `name:${event.name}, status:${event.status}`
        })
        .mark({
          strokeColor: Color.Blue,
          size: 30,
          strokeWidth: 5
        })

      Checkbox({ name: 'checkbox1', group: 'checkboxGroup' })
        .selectedColor(Color.Red)
        .onChange((value: boolean) => {

        })

      Checkbox({ name: 'checkbox2', group: 'checkboxGroup' })
        .selectedColor(Color.Red)
        .onChange((value: boolean) => {

        })

      Checkbox({ name: 'checkbox3', group: 'checkboxGroup' })
        .selectedColor(Color.Red)
        .onChange((value: boolean) => {

        })

      Text(this.message).fontSize(16)
    }
  }
}