/*
 * FormLink - 为静态卡片提供与应用交互的功能
 */

import { TitleBar } from '../TitleBar';

@Entry
@Component
struct FormLinkDemo {

  @State message: string = "FormLink 的演示请参见：\n" +
    "/entryformability/EntryFormAbility.ets\n" +
    "/widget/pages/FormLinkCard.ets"

  build() {
    Column({space:10}) {
      TitleBar()
      Text(this.message)
    }
  }
}
