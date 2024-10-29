/*
 * 剪裁相关和遮罩相关
 */

import { TitleBar } from '../TitleBar';

@Entry
@Component
struct ClipDemo {

  progressMaskValue: number = 0.0
  // ProgressMask - 进度遮罩
  //   第 1 个参数：当前的进度值
  //   第 2 个参数：最大的进度值（注：最小进度值为 0.0）
  //   第 3 个参数：遮罩的颜色
  @State progressMask: ProgressMask = new ProgressMask(this.progressMaskValue, 100.0, Color.Gray);

  build() {
    Column({ space: 10 }) {
      TitleBar()

      // clip(false) - Column 组件的圆角不会限制其内的 Image 组件的显示
      Column() {
        Image($r('app.media.son')).width(200).height(50)
      }
      .borderRadius(20)
      .clip(false)

      // clip(true) - Column 组件的圆角会限制其内的 Image 组件的显示
      Column() {
        Image($r('app.media.son')).width(200).height(50)
      }
      .borderRadius(20)
      .clip(true)

      // clipShape() - 设置剪裁的图形
      //   剪裁的图形可以是 Circle, Ellipse, Rect, Path
      Image($r('app.media.son')).width(200).height(50)
        .clipShape(new Circle({ width: 50, height: 50 }))

      // 通过 offset() 指定剪裁图形的位置
      Image($r('app.media.son')).width(200).height(50)
        .clipShape(new Circle({ width: 50, height: 50 }).offset({ x: 75, y: 0 }))

      // maskShape() - 设置剪裁的图形，以及剪裁图形的遮罩颜色
      //   剪裁的图形可以是 Circle, Ellipse, Rect, Path
      //   通过 offset() 指定剪裁图形的位置
      //   通过 fill() 指定剪裁图形的遮罩颜色（0x000000全透明，0xffffff全不透明）
      Image($r('app.media.son')).width(200).height(50)
        .maskShape(new Circle({ width: 50, height: 50 }).offset({ x: 75, y: 0 }).fill(0xcccccc))

      // mask() - 可以指定一个 ProgressMask 类型的遮罩
      //   注：我这里测试，这个遮罩只能是圆形的
      Image($r('app.media.son')).width(200).height(200)
        .borderRadius(100)
        .mask(this.progressMask)
      Button('不停地点我')
        .onClick(() => {
          this.progressMaskValue += 10.0
          if (this.progressMaskValue > 100.0) {
            this.progressMaskValue = 0.0
          }
          // 更新 ProgressMask 的进度
          this.progressMask.updateProgress(this.progressMaskValue)
          // 更新 ProgressMask 的颜色
          this.progressMask.updateColor(Math.floor(Math.random() * (0xffffff + 1)));
          // 当 ProgressMask 的进度到了百分之百时，是否显示光晕动画
          this.progressMask.enableBreathingAnimation(true);
        })
    }
  }
}