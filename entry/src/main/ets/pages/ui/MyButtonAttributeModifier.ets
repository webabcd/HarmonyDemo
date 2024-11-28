// 本例用于演示如何通过 AttributeModifier 的方式使用其他文件中定义的样式
// 引用了此文件的代码在 StyleDemo.ets
export class MyButtonAttributeModifier implements AttributeModifier<ButtonAttribute> {
  isDark: boolean = false

  /*
   * applyNormalAttribute - normal 状态的样式
   * applyPressedAttribute - pressed 状态的样式
   * applySelectedAttribute - selected 状态的样式
   * applyDisabledAttribute - disabled 状态的样式
   * applyFocusedAttribute - focused 状态的样式
   */

  applyNormalAttribute(instance: ButtonAttribute): void {
    if (this.isDark) {
      instance.foregroundColor(Color.White)
      instance.backgroundColor(Color.Black)
    } else {
      instance.foregroundColor(Color.Black)
      instance.backgroundColor(Color.Yellow)
    }
  }
  applyPressedAttribute(instance: ButtonAttribute): void {
    if (this.isDark) {
      instance.foregroundColor(Color.Yellow)
      instance.backgroundColor(Color.Blue)
    } else {
      instance.foregroundColor(Color.Red)
      instance.backgroundColor(Color.Orange)
    }
  }
}