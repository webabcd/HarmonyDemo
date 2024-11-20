/*
 * Badge - 标记
 */

import { TitleBar } from '../../TitleBar'

@Entry
@Component
struct BadgeDemo {

  build() {
    Column({ space: 10 }) {
      TitleBar()

      /*
       * Badge - 标记（参数为 BadgeParamWithString 类型）
       *   value - 标记显示的文字，指定为空的话就是一个圆形
       *   position - 标记显示的位置（BadgePosition 枚举）
       *     RightTop, Right, Left
       *   style - 样式
       *     badgeSize, badgeColor - 标记的大小和颜色
       *     borderWidth, borderColor - 标记的边框的宽度和颜色
       *     fontSize, fontWeight - 标记上显示的文字的大小和粗细
       */
      Badge({
        value: '',
        position: BadgePosition.RightTop,
        style: {
          badgeSize: 24,
          badgeColor: Color.Red,
          borderWidth: 5,
          borderColor: Color.Orange,
        }
      }) {
        Image($r('app.media.son')).width(100).height(100)
      }

      Badge({
        value: 'new',
        position: BadgePosition.Right,
        style: {
          badgeSize: 48,
          badgeColor: Color.Red,
          color: Color.Green,
          fontSize: 24,
          fontWeight: FontWeight.Bold,
          borderWidth: 2,
          borderColor: Color.Orange,
        }
      }) {
        Image($r('app.media.son')).width(100).height(100)
      }
      .width(160)

      /*
       * Badge - 标记（参数为 BadgeParamWithNumber 类型）
       *   count - 标记上显示的数字
       *   maxCount - 标记上允许显示的数字的最大值
       */
      Badge({
        count: 100, // 会显示 88+
        maxCount: 88,
        position: BadgePosition.RightTop,
        style: {
          badgeSize: 48,
          badgeColor: Color.Red,
          color: Color.Green,
          fontSize: 24,
          fontWeight: FontWeight.Bold,
          borderColor: Color.Orange,
          borderWidth: 2,
        }
      }) {
        Image($r('app.media.son')).width(100).height(100)
      }

      /*
       * Badge - 标记
       *   position - 位置也可以指定 x, y 值，用于描述标记以左上角为原点位置时的偏移位置
       */
      Badge({
        count: 10,
        position: {
          x: 10,
          y: 10,
        },
        style: {
          badgeSize: 48,
          fontSize: 24,
        }
      }) {
        Image($r('app.media.son')).width(100).height(100)
      }
    }
  }
}