/*
 * Rating - 评分框
 */

import { TitleBar } from '../../TitleBar';

@Entry
@Component
struct RatingDemo {

  build() {
    Column() {
      TitleBar()
      Tabs() {
        TabContent() { MySample1() }.tabBar('基础').align(Alignment.Top)
        TabContent() { MySample2() }.tabBar('自定义').align(Alignment.Top)
      }
      .scrollable(true)
      .barMode(BarMode.Scrollable)
    }
  }
}

@Component
struct MySample1 {

  @State message:string = ""

  build() {
    Column({ space: 10 }) {

      Text(this.message).fontSize(16)

      /*
       * Rating - 评分框
       *   rating - 评分值
       *   indicator - 是否仅用于显示
       *     true - 仅用于显示评分，无法进行评分
       *     false - 可以进行评分
       *   stars() - 星星的总数量
       *   stepSize() - 评分的步长
       *   onChange() - 评分值发生变化时的回调
       *     value - 当前的评分值
       *   starStyle() - 自定义星星的图片
       *     backgroundUri - 无分时的图片地址
       *     secondaryUri - 半分时的图片地址
       *     foregroundUri - 满分时的图片地址
       */

      Rating({ rating: 1.5, indicator: false })
        .stars(5)
        .stepSize(0.5)
        .onChange((value: number) => {
          this.message = `value:${value}`
        })

      Rating({ rating: 1.5, indicator: false })
        .stars(5)
        .stepSize(0.5)
        .starStyle({
          backgroundUri: '/pages/component/selection/star1.png',
          secondaryUri: '/pages/component/selection/star2.png',
          foregroundUri: '/pages/component/selection/star3.png',
        })
    }
  }
}

@Component
struct MySample2 {

  build() {
    Column({ space: 10 }) {

      Rating({ rating: 2, indicator: false }).stars(5).stepSize(1)
        // 通过 contentModifier() 实现自定义 Rating（指定一个实现了 ContentModifier 接口的对象）
        .contentModifier(new MyRatingModifier(Color.Blue))
        .onChange((value: number) => {

        })
    }
  }
}

// 实现 ContentModifier 接口
class MyRatingModifier implements ContentModifier<RatingConfiguration> {

  // 自定义属性
  color: Color = Color.Red
  // 构造函数
  constructor(color: Color) {
    this.color = color
  }

  // 返回指定的自定义 Rating
  applyContent() : WrappedBuilder<[RatingConfiguration]> {
    return wrapBuilder(buildRating)
  }
}

// 自定义 Rating
@Builder function buildRating(config: RatingConfiguration) {
  /*
   * RatingConfiguration - 自定义 Rating 的相关信息
   *   enabled - 是否可用
   *   contentModifier - 绑定的 ContentModifier 对象
   *   rating - 评分值
   *   indicator - 是否仅用于显示
   *   stars - 星星的总数量
   *   stepSize - 评分的步长
   *   triggerChange() - 触发 Rating 的 onChange() 回调
   */
  Row() {
    ForEach([1, 2, 3, 4, 5], (item: number, index: number) => {
      Circle({ width: 30, height: 30 })
        .fill(config.rating >= item ? (config.contentModifier as MyRatingModifier).color : Color.White)
        .borderWidth(2)
        .borderRadius(15)
        .borderColor((config.contentModifier as MyRatingModifier).color)
        .onClick((event: ClickEvent) => {
          config.triggerChange(item);
        })
    })
  }
}