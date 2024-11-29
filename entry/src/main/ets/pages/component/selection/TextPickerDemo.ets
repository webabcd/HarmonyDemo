/*
 * TextPicker - 文本选择框
 */

import { TitleBar } from '../../TitleBar'

@Entry
@Component
struct TextPickerDemo {

  @State message:string = ""

  // 用于演示级联文本选择的数据源
  // TextCascadePickerRangeContent - 用于构造级联文本数据
  private cascade: TextCascadePickerRangeContent[] = [
    {
      text: '辽宁省',
      children: [
        { text: '沈阳市', children: [{ text: '沈河区' }, { text: '和平区' }, { text: '浑南区' }] },
        { text: '大连市', children: [{ text: '中山区' }, { text: '金州区' }, { text: '长海县' }] },
      ]
    },
    {
      text: '吉林省',
      children: [
        { text: '长春市', children: [{ text: '南关区' }, { text: '宽城区' }, { text: '朝阳区' }] },
        { text: '四平市', children: [{ text: '铁西区' }, { text: '铁东区' }, { text: '梨树县' }] },
      ]
    },
    {
      text: '黑龙江省',
      children: [
        { text: '哈尔滨市', children: [{ text: '道里区' }, { text: '道外区' }, { text: '南岗区' }] },
        { text: '牡丹江市', children: [{ text: '东安区' }, { text: '西安区' }, { text: '爱民区' }] },
      ]
    }
  ]

  build() {
    Column({ space: 10 }) {
      TitleBar()

      Text(this.message).fontSize(16)

      /*
       * TextPicker - 文本选择框
       *   range - 可选文本列表
       *   selected - 选中项的索引位置
       *   canLoop() - 是否可循环滚动
       *   divider() - 选项之间的分隔线
       *     strokeWidth, color, startMargin, endMargin
       *     注：如果需要隐藏分隔线的话，就 divider(null) 即可
       *   selectedTextStyle() - 选中时间的文本样式
       *   disappearTextStyle() - 选中时间的最上和最下的时间的文本样式
       *   textStyle() - 除了选中时间和选中时间的最上和最下的时间之外的时间的文本样式
       *   onChange() - 选中文本变化时的回调
       *     value - 当前选中的文本
       *     index - 当前选中的文本的索引位置
       */
      TextPicker({
        range: ['aaa', 'bbb', 'ccc', 'ddd', 'eee'],
        selected: 3,
      })
        .canLoop(true)
        .divider({
          strokeWidth: 2,
          color: Color.Orange,
          startMargin: 2,
          endMargin: 2,
        })
        .textStyle({
          color: Color.Red,
          font: {
            size: '18',
            weight: 400,
          }
        })
        .disappearTextStyle({
          color: Color.Green,
          font: {
            size: '22',
            weight: 400,
          }
        })
        .selectedTextStyle({
          color: Color.Blue,
          font: {
            size: '14',
            weight: 400,
          }
        })
        .onChange((value: string | string[], index: number | number[]) => {
          this.message = `onChange ${value} ${index}`
        })

      /*
       * 多列文本选择的示例
       */
      TextPicker({
        range: [['aaa', 'bbb', 'ccc', 'ddd', 'eee'], ['111', '222', '333', '444', '555']],
        selected: [1, 2]
      })

      /*
       * 级联文本选择的示例
       */
      TextPicker({ range: this.cascade })
    }
  }
}