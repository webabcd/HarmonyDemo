/*
 * 路径动画
 *
 * motionPath() - 设置位移动画时的运动路径
 */

import { TitleBar } from '../TitleBar'

@Entry
@Component
struct MotionPathDemo {

  @State translateY: number = 0

  build() {
    Column({space:20}) {
      TitleBar()

      Path({ width: 200, height: 200 })
        .commands('M100 15 L123.51 80.71 L195 85 L139.29 134.29 L141.42 195 L100 150 L58.58 195 L60.71 134.29 L25 85 L86.49 80.71 Z')
        .stroke(Color.Red)
        .strokeWidth(1)
        .fill(Color.Transparent)

      Button('button')
        .translate({ y: this.translateY })
        /*
         * motionPath() - 设置位移动画时的运动路径
         *   path - 路径，其与 svg(Scalable Vector Graphics) 的 path 是一样的
         *   from - 路径起点（0 - 1 之间）
         *   to - 路径终点（0 - 1 之间）
         *   rotatable - 组件在动画过程中是否跟随路径进行旋转
         */
        .motionPath({
          path: 'M100 15 L123.51 80.71 L195 85 L139.29 134.29 L141.42 195 L100 150 L58.58 195 L60.71 134.29 L25 85 L86.49 80.71 Z',
          from: 0.0,
          to: 1.0,
          rotatable: true
        })
        .onClick(() => {
          animateTo({
            duration: 10000,
            curve: Curve.Linear,
            iterations: -1
          }, () => {
            // 这句是为了启动动画
            this.translateY = 1
          })
        })
    }
  }
}

