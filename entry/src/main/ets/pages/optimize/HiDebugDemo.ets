/**
 * HiDebug（用于获取 cpu, 内存等信息）
 */

import { TitleBar } from '../TitleBar'
import { hidebug } from '@kit.PerformanceAnalysisKit'
import { Helper } from '../../utils/Helper'

@Entry
@Component
struct HiDebugDemo {

  build() {
    Column({ space: 10 }) {
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

  build() {
    Column({ space: 10 }) {

      Button('获取 cpu, 内存等信息').onClick(() => {
        try {
          /*
           * hidebug - 用于获取 cpu, 内存等信息
           *   getSystemCpuUsage() - 当前的 cpu 的占用比例
           *   getSystemMemInfo() - 当前的内存信息（一个 SystemMemInfo 对象）
           *     totalMem - 总内存，单位：KB
           *     freeMem - 空闲内存（即未被使用的内存），单位：KB
           *     availableMem - 可用内存（即空闲内存加上可快速回收利用的内存），单位：KB
           *   getCpuUsage() - 当前进程的 cpu 的占用比例
           *   getAppNativeMemInfo() - 当前进程的内存信息（一个 NativeMemInfo 对象）
           *     rss - 当前进程实际占用的物理内存，单位：KB
           *       其会包括共享库占用的所有的物理内存
           *     pss - 当前进程实际占用的物理内存，单位：KB
           *       其会按比例分摊共享库占用的物理内存，比如有 5 个进程共享一个 10MB 的库，则每个进程的 pss 中会包含该库的 2MB
           *     vss - 当前进程实际占用的虚拟内存，单位：KB
           *       其会包括共享库占用的所有的虚拟内存，这个虚拟内存既包括已经被分配了物理内存的部分，也包括尚未分配物理内存的部分
           */
          this.message += `getSystemCpuUsage: ${hidebug.getSystemCpuUsage()}\n`
          this.message += `totalMem: ${Helper.formatWithThousandSeparator(hidebug.getSystemMemInfo().totalMem)}\n`
          this.message += `freeMem: ${Helper.formatWithThousandSeparator(hidebug.getSystemMemInfo().freeMem)}\n`
          this.message += `availableMem: ${Helper.formatWithThousandSeparator(hidebug.getSystemMemInfo().availableMem)}\n`

          this.message += `getCpuUsage: ${hidebug.getCpuUsage()}\n`
          this.message += `rss: ${Helper.formatWithThousandSeparator(hidebug.getAppNativeMemInfo().rss)}\n`
          this.message += `pss: ${Helper.formatWithThousandSeparator(hidebug.getAppNativeMemInfo().pss)}\n`
          this.message += `vss: ${Helper.formatWithThousandSeparator(hidebug.getAppNativeMemInfo().vss)}\n`
        } catch (error) {
          this.message = `${JSON.stringify(error)}`
        }
      })

      Text(this.message)
    }
  }
}
